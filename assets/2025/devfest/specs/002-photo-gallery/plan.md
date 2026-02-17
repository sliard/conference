# Implementation Plan: Event Photo Gallery

**Branch**: `002-photo-gallery` | **Date**: 2026-02-17 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-photo-gallery/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Add a photo gallery section to the DevFest Perros-Guirec 2025 homepage showcasing 16 event photos. The gallery uses the existing `_includes/gallery.html` component with YAML front matter configuration in `index.md`. All photos include descriptive alt text for accessibility. This is a content-only feature requiring no new code or dependencies.

## Technical Context

**Language/Version**: Jekyll 4.x (Ruby-based static site generator), YAML, Liquid templates
**Primary Dependencies**: jekyll_asset_pipeline (existing)
**Storage**: N/A (static file references)
**Testing**: Jekyll build validation (`bundle exec jekyll build`)
**Target Platform**: GitHub Pages
**Project Type**: web (static site)
**Performance Goals**: Gallery images load responsively via existing CSS grid
**Constraints**: Must work with existing gallery.html component; must follow year-based asset organization
**Scale/Scope**: 16 photos in single gallery section

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Static-First Architecture | ✅ PASS | Gallery is statically generated at build time |
| II. Content-Driven Configuration | ✅ PASS | Gallery content defined in YAML front matter |
| III. Year-Based Editioning | ✅ PASS | Photos in `assets/2025/photos_event/` |
| IV. Jekyll Build Validation | ✅ PASS | Changes verified via `bundle exec jekyll build` |
| V. Convention Over Configuration | ✅ PASS | Uses existing `_includes/gallery.html` pattern |
| French Language Primary | ✅ PASS | Section title will be in French |
| GitHub Pages Compatibility | ✅ PASS | No new plugins or server-side processing |
| Accessibility Standards | ✅ PASS | Descriptive alt text included for all photos |

**All constitution principles satisfied. No violations to justify.**

## Project Structure

### Documentation (this feature)

```text
specs/002-photo-gallery/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output - N/A for this simple feature
├── data-model.md        # Phase 1 output - N/A (no data models)
├── quickstart.md        # Phase 1 output - N/A (no integration needed)
├── contracts/           # Phase 1 output - N/A (no APIs)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
# Web static site structure
index.md                    # Gallery configuration added to front matter
_includes/gallery.html      # EXISTING - reused component
assets/2025/photos_event/   # EXISTING - 16 event photos already in place
_layouts/home_conference.html  # EXISTING - conditionally renders gallery
```

**Structure Decision**: This feature adds content to the existing Jekyll static site structure. No new directories or files are created beyond the specification documentation. The gallery uses the existing `_includes/gallery.html` component which expects:
- `include.params.title` - section title (French)
- `include.params.description` - optional description
- `include.params.photos` - array of photo objects with `url` and `alt` properties

## Complexity Tracking

> **No constitution violations. This feature uses existing infrastructure.**

This is a content-only feature that:
- Reuses existing `_includes/gallery.html` component
- Adds YAML front matter to `index.md`
- References existing photos in `assets/2025/photos_event/`
- Requires no new dependencies, build steps, or code

The implementation is a single task: add the Gallery configuration to `index.md` front matter following the existing pattern used by other sections (Speakers, Agenda, etc.).
