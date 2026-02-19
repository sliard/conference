#!/bin/bash
#
# Convert images in legacy archives (2021-2024)
# Handles: conversion, URL replacement, source deletion
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

QUALITY=85
CONVERTED=0
FAILED=0
DELETED=0
FIXED_URLS=0

DRY_RUN=false

# Parse args
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}DRY RUN MODE - No files will be modified${NC}"
fi

echo -e "${GREEN}=== Legacy Archive Image Converter ===${NC}"
echo ""

# Check dependencies
if ! command -v cwebp &> /dev/null || ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: cwebp and ImageMagick required${NC}"
    exit 1
fi

# Convert images in a directory
convert_directory() {
    local dir="$1"
    local name="$2"

    echo -e "${BLUE}Processing $name...${NC}"

    if [[ ! -d "$dir" ]]; then
        echo -e "${YELLOW}  Skipped: directory not found${NC}"
        return
    fi

    local count=0
    while IFS= read -r -d '' file; do
        local webp="${file%.*}.webp"

        # Skip if already exists and up-to-date
        if [[ -f "$webp" && "$webp" -nt "$file" ]]; then
            continue
        fi

        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would convert: $(basename "$file")"
            ((count++))
            continue
        fi

        # Try cwebp first
        if cwebp -q "$QUALITY" "$file" -o "$webp" 2>/dev/null; then
            ((CONVERTED++))
            ((count++))
        else
            # Fallback to ImageMagick for problematic files
            if convert "$file" -colorspace sRGB "$webp" 2>/dev/null; then
                ((CONVERTED++))
                ((count++))
                echo "  Used ImageMagick fallback for $(basename "$file")"
            else
                ((FAILED++))
                echo -e "${RED}  Failed: $(basename "$file")${NC}"
            fi
        fi
    done < <(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 2>/dev/null)

    if [[ $count -gt 0 ]]; then
        echo -e "${GREEN}  Converted $count images in $name${NC}"
    fi
}

# Fix absolute URLs in HTML files
fix_absolute_urls() {
    local file="$1"
    local year="$2"

    if [[ ! -f "$file" ]]; then
        return
    fi

    if ! grep -q "https://devfest.codedarmor.fr/assets/$year" "$file" 2>/dev/null; then
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would fix absolute URLs in: $file"
        return
    fi

    # Create backup
    cp "$file" "${file}.bak.$(date +%s)"

    # Replace absolute URLs with relative paths
    sed -i "s|https://devfest.codedarmor.fr/assets/$year/|./|g" "$file"

    ((FIXED_URLS++))
    echo -e "${GREEN}Fixed absolute URLs in: $file${NC}"
}

# Replace image references in a file
replace_refs_in_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return
    fi

    local content
    content=$(cat "$file" 2>/dev/null) || return
    local new_content="$content"
    local modified=0

    # Find JPG/PNG references (simpler pattern)
    local refs
    refs=$(echo "$content" | grep -oE '[a-zA-Z0-9_/.:-]+\.(jpg|jpeg|png)(\?[a-zA-Z0-9=\u0026-]+)?' || true)

    for ref in $refs; do
        [[ -z "$ref" ]] && continue
        [[ "$ref" == *.webp ]] && continue

        local file_dir
        file_dir=$(dirname "$file")
        local webp_ref="${ref%.*}.webp"

        # Check if WebP exists
        if [[ -f "$file_dir/$webp_ref" || -f "$webp_ref" ]]; then
            local base="${ref%.*}"
            local new_ref="${base}.webp"

            if [[ "$DRY_RUN" == true ]]; then
                echo "    Would replace: $ref -> $new_ref"
                modified=1
            else
                # Replace
                new_content=$(echo "$new_content" | sed "s|$ref|$new_ref|g")
                modified=1
            fi
        fi
    done

    if [[ $modified -eq 1 && "$DRY_RUN" == false ]]; then
        echo "$new_content" > "$file"
        echo "  Updated references in: $(basename "$file")"
    fi
}

