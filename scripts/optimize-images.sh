#!/bin/bash
#
# Image Optimization Script for DevFest Website
# Converts JPEG/PNG to WebP and creates responsive sizes
#

set -e

# Configuration
QUALITY=85
SIZES=(400 800 1200)
CURRENT_YEAR="2025"
CURRENT_YEAR_2="2026"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== DevFest Image Optimizer ===${NC}"
echo ""

# Check for required tools
if ! command -v cwebp &> /dev/null; then
    echo -e "${YELLOW}Warning: cwebp not found. Installing via apt...${NC}"
    apt-get update && apt-get install -y webp imagemagick
fi

if ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: ImageMagick not found. Please install it.${NC}"
    exit 1
fi

# Function to optimize a single image
optimize_image() {
    local input_file="$1"
    local dir=$(dirname "$input_file")
    local basename=$(basename "$input_file" | sed 's/\.[^.]*$//')
    local ext="${input_file##*.}"

    # Skip if already optimized (WebP exists)
    if [ -f "$dir/${basename}.webp" ]; then
        echo -e "  ${YELLOW}Skipping${NC} $input_file (WebP already exists)"
        return
    fi

    # Get original file size
    local orig_size=$(stat -f%z "$input_file" 2>/dev/null || stat -c%s "$input_file" 2>/dev/null || echo "0")

    # Create WebP version with high quality
    cwebp -q $QUALITY "$input_file" -o "$dir/${basename}.webp" -quiet 2>/dev/null || true

    if [ -f "$dir/${basename}.webp" ]; then
        local webp_size=$(stat -f%z "$dir/${basename}.webp" 2>/dev/null || stat -c%s "$dir/${basename}.webp" 2>/dev/null || echo "0")
        local savings=$(( (orig_size - webp_size) * 100 / orig_size ))
        echo -e "  ${GREEN}Created${NC} ${basename}.webp (${savings}% smaller)"
    fi
}

# Function to create responsive sizes for important images
create_responsive_sizes() {
    local input_file="$1"
    local dir=$(dirname "$input_file")
    local basename=$(basename "$input_file" | sed 's/\.[^.]*$//')

    # Skip small images
    local width=$(identify -format "%w" "$input_file" 2>/dev/null || echo "0")
    if [ "$width" -lt 800 ]; then
        return
    fi

    for size in "${SIZES[@]}"; do
        # Skip if source is smaller than target
        if [ "$width" -le "$size" ]; then
            continue
        fi

        local output_file="$dir/${basename}-${size}w.webp"

        if [ ! -f "$output_file" ]; then
            convert "$input_file" -resize "${size}x${size}>" -quality $QUALITY "$output_file" 2>/dev/null && \
                echo -e "  ${GREEN}Created${NC} ${basename}-${size}w.webp" || true
        fi
    done
}

# Main optimization process
echo -e "${GREEN}Step 1: Optimizing speaker photos for $CURRENT_YEAR and $CURRENT_YEAR_2...${NC}"
if [ -d "assets/$CURRENT_YEAR/photos_speakers" ]; then
    find "assets/$CURRENT_YEAR/photos_speakers" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        optimize_image "$file"
    done
fi

if [ -d "assets/$CURRENT_YEAR_2/photos_speakers" ]; then
    find "assets/$CURRENT_YEAR_2/photos_speakers" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        optimize_image "$file"
    done
fi

echo ""
echo -e "${GREEN}Step 2: Optimizing gallery images...${NC}"
if [ -d "assets/$CURRENT_YEAR/photos" ]; then
    find "assets/$CURRENT_YEAR/photos" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        optimize_image "$file"
        create_responsive_sizes "$file"
    done
fi

echo ""
echo -e "${GREEN}Step 3: Optimizing carousel/slider images...${NC}"
find assets -type f \( -iname "carousel-bg*" -o -iname "*hero*" -o -iname "*banner*" \) | while read -r file; do
    optimize_image "$file"
    create_responsive_sizes "$file"
done

echo ""
echo -e "${GREEN}Step 4: Optimizing general images...${NC}"
find assets/img -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | while read -r file; do
    optimize_image "$file"
done

echo ""
echo -e "${GREEN}=== Optimization Complete ===${NC}"
echo ""

# Calculate and display savings
echo -e "${GREEN}Size Summary:${NC}"
echo "Original JPEG/PNG files:"
find assets -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec du -ch {} + 2>/dev/null | tail -1 | awk '{print "  " $1}'

echo "New WebP files:"
find assets -type f -iname "*.webp" -exec du -ch {} + 2>/dev/null | tail -1 | awk '{print "  " $1}'

echo ""
echo -e "${YELLOW}Note: To use WebP images, update your templates to reference${NC}"
echo -e "${YELLOW}the .webp extension or use the picture element with fallback.${NC}"
