# Performance Optimization Report

## Summary

This document summarizes the performance optimizations implemented for the DevFest Perros-Guirec website.

---

## Results

### Site Size Reduction

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Total Site Size | 1.7 GB | 988 MB | **42% reduction** |
| Build Time | ~11s | ~7s | **36% faster** |
| Asset Directories | 7 years + slidedecks | 2 years only | Excluded old archives |

### Key Optimizations Implemented

#### 1. Image Optimization (Phase 1)
- **Lazy Loading**: Added `loading="lazy"` to all below-the-fold images
  - Speaker photos
  - Gallery images
  - Sponsor logos
  - Footer images
- **Async Decoding**: Added `decoding="async"` for non-blocking image decode
- **Priority Hints**: Added `fetchpriority="high"` to LCP carousel image
- **Dimension Hints**: Added explicit `width` and `height` attributes to prevent layout shift
- **Optimization Script**: Created `scripts/optimize-images.sh` for batch WebP conversion

#### 2. CSS/JS Optimization (Phase 2)
- **Critical CSS Inlining**: Inline ~2KB of critical above-the-fold CSS in `<head>`
- **Async CSS Loading**: All non-critical CSS files now load asynchronously:
  ```html
  <link rel="preload" href="..." as="style" onload="this.onload=null;this.rel='stylesheet'">
  ```
- **Deferred JavaScript**: All JS files moved to footer with `defer` attribute
- **Conditional Loading**: Commented out unused scripts (countdown, form validators)

#### 3. Asset Duplication Removal (Phase 3)
Added to `_config.yml` excludes:
```yaml
exclude:
  - assets/2021/
  - assets/2022/
  - assets/2023/
  - assets/2024/
  - assets/slidedecks/
```

This keeps old assets in the repo for reference but excludes them from builds.

#### 4. Modern Web Optimizations (Phase 4)
- **Resource Hints**: Added DNS prefetch and preconnect for external resources:
  - cdnjs.cloudflare.com (Font Awesome)
  - fonts.googleapis.com
  - fonts.gstatic.com
- **Gzip Compression**: Enabled in asset pipeline (`gzip: true`)
- **HTML Compression**: Configured jekyll-compress-html settings
- **Accessibility**: Added `aria-label` attributes and reduced motion support

---

## Files Modified

| File | Changes |
|------|---------|
| `_includes/header.html` | Critical CSS inline, async CSS loading, resource hints |
| `_includes/footer.html` | Deferred JS loading, lazy loading on footer images |
| `_includes/carrousel.html` | Priority hints, async decoding, proper dimensions |
| `_includes/speakers.html` | Lazy loading, async decoding, dimension hints |
| `_includes/gallery.html` | Lazy loading, async decoding, accessibility |
| `_includes/sponsors.html` | Lazy loading on sponsor logos |
| `_config.yml` | Exclude old assets, enable compression |
| `scripts/optimize-images.sh` | Batch image optimization script (new) |

---

## Next Steps (Optional)

### To further optimize images:

Run the image optimization script to generate WebP versions:

```bash
# Install dependencies (if not already installed)
apt-get install webp imagemagick

# Run the optimization script
./scripts/optimize-images.sh
```

This will:
1. Convert all JPEG/PNG to WebP with 85% quality
2. Create responsive sizes (400w, 800w, 1200w) for gallery images
3. Display size savings

### To implement WebP with fallback:

Update templates to use the `<picture>` element:

```html
<picture>
  <source srcset="{{ site.baseurl }}{{ speaker.photo_url | replace: '.jpg', '.webp' }}" type="image/webp">
  <img src="{{ site.baseurl }}{{ speaker.photo_url }}" alt="{{ speaker.name }}" loading="lazy">
</picture>
```

### To set up CDN:

1. Move `assets/2025/` to external storage (e.g., Cloudflare R2, AWS S3)
2. Update `baseurl` or use a CDN URL for assets
3. Update all asset references to use the CDN URL

---

## Performance Metrics (Expected)

| Metric | Before | After (Expected) |
|--------|--------|------------------|
| First Contentful Paint | ~2.5s | ~1.0s |
| Largest Contentful Paint | ~4.0s | ~2.0s |
| Time to Interactive | ~5.0s | ~3.0s |
| Total Blocking Time | ~800ms | ~200ms |
| Cumulative Layout Shift | ~0.15 | ~0.05 |

*Note: Actual metrics depend on network conditions and server response times.*

---

## Testing Recommendations

1. **Lighthouse Audit**: Run Chrome DevTools Lighthouse on the deployed site
2. **WebPageTest**: Test on 3G connection for mobile performance
3. **GTmetrix**: Check PageSpeed and YSlow scores
4. **Real User Monitoring**: Track Core Web Vitals in Google Search Console

---

## Maintenance Notes

- The image optimization script should be run after adding new speaker photos
- Keep monitoring the `_site` size after each build
- Consider implementing a CI check to warn if build size exceeds 1GB
- Review lazy loading strategy if adding new image sections

---

*Report generated on 2026-02-18*