# Delete converted source files
delete_sources() {
    local dir="$1"
    local name="$2"

    echo -e "${BLUE}Cleaning up source files in $name...${NC}"

    local deleted=0

    while IFS= read -r -d '' src_file; do
        local webp_file="${src_file%.*}.webp"

        if [[ -f "$webp_file" && -s "$webp_file" && "$webp_file" -nt "$src_file" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "  Would delete: $(basename "$src_file")"
                ((deleted++))
            else
                rm -f "$src_file"
                ((deleted++))
            fi
        fi
    done < <(find "$dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -print0 2>/dev/null)

    if [[ $deleted -gt 0 ]]; then
        echo "  Deleted $deleted source files"
        DELETED=$((DELETED + deleted))
    fi
}

# Copy favicons to archives that need them
copy_favicons() {
    local year="$1"
    local dir="assets/$year"

    [[ "$DRY_RUN" == true ]] && return

    # 2021 and 2022 need favicon.ico in img/
    if [[ "$year" == "2021" || "$year" == "2022" ]]; then
        if [[ -f "favicon.ico" && -d "$dir/img" && ! -f "$dir/img/favicon.ico" ]]; then
            cp favicon.ico "$dir/img/favicon.ico"
            echo "  Copied favicon.ico to $dir/img/"
        fi
    fi

    # 2024 devfestnoz needs webp favicons
    if [[ "$year" == "2024" ]]; then
        if [[ -f "favicon-32x32.png" && -d "$dir/devfestnoz" ]]; then
            if [[ ! -f "$dir/devfestnoz/favicon-32x32.webp" ]]; then
                cwebp -q 85 favicon-32x32.png -o "$dir/devfestnoz/favicon-32x32.webp" 2>/dev/null || true
            fi
            if [[ ! -f "$dir/devfestnoz/favicon-16x16.webp" ]]; then
                cwebp -q 85 favicon-16x16.png -o "$dir/devfestnoz/favicon-16x16.webp" 2>/dev/null || true
            fi
        fi
    fi
}

# Process a year archive
process_year() {
    local year="$1"
    local dir="assets/$year"

    echo ""
    echo -e "${GREEN}=== Processing $year Archive ===${NC}"

    # Convert images
    convert_directory "$dir/img/speakers" "$year - Speakers"
    convert_directory "$dir/img/partners" "$year - Partners"
    [[ -d "$dir/img/sponsors" ]] && convert_directory "$dir/img/sponsors" "$year - Sponsors"
    [[ -d "$dir/img/photos_event" ]] && convert_directory "$dir/img/photos_event" "$year - Gallery"
    [[ -d "$dir/img/favicon" ]] && convert_directory "$dir/img/favicon" "$year - Favicons"

    # Fix absolute URLs
    fix_absolute_urls "$dir/index.html" "$year"

    # Replace image references in HTML files
    while IFS= read -r -d '' html; do
        [[ -f "$html" ]] && replace_refs_in_file "$html"
    done < <(find "$dir" -name "*.html" -type f -print0 2>/dev/null)

    # Delete source files
    delete_sources "$dir" "$year"

    # Copy favicons
    copy_favicons "$year"
}

# Main processing
echo "Converting legacy archives..."
echo ""

# Process each year
process_year "2021"
process_year "2022"
process_year "2023"
process_year "2024"

# Also process nested 2024 structures
convert_directory "assets/2024/devfest/assets/img/speakers" "2024 DevFest - Speakers"
convert_directory "assets/2024/devfest/assets/img/partners" "2024 DevFest - Partners"
convert_directory "assets/2024/devfest/assets/img/photos_event" "2024 DevFest - Gallery"
convert_directory "assets/2024/devfestnoz/assets/img" "2024 DevFestNoz"

# Update references in 2024 devfest HTML
while IFS= read -r -d '' html; do
    [[ -f "$html" ]] && replace_refs_in_file "$html"
done < <(find assets/2024/devfest -name "*.html" -type f -print0 2>/dev/null)

# Summary
echo ""
echo -e "${GREEN}=== Summary ===${NC}"
echo "Images converted: $CONVERTED"
echo "Conversions failed: $FAILED"
echo "Absolute URLs fixed: $FIXED_URLS"
echo "Source files deleted: $DELETED"

if [[ "$DRY_RUN" == false && $FAILED -gt 0 ]]; then
    echo -e "${RED}Some conversions failed. Check output above.${NC}"
    exit 1
fi

echo ""
if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}This was a dry run. No files were modified.${NC}"
    echo "Run without --dry-run to apply changes."
else
    echo -e "${GREEN}Done! Run ./scripts/audit-images.sh to verify.${NC}"
fi
