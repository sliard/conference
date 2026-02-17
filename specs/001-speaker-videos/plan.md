# Implementation Plan: Speaker Videos

**Branch**: `001-speaker-videos` | **Date**: 2026-02-17 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-speaker-videos/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Add YouTube video embedding capability to the DevFest Perros-Guirec website, allowing visitors to watch recorded conference talks directly on speaker profile sections. The implementation will:

1. Extend the existing `_includes/speakers.html` template to use parameter-based includes (matching the `video.html` pattern)
2. Add YouTube video URLs to speaker data in `index.md` front matter for all 10 conference talks
3. Conditionally display video embeds only when video data is present
4. Ensure responsive design for mobile and desktop viewports

The approach follows Jekyll/Liquid best practices and maintains consistency with existing include templates.

## Technical Context

**Language/Version**: Ruby 2.5+, Jekyll 4.x
**Primary Dependencies**: Jekyll static site generator, jekyll_asset_pipeline plugin
**Storage**: YAML front matter in Markdown files (index.md)
**Testing**: Jekyll build validation (`bundle exec jekyll build`), visual inspection
**Target Platform**: GitHub Pages, modern web browsers (Chrome, Firefox, Safari, Edge)
**Project Type**: Web - static site
**Performance Goals**: Page load <3s, responsive video embedding
**Constraints**: GitHub Pages compatibility (no custom plugins), static generation only, French language primary
**Scale/Scope**: Single conference page, 10 video embeds, ~100 concurrent users

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Compliance Assessment

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Static-First Architecture | ✅ PASS | YouTube embeds use static iframes, no server-side processing |
| II. Content-Driven Configuration | ✅ PASS | Video URLs stored in YAML front matter (index.md), templates remain content-agnostic |
| III. Year-Based Editioning | ✅ PASS | Videos associated with 2025 edition, no impact on archival process |
| IV. Jekyll Build Validation | ✅ PASS | Template changes validated through standard build process |
| V. Convention Over Configuration | ✅ PASS | Following existing `include.params` pattern from video.html |

### Additional Constraints Check

| Constraint | Status | Notes |
|------------|--------|-------|
| French Language Primary | ✅ PASS | No UI text additions; video content is in French |
| GitHub Pages Compatibility | ✅ PASS | Standard iframe embeds, no custom plugins required |
| Accessibility Standards | ⚠️ REVIEW | Must ensure iframe has title attribute for screen readers |

**Gate Result**: ✅ PASS - Proceed to Phase 0 research

### Post-Phase 1 Re-evaluation

After completing design (research.md, data-model.md, contracts/, quickstart.md):

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Static-First Architecture | ✅ PASS | Confirmed: iframe embeds, no server-side processing |
| II. Content-Driven Configuration | ✅ PASS | Confirmed: video_url in YAML front matter |
| III. Year-Based Editioning | ✅ PASS | Confirmed: no impact on archival process |
| IV. Jekyll Build Validation | ✅ PASS | Confirmed: template changes validated |
| V. Convention Over Configuration | ✅ PASS | Confirmed: using include.params pattern |

| Constraint | Status | Notes |
|------------|--------|-------|
| French Language Primary | ✅ PASS | Content in French, no UI text changes |
| GitHub Pages Compatibility | ✅ PASS | Standard iframes, no plugins |
| Accessibility Standards | ✅ PASS | iframe includes title attribute per contract |

**Final Gate Result**: ✅ PASS - Ready for task generation

## Project Structure

### Documentation (this feature)

```text
specs/001-speaker-videos/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
├── checklists/          # Spec quality validation
│   └── requirements.md
└── spec.md              # Feature specification
```

### Source Code (repository root)

```text
root/
├── _includes/
│   ├── speakers.html    # MODIFIED: Add video embed support with params pattern
│   └── video.html       # REFERENCE: Existing pattern for include.params
├── _layouts/
│   └── home_conference.html  # Uses speakers.html include
├── index.md             # MODIFIED: Add video_url to speaker data
├── _config.yml          # Jekyll configuration (no changes needed)
└── assets/              # Static assets (no changes needed)
```

**Structure Decision**: Single Jekyll static site. Changes are localized to:
1. `_includes/speakers.html` - Template modification for video embedding
2. `index.md` - Content update to add video URLs to speaker front matter

No new directories or files needed beyond the feature documentation in `specs/001-speaker-videos/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

**Status**: No violations - All Constitution principles satisfied ✅

This feature requires minimal complexity:
- Reuses existing `include.params` pattern from `video.html`
- Uses standard YouTube iframe embed (industry standard)
- No new dependencies or plugins
- Single template modification with conditional logic
