# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based static website for the **DevFest Perros-Guirec** conference, organized by the Code d'Armor association. The website is primarily in French and showcases conference information including speakers, agenda, sponsors, and ticketing.

## Build Commands

### Development
```bash
# Start local development server with live reload
bundle exec jekyll serve --trace

# The site will be available at http://localhost:4000
```

### Build for Production
```bash
# Build the site (outputs to ./_site by default)
bundle exec jekyll build

# Build with production environment
JEKYLL_ENV=production bundle exec jekyll build
```

### Dependency Management
```bash
# Install dependencies after cloning
bundle install

# Update gems
bundle update
```

## Project Architecture

### Directory Structure

- **`index.md`** - Main homepage with conference configuration (speakers, agenda, sponsors, etc.)
- **`_config.yml`** - Jekyll configuration (plugins, sass compilation, asset pipeline)
- **`_includes/`** - Reusable HTML fragments (header, footer, agenda, speakers, etc.)
- **`_layouts/`** - Page templates (home_conference, sponsors, archives, about)
- **`_data/commons.yml`** - Shared data (menu, sponsors, newsletter links)
- **`_sass/`** - SCSS stylesheets
- **`assets/`** - Static assets organized by year (images, CSS, JS, archived editions)

### Key Data Flow

The homepage (`index.md`) uses YAML front matter to define all dynamic content:

```yaml
---
layout: home_conference  # Uses _layouts/home_conference.html

# Sections are conditionally rendered in the layout:
Carrousel_Slides:  # Hero carousel
Details:           # Event info (where, when, who)
CallForProposal:   # CFP section (commented out when inactive)
Speakers:          # Speaker list with bios and photos
Agenda:            # Schedule with talk descriptions
Sponsoring:        # Partner logos
Register:          # Ticketing buttons
Shop:              # Merchandise section
Gallery:           # Photo gallery
Newsletter:        # Newsletter signup
---
```

The layout (`_layouts/home_conference.html`) conditionally includes sections:
```liquid
{% if page.Speakers != null %}
  {% include speakers.html %}
{% endif %}
```

### Data Sources

| Data | Location |
|------|----------|
| Menu, sponsors, newsletter links | `_data/commons.yml` |
| Conference details, speakers, agenda | `index.md` front matter |
| Archives | `archives.md` front matter |
| Sponsor page content | `sponsors.md` front matter |

### Asset Pipeline

Uses `jekyll_asset_pipeline` plugin with a custom SCSS converter (`_plugins/jekyll_asset_pipeline.rb`). Sass is configured with `style: compressed` in `_config.yml`.

### Deployment

GitHub Actions workflow (`.github/workflows/jekyll.yml`) builds and deploys to GitHub Pages on pushes to `master` branch.

## Adding/Modifying Content

### Adding a Speaker
Add to `index.md` under `Speakers.list`:
```yaml
- name: "Speaker Name"
  id: "unique_id"
  organization: "Company"
  photo_url: "assets/2025/photos_speakers/filename.jpg"
  bio: >
    Speaker bio here...
  social_links:
    - type: linkedin
      url: https://linkedin.com/in/...
```

Then reference in agenda using the `id`.

### Adding an Agenda Item
Add to `index.md` under `Agenda.schedule`:
```yaml
- slot_begin_time: "HH:MM"
  slot_type: talk|break|quickie
  title: "Session Title"
  speakers:
    - id: speaker_id  # References Speakers.list
  description: >
    Session description...
```

### Enabling/Disabling Sections
Comment out or remove the section from `index.md` front matter to hide it. The layout checks for null before rendering.

## Important Notes

- Past conference editions are archived in `assets/YYYY/` folders
- Speaker photos should be placed in `assets/2025/photos_speakers/`
- Sponsor logos go in `assets/img/logos_sponsors/`
- The site uses Font Awesome icons (loaded via CDN in header)

## Active Technologies
- Ruby 2.5+, Jekyll 4.x + Jekyll static site generator, jekyll_asset_pipeline plugin (001-speaker-videos)
- YAML front matter in Markdown files (index.md) (001-speaker-videos)
- Jekyll 4.x (Ruby-based static site generator), YAML, Liquid templates + jekyll_asset_pipeline (existing) (002-photo-gallery)
- N/A (static file references) (002-photo-gallery)

## Recent Changes
- 001-speaker-videos: Added Ruby 2.5+, Jekyll 4.x + Jekyll static site generator, jekyll_asset_pipeline plugin

## Development Workflow

### Testing with Playwright

When taking screenshots during browser testing, use the dedicated `.playwright/` folder:

```bash
# Screenshots are saved to .playwright/ (gitignored)
# Example screenshot paths:
# - .playwright/homepage.png
# - .playwright/mobile-view.png
# - .playwright/archive-test.png
```

This keeps test artifacts out of version control while maintaining a consistent location for visual debugging.
