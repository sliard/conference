# Quickstart: Speaker Videos

**Feature**: Speaker Videos
**Date**: 2026-02-17

## Prerequisites

- Ruby 2.5+ installed
- Bundler gem installed
- Repository cloned locally

## Installation

### 1. Install Dependencies

```bash
cd /root/workspace/conference
bundle install
```

### 2. Start Development Server

```bash
bundle exec jekyll serve --trace
```

The site will be available at `http://localhost:4000`

## Development Workflow

### Making Template Changes

1. Edit `_includes/speakers.html` to add video embed support
2. The template uses `include.params` pattern - reference `_includes/video.html` for examples
3. Add conditional check for `speaker.video_url` before rendering iframe

### Adding Video URLs

1. Open `index.md` in your editor
2. Locate the `Speakers:` section
3. For each speaker with a video, add the `video_url` field:

```yaml
Speakers:
  list:
    - name: "Speaker Name"
      id: "speaker_id"
      # ... existing fields ...
      video_url: "https://www.youtube.com/embed/VIDEO_ID"
```

### Testing Changes

1. **Local Build Test**:
   ```bash
   bundle exec jekyll build
   ```
   Should complete without errors.

2. **Visual Test**:
   - Navigate to `http://localhost:4000/#speakers`
   - Verify speakers with videos show embedded players
   - Verify speakers without videos display correctly (no empty players)
   - Test responsive behavior by resizing browser window

3. **Mobile Test**:
   - Use browser DevTools to simulate mobile viewport
   - Verify videos scale appropriately (16:9 aspect ratio maintained)

## Video URL Reference

| Speaker | Video URL |
|---------|-----------|
| Alain Buzacarro | `https://www.youtube.com/embed/qkXRisXkWkQ` |
| Stéphane Prohaszka | `https://www.youtube.com/embed/wK6P20OwoTw` |
| Hannah Issermann | `https://www.youtube.com/embed/oLStptnR4fk` |
| Isabelle Chanclou | `https://www.youtube.com/embed/oLStptnR4fk` |
| Cédric Clavier | `https://www.youtube.com/embed/KzksOfS6yH8` |
| Christophe Milon | `https://www.youtube.com/embed/tJPS_zDv6cQ` |
| Pierrick Blons | `https://www.youtube.com/embed/L8HUvUqwShI` |
| Sébastien Ferrer | `https://www.youtube.com/embed/6mXvcaVCJis` |
| Frédéric Bouchery | `https://www.youtube.com/embed/fQPaAPiT62o` |

**Note**: Hannah Issermann and Isabelle Chanclou share the same video (co-presenters on accessibility talk).

## Common Issues

### Issue: Video not displaying

**Check**:
1. `video_url` is present in speaker's YAML data
2. URL uses embed format (`/embed/VIDEO_ID` not `/watch?v=VIDEO_ID`)
3. No typos in field name (`video_url` not `videoURL` or `youtube_url`)

### Issue: Layout broken on mobile

**Check**:
1. iframe has `width="100%"` attribute
2. CSS includes responsive styling (aspect-ratio or height calculation)
3. Parent container has proper grid/flex classes

### Issue: Jekyll build fails

**Check**:
1. YAML syntax is valid (proper indentation, no tabs)
2. All quotes are properly closed
3. No special characters in strings without quotes

## Build for Production

```bash
JEKYLL_ENV=production bundle exec jekyll build
```

Output is generated in `_site/` directory.

## Deployment

Changes are deployed automatically via GitHub Actions when pushed to `master` branch.

## Rollback

To remove videos temporarily:
1. Comment out `video_url` lines in `index.md`:
   ```yaml
   # video_url: "https://www.youtube.com/embed/..."
   ```
2. Commit and push
