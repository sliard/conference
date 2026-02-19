<!--
SYNC IMPACT REPORT
==================
Version Change: N/A (new) → 1.0.0
Modified Principles: None (initial creation)
Added Sections: All (initial creation)
Removed Sections: None
Templates Requiring Updates:
  - ✅ .specify/templates/plan-template.md (Constitution Check section aligns)
  - ✅ .specify/templates/spec-template.md (no changes needed)
  - ✅ .specify/templates/tasks-template.md (no changes needed)
Follow-up TODOs: None
-->

# DevFest Perros-Guirec Website Constitution

## Core Principles

### I. Static-First Architecture
All content MUST be statically generated at build time. Jekyll processes YAML front matter and Liquid templates into static HTML/CSS/JS. No server-side runtime dependencies beyond a web server for serving files.

**Rationale**: Static sites are fast, secure, and easy to deploy on GitHub Pages. They eliminate runtime vulnerabilities and scale effortlessly with CDN distribution.

### II. Content-Driven Configuration
All dynamic content (speakers, agenda, sponsors) MUST be defined in YAML front matter within `index.md` or `_data/commons.yml`. No content should be hardcoded in HTML templates.

**Rationale**: Centralizing content in YAML makes updates accessible to non-developers and enables conditional rendering of sections. It separates content from presentation.

### III. Year-Based Editioning
Each conference edition MUST be self-contained under `assets/YYYY/`. Speaker photos, custom styles, and edition-specific assets MUST reside in year-organized folders. Past editions MUST be archived using the `bundle exec archive` command.

**Rationale**: This enables historical preservation of past conferences while keeping the current edition clean. Archiving creates immutable snapshots that won't break when site structure changes.

### IV. Jekyll Build Validation
The Jekyll build (`bundle exec jekyll build`) MUST pass without errors or unhandled warnings before any change is considered complete. Liquid template errors, missing includes, or YAML syntax errors are blockers.

**Rationale**: The build process is the primary validation mechanism for this static site. A clean build ensures the site will deploy correctly to GitHub Pages.

### V. Convention Over Configuration
File naming and location MUST follow established conventions:
- Speaker photos: `assets/YYYY/photos_speakers/filename.webp`
- Sponsor logos: `assets/img/logos_sponsors/`
- Layouts: `_layouts/` with names matching `layout:` front matter
- Includes: `_includes/` referenced by `{% include %}`

**Rationale**: Consistent naming enables predictable behavior and makes the codebase maintainable by multiple contributors over years.

## Additional Constraints

### French Language Primary
All user-facing content MUST be in French. Error messages, UI labels, and documentation intended for end users MUST use French. Internal code comments and commit messages may use English for broader accessibility.

### GitHub Pages Compatibility
All features MUST be compatible with GitHub Pages deployment constraints:
- No custom plugins beyond the whitelisted set
- No server-side processing
- Assets must use relative paths that work when deployed to `username.github.io/repo-name/`

### Accessibility Standards
HTML output MUST maintain semantic structure and include appropriate ARIA labels where needed. Color contrast and keyboard navigation should be considered for all interactive elements.

## Development Workflow

### Local Testing Required
All changes MUST be verified locally with `bundle exec jekyll serve` before committing. This includes:
- Visual inspection of affected pages
- Verification of responsive behavior
- Checking for broken links or missing assets

### Content Update Process
When adding speakers or agenda items:
1. Add content to `index.md` front matter
2. Place assets in correct year-organized folders
3. Verify section renders correctly (conditional display)
4. Run full Jekyll build to validate

### Archiving Procedure
When an edition concludes:
1. Run `bundle exec archive YYYY` to create snapshot
2. Verify archived assets are correctly copied
3. Update `archives.md` with new entry
4. Test archive pages render correctly

## Governance

This constitution governs all development practices for the DevFest Perros-Guirec website. Amendments require:
1. Documentation of the proposed change and its rationale
2. Review for compatibility with Jekyll/GitHub Pages constraints
3. Update to CLAUDE.md if agent guidance is affected

All pull requests MUST verify compliance with these principles. Complexity or new dependencies must be justified against the static-first architecture constraint.

**Version**: 1.0.0 | **Ratified**: 2026-02-17 | **Last Amended**: 2026-02-17
