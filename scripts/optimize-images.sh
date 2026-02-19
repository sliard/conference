#!/bin/bash
#
# Image Optimization Script for DevFest Website
# Converts JPEG/PNG to WebP with verification and fallback handling
#
# Usage:
#   ./scripts/optimize-images.sh              # Convert only (safe)
#   ./scripts/optimize-images.sh --full       # Convert, replace URLs, delete sources
#   ./scripts/optimize-images.sh --audit      # Check for issues only
#

set -euo pipefail

# Script directory (absolute path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration
QUALITY=85
SIZES=(400 800 1200)
CURRENT_YEAR="2025"
CURRENT_YEAR_2="2026"

# Mode flags
FULL_MODE=false
AUDIT_MODE=false
REPLACE_ONLY=false

# Counters
CONVERTED=0
FAILED=0
SKIPPED=0
REPLACED=0
DELETED=0
VERIFY_ERRORS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
LOG_FILE="image-optimization-$(date +%Y%m%d-%H%M%S).log"
log() { echo "$1" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}ERROR: $1${NC}" | tee -a "$LOG_FILE" >&2; }
warn() { echo -e "${YELLOW}WARNING: $1${NC}" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}SUCCESS: $1${NC}" | tee -a "$LOG_FILE"; }
info() { echo -e "${BLUE}INFO: $1${NC}" | tee -a "$LOG_FILE"; }

# Parse arguments
for arg in "$@"; do
    case $arg in
        --full)
            FULL_MODE=true
            shift
            ;;
        --audit)
            AUDIT_MODE=true
            shift
            ;;
        --replace-only)
            REPLACE_ONLY=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --full          Convert, replace URLs, and DELETE source files"
            echo "  --audit         Check for JPG/PNG references and missing files only"
            echo "  --replace-only  Only replace URLs in source files (no conversion)"
            echo "  --help          Show this help"
            echo ""
            echo "Default mode (--full not specified):"
            echo "  Converts images but keeps source files safe"
            exit 0
            ;;
    esac
done

echo -e "${GREEN}=== DevFest Image Optimizer ===${NC}"
log "Started: $(date)"
log "Mode: FULL=$FULL_MODE, AUDIT=$AUDIT_MODE, REPLACE_ONLY=$REPLACE_ONLY"
echo ""

# ============================================================================
# AUDIT MODE - Just run the audit and exit
# ============================================================================
if [[ "$AUDIT_MODE" == true ]]; then
    if [[ -x "$SCRIPT_DIR/audit-images.sh" ]]; then
        $SCRIPT_DIR/audit-images.sh
        exit $?
    else
        error "audit-images.sh not found or not executable"
        exit 1
    fi
fi

# Check for required tools
if ! command -v cwebp &> /dev/null; then
    error "cwebp not found. Install with: apt-get install webp"
    exit 1
fi

if ! command -v convert &> /dev/null; then
    error "ImageMagick not found. Install with: apt-get install imagemagick"
    exit 1
fi

# Get file size in bytes
get_file_size() {
    stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null || echo "0"
}

# Convert with fallback for problematic images
convert_with_fallback() {
    local src="$1"
    local dst="$2"
    local tmp="${dst}.tmp.$$"

    # Try cwebp first
    if cwebp -q "$QUALITY" "$src" -o "$tmp" 2>/dev/null; then
        mv "$tmp" "$dst"
        return 0
    fi

    # Fallback: ImageMagick
    warn "cwebp failed for $(basename "$src"), trying ImageMagick..."
    if convert "$src" -colorspace sRGB "$tmp" 2>/dev/null; then
        mv "$tmp" "$dst"
        log "  Used ImageMagick fallback for $src"
        return 0
    fi

    rm -f "$tmp"
    return 1
}

# Verify output exists and is valid
verify_output() {
    local src="$1"
    local dst="$2"

    if [[ ! -f "$dst" ]]; then
        error "Output file missing: $dst"
        return 1
    fi

    local size
    size=$(get_file_size "$dst")
    if [[ "$size" -eq 0 ]]; then
        error "Output file is empty: $dst"
        rm -f "$dst"
        return 1
    fi

    if ! cwebp -info "$dst" &>/dev/null && ! identify "$dst" &>/dev/null; then
        error "Output file is corrupt: $dst"
        rm -f "$dst"
        return 1
    fi

    return 0
}

