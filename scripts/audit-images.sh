#!/bin/bash
#
# Image Reference Integrity Audit
# Checks for broken image references and orphaned files
#
# Exit codes:
#   0 = All checks passed
#   1 = Blocking issues found (JPG/PNG references or missing files)
#   2 = Warnings only (orphaned files)

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
JPG_REFS=0
MISSING_FILES=0
ORPHANED_FILES=0
WARNINGS=0

REPORT_FILE="image-audit-$(date +%Y%m%d-%H%M%S).log"

echo -e "${GREEN}=== Image Reference Integrity Audit ===${NC}"
log() { echo "$1" | tee -a "$REPORT_FILE"; }
log "Started: $(date)"
log ""

# ============================================================================
# CHECK 1: Are there any JPG/PNG references in source files? (BLOCKING)
# ============================================================================
echo -e "${BLUE}[CHECK 1]${NC} Scanning for JPG/PNG references in source files..."
log "=== CHECK 1: JPG/PNG References (BLOCKING) ==="

# Find all source files that might reference images
mapfile -t source_files < <(find . -type f \( \
    -name "*.md" -o -name "*.html" -o -name "*.yml" -o -name "*.yaml" -o \
    -name "*.css" -o -name "*.js" -o -name "*.json" \
    \) ! -path "./_site/*" ! -path "./node_modules/*" ! -path "./.git/*" \
    ! -path "./scripts/*" ! -name "README.md" 2>/dev/null | sort)

jpg_refs_found=()
for file in "${source_files[@]}"; do
    # Look for image references (various patterns)
    refs=$(grep -nE '\.(jpg|jpeg|png)' "$file" 2>/dev/null | grep -E '(src|href|url)' || true)

    if [[ -n "$refs" ]]; then
        echo -e "${RED}FOUND in $file:${NC}"
        echo "$refs" | head -5
        jpg_refs_found+=("$file")
        ((JPG_REFS++))
        log "BLOCKING: JPG/PNG reference in $file"
        log "$refs"
    fi
done

# ============================================================================
# CHECK 2: Are there references to missing image files? (BLOCKING)
# ============================================================================
echo ""
echo -e "${BLUE}[CHECK 2]${NC} Checking for references to missing files..."
log ""
log "=== CHECK 2: Missing Files (BLOCKING) ==="

missing_refs_found=()
for file in "${source_files[@]}"; do
    # Extract image references from the file (simpler pattern)
    refs=$(grep -oE '[a-zA-Z0-9_/.-]+\.(webp|jpg|jpeg|png)(\?[a-zA-Z0-9=&-]+)?' "$file" 2>/dev/null || true)

    for ref in $refs; do
        # Skip external URLs
        [[ "$ref" =~ ^https?:// ]] && continue
        [[ "$ref" =~ ^// ]] && continue
        [[ "$ref" =~ ^data: ]] && continue

        # Resolve relative path
        local_path="$ref"
        if [[ "$ref" == /* ]]; then
            local_path=".${ref}"
        else
            file_dir=$(dirname "$file")
            local_path="${file_dir}/${ref}"
        fi

        # Normalize path
        local_path=$(cd "$(dirname "$local_path")" && pwd)/$(basename "$local_path") 2>/dev/null || local_path="$local_path"

        if [[ ! -f "$local_path" ]]; then
            echo -e "${RED}MISSING: $ref (referenced in $file)${NC}"
            missing_refs_found+=("$ref|$file")
            ((MISSING_FILES++))
            log "BLOCKING: Missing file $ref referenced in $file"
        fi
    done
done

# Remove duplicates from missing refs
defaultIFS="$IFS"
IFS=$'\n'
if [[ ${#missing_refs_found[@]} -gt 0 ]]; then
    mapfile -t missing_refs_found < <(printf '%s\n' "${missing_refs_found[@]}" | sort -u)
fi
IFS="$defaultIFS"

# ============================================================================
# CHECK 3: Are there orphaned image files not referenced anywhere? (WARNING)
# ============================================================================
echo ""
echo -e "${BLUE}[CHECK 3]${NC} Checking for orphaned image files..."
log ""
log "=== CHECK 3: Orphaned Files (WARNING) ==="

# Get all WebP files
mapfile -t webp_files < <(find assets -type f -name "*.webp" \
    ! -path "*/node_modules/*" ! -path "*/_site/*" 2>/dev/null | sort)

for webp in "${webp_files[@]}"; do
    # Get the base name without extension and size suffix
    base=$(basename "$webp" .webp)
    # Remove responsive size suffixes
    base=$(echo "$base" | sed -E 's/-[0-9]+w$//')
    dir=$(dirname "$webp")

    # Search for any reference to this image (various extensions)
    found=0
    for ext in webp jpg jpeg png; do
        if grep -rE "(${base}\.${ext}|${base}-[0-9]+w\.webp)" \
            --include="*.md" --include="*.html" --include="*.yml" --include="*.yaml" \
            --include="*.css" --include="*.js" \
            . 2>/dev/null | grep -v "_site/" | grep -v ".git/" | grep -v "scripts/" >/dev/null; then
            found=1
            break
        fi
    done

    if [[ $found -eq 0 ]]; then
        echo -e "${YELLOW}ORPHANED: $webp (not referenced in any source file)${NC}"
        ((ORPHANED_FILES++))
        log "WARNING: Orphaned file $webp"
    fi
done

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo -e "${GREEN}=== Audit Summary ===${NC}"
log ""
log "=== Summary ==="
log "JPG/PNG references found: $JPG_REFS"
log "Missing file references: $MISSING_FILES"
log "Orphaned image files: $ORPHANED_FILES"

# Calculate blocking issues
BLOCKING_ISSUES=$((JPG_REFS + MISSING_FILES))

if [[ $BLOCKING_ISSUES -gt 0 ]]; then
    echo ""
    echo -e "${RED}❌ BLOCKING ISSUES FOUND${NC}"
    echo "  JPG/PNG references (must convert to WebP): $JPG_REFS"
    echo "  References to missing files: $MISSING_FILES"
    echo ""
    echo "Run to fix:"
    if [[ $JPG_REFS -gt 0 ]]; then
        echo "  ./scripts/optimize-images.sh --convert-and-replace"
    fi
    if [[ $MISSING_FILES -gt 0 ]]; then
        echo "  # Remove or fix broken references above"
    fi
    log "FAILED: $BLOCKING_ISSUES blocking issues"
    exit 1
elif [[ $ORPHANED_FILES -gt 0 ]]; then
    echo ""
    echo -e "${YELLOW}⚠️  WARNINGS ONLY${NC}"
    echo "  Orphaned image files: $ORPHANED_FILES"
    echo ""
    echo "These files exist but are not referenced anywhere."
    echo "Consider removing them if not needed."
    log "PASSED with warnings: $ORPHANED_FILES orphaned files"
    exit 0  # Warnings don't block
else
    echo ""
    echo -e "${GREEN}✅ ALL CHECKS PASSED${NC}"
    echo "  No JPG/PNG references"
    echo "  No missing file references"
    echo "  No orphaned files"
    log "PASSED: All checks passed"
    exit 0
fi