# Function to optimize a single image
optimize_image() {
    local input_file="$1"
    local dir
    local basename
    local output_file

    dir=$(dirname "$input_file")
    basename=$(basename "$input_file" | sed 's/\.[^.]*$//')
    output_file="$dir/${basename}.webp"

    # Skip if already optimized and up-to-date
    if [[ -f "$output_file" && "$output_file" -nt "$input_file" ]]; then
        ((SKIPPED++))
        return 0
    fi

    local orig_size
    orig_size=$(get_file_size "$input_file")

    log "Converting: $(basename "$input_file")"

    if ! convert_with_fallback "$input_file" "$output_file"; then
        error "Failed to convert: $input_file"
        ((FAILED++))
        return 1
    fi

    if ! verify_output "$input_file" "$output_file"; then
        ((VERIFY_ERRORS++))
        return 1
    fi

    local webp_size
    webp_size=$(get_file_size "$output_file")
    local savings=$(( (orig_size - webp_size) * 100 / orig_size ))

    success "Created ${basename}.webp (${savings}% smaller)"
    ((CONVERTED++))
    return 0
}

# ============================================================================
# URL REPLACEMENT
# ============================================================================
replace_image_urls() {
    local src_file="$1"
    local modified=0

    # Check if file exists and is readable
    [[ -f "$src_file" ]] || return

    # Read content
    local content
    content=$(cat "$src_file") || return
    local new_content="$content"

    # Find image references (simpler pattern)
    local refs
    refs=$(echo "$content" | grep -oE '[a-zA-Z0-9_/.:-]+\.(jpg|jpeg|png)(\?[a-zA-Z0-9=\u0026-]+)?' || true)

    for ref in $refs; do
        # Clean reference
        ref=$(echo "$ref" | tr -d '"'"'"'"' | tr -d ' ' | tr -d ')')
        [[ -z "$ref" ]] && continue

        # Skip if already webp or external
        [[ "$ref" == *.webp ]] && continue
        [[ "$ref" =~ ^https?:// ]] && continue
        [[ "$ref" =~ ^// ]] && continue
        [[ "$ref" =~ ^data: ]] && continue

        # Check if WebP version exists
        local file_dir
        file_dir=$(dirname "$src_file")
        local webp_ref="${ref%.*}.webp"

        # Try various paths
        local webp_exists=false
        if [[ -f "$file_dir/$webp_ref" ]]; then
            webp_exists=true
        elif [[ -f "$webp_ref" ]]; then
            webp_exists=true
        elif [[ -f "${file_dir%/*}/$webp_ref" ]]; then
            webp_exists=true
        fi

        if [[ "$webp_exists" == true ]]; then
            # Replace in content (handle various quote styles)
            local base="${ref%.*}"
            local new_ref="${base}.webp"

            # Escape for sed
            local escaped_ref
            escaped_ref=$(echo "$ref" | sed 's/[[\.*^$()+?{|]/\\&/g')
            local escaped_new
            escaped_new=$(echo "$new_ref" | sed 's/[[\.*^$()+?{|]/\\&/g')

            new_content=$(echo "$new_content" | sed "s|\"$escaped_ref\"|\"$escaped_new\"|g")
            new_content=$(echo "$new_content" | sed "s|'$escaped_ref'|'$escaped_new'|g")
            new_content=$(echo "$new_content" | sed "s|($escaped_ref)|($escaped_new)|g")

            ((REPLACED++))
            modified=1
            log "  Replaced: $ref -> $new_ref in $(basename "$src_file")"
        fi
    done

    # Write if modified
    if [[ $modified -eq 1 ]]; then
        # Create backup in full mode
        if [[ "$FULL_MODE" == true ]]; then
            cp "$src_file" "${src_file}.bak.$(date +%s)"
        fi
        echo "$new_content" > "$src_file"
        return 0
    fi

    return 1
}

# Replace URLs in all source files
replace_all_urls() {
    echo ""
    info "Replacing image URLs in source files..."

    local files_modified=0

    while IFS= read -r -d '' file; do
        if replace_image_urls "$file"; then
            ((files_modified++))
            success "Updated: $file"
        fi
    done < <(find . -type f \( -name "*.md" -o -name "*.html" -o -name "*.yml" -o -name "*.yaml" -o -name "*.css" -o -name "*.js" \) \
        ! -path "./_site/*" ! -path "./node_modules/*" ! -path "./.git/*" ! -path "./scripts/*" \
        -print0 2>/dev/null)

    echo "Files modified: $files_modified"
    log "URL replacements: $REPLACED in $files_modified files"
}

# ============================================================================
# DELETE SOURCE FILES (FULL MODE ONLY)
# ============================================================================
delete_source_files() {
    echo ""
    info "Deleting converted source files..."

    local deleted=0
    local skipped=0

    while IFS= read -r -d '' src_file; do
        local webp_file="${src_file%.*}.webp"
        local basename
        basename=$(basename "$src_file")

        # Only delete if:
        # 1. WebP exists
        # 2. WebP is valid (non-empty)
        # 3. WebP is newer than source
        if [[ -f "$webp_file" && -s "$webp_file" && "$webp_file" -nt "$src_file" ]]; then
            rm -f "$src_file"
            log "Deleted: $src_file"
            ((deleted++))
        else
            warn "Keeping $basename (WebP missing or older)"
            ((skipped++))
        fi
    done < <(find assets -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) \
        ! -path "*/node_modules/*" ! -path "*/_site/*" ! -path "*/.git/*" -print0 2>/dev/null)

    DELETED=$deleted
    echo "Deleted: $deleted source files"
    echo "Kept: $skipped source files (safety check)"
}

# ============================================================================
# MAIN PROCESSING
# ============================================================================

# If replace-only mode, just do URL replacement and exit
if [[ "$REPLACE_ONLY" == true ]]; then
    replace_all_urls
    echo ""
    success "URL replacement complete"
    exit 0
fi

echo -e "${GREEN}Step 1: Converting images to WebP...${NC}"

# Convert all images in assets directory (including nested folders)
echo ""
info "Scanning all assets directories for images to convert..."

# Find all jpg/png files recursively in assets folder
while IFS= read -r -d '' file; do
    optimize_image "$file"
done < <(find assets -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    ! -path "*/node_modules/*" ! -path "*/_site/*" ! -path "*/.git/*" -print0 2>/dev/null)

echo ""
info "Conversion complete: $CONVERTED converted, $SKIPPED skipped, $FAILED failed"

# Step 2: Replace URLs in source files
echo ""
echo -e "${GREEN}Step 2: Replacing image references...${NC}"
replace_all_urls

# Step 3: Delete source files (FULL MODE ONLY)
if [[ "$FULL_MODE" == true ]]; then
    echo ""
    echo -e "${GREEN}Step 3: Cleaning up source files...${NC}"
    delete_source_files
fi

echo ""
echo -e "${GREEN}=== Optimization Complete ===${NC}"
log ""
log "=== Summary ==="
log "Converted: $CONVERTED"
log "Skipped: $SKIPPED"
log "Failed: $FAILED"
log "URL replacements: $REPLACED"
if [[ "$FULL_MODE" == true ]]; then
    log "Source files deleted: $DELETED"
fi
log "Finished: $(date)"

echo ""
echo -e "${GREEN}Results:${NC}"
echo "  Converted: $CONVERTED"
echo "  Skipped: $SKIPPED"
echo "  Failed: $FAILED"
echo "  URL replacements: $REPLACED"
if [[ "$FULL_MODE" == true ]]; then
    echo "  Source files deleted: $DELETED"
fi

if [[ $FAILED -gt 0 || $VERIFY_ERRORS -gt 0 ]]; then
    error "Some conversions failed. Check $LOG_FILE for details"
    exit 1
fi

# Run audit after full mode to verify everything is clean
if [[ "$FULL_MODE" == true ]]; then
    echo ""
    info "Running post-conversion audit..."
    if $SCRIPT_DIR/audit-images.sh; then
        success "All checks passed!"
        exit 0
    else
        error "Audit found issues. Review above."
        exit 1
    fi
fi

success "Done! Run with --full to delete source files after verification."
