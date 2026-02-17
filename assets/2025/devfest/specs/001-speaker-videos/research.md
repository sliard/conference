# Research: Speaker Videos

**Feature**: Speaker Videos
**Date**: 2026-02-17
**Status**: Complete

## Research Scope

This document captures research decisions for embedding YouTube videos in the DevFest Perros-Guirec Jekyll-based website.

## Decision: YouTube Embed Method

**Decision**: Use standard YouTube iframe embed with `youtube.com/embed/` URLs

**Rationale**:
- Industry standard for video embedding
- Works without JavaScript (progressive enhancement)
- GitHub Pages compatible (no custom plugins needed)
- Consistent with existing `video.html` implementation
- Supports responsive sizing via CSS

**Alternatives Considered**:

| Alternative | Pros | Cons | Verdict |
|-------------|------|------|---------|
| YouTube JavaScript API | More control over player | Requires JS, more complex | ❌ Rejected - overkill for simple embedding |
| Lazy-loading libraries | Better performance | Additional dependency | ❌ Rejected - violates Static-First principle |
| Native HTML5 video | No external dependency | Must host videos ourselves | ❌ Rejected - hosting cost and complexity |
| YouTube iframe (chosen) | Simple, standard, reliable | Requires iframe | ✅ Accepted - best balance |

## Decision: Template Pattern

**Decision**: Use `include.params` pattern matching existing `video.html` implementation

**Rationale**:
- Maintains consistency across codebase
- Follows Jekyll best practices for parameterized includes
- Enables conditional rendering (video only when params provided)
- Clear separation between content (YAML) and presentation (template)

**Implementation Pattern**:
```liquid
{% include component.html params=page.data %}
<!-- Inside component.html -->
{{ include.params.property }}
```

## Decision: Video URL Storage

**Decision**: Store YouTube URLs in speaker front matter as `video_url` or `youtube_url`

**Rationale**:
- Keeps content centralized in `index.md`
- Easy for non-developers to update
- Works with existing speaker data structure
- Enables conditional rendering ({% if speaker.video_url %})

**Data Structure**:
```yaml
Speakers:
  list:
    - name: "Speaker Name"
      id: "speaker_id"
      video_url: "https://www.youtube.com/embed/VIDEO_ID"
```

## Decision: URL Format Transformation

**Decision**: Store full embed URLs in YAML (not just video IDs)

**Rationale**:
- Simpler template logic (no string manipulation needed)
- More explicit and readable
- Allows for different video sources if needed in future

**URL Mapping** (for reference):

| Video | Watch URL | Embed URL |
|-------|-----------|-----------|
| Mot d'introduction | https://youtu.be/qIaJlpvo8ro | https://www.youtube.com/embed/qIaJlpvo8ro |
| Alain Buzacarro | https://youtu.be/qkXRisXkWkQ | https://www.youtube.com/embed/qkXRisXkWkQ |
| Stéphane Prohaszka | https://youtu.be/wK6P20OwoTw | https://www.youtube.com/embed/wK6P20OwoTw |
| Hannah & Isabelle | https://youtu.be/oLStptnR4fk | https://www.youtube.com/embed/oLStptnR4fk |
| Cédric Clavier | https://youtu.be/KzksOfS6yH8 | https://www.youtube.com/embed/KzksOfS6yH8 |
| Christophe Milon | https://youtu.be/tJPS_zDv6cQ | https://www.youtube.com/embed/tJPS_zDv6cQ |
| Pierrick Blons | https://youtu.be/L8HUvUqwShI | https://www.youtube.com/embed/L8HUvUqwShI |
| Ada Lovelace | https://youtu.be/4l5PEjqyeMM | https://www.youtube.com/embed/4l5PEjqyeMM |
| Sébastien Ferrer | https://youtu.be/6mXvcaVCJis | https://www.youtube.com/embed/6mXvcaVCJis |
| Frédéric Bouchery | https://youtu.be/fQPaAPiT62o | https://www.youtube.com/embed/fQPaAPiT62o |

## Decision: Responsive Behavior

**Decision**: Use CSS `width: 100%` with `aspect-ratio: 16/9` for responsive embeds

**Rationale**:
- Maintains 16:9 aspect ratio (standard video format)
- Works across all screen sizes
- No JavaScript required
- Consistent with existing styling patterns

**CSS Pattern**:
```css
.video-wrapper iframe {
  width: 100%;
  aspect-ratio: 16/9;
  border: none;
}
```

## Decision: Accessibility

**Decision**: Add `title` attribute to iframe for screen reader support

**Rationale**:
- Required for WCAG compliance
- Helps screen readers identify embedded content
- Minimal implementation effort

## Unknowns Resolved

All technical questions have been answered through research:

1. ✅ **YouTube URL format**: Use embed format (`/embed/VIDEO_ID`)
2. ✅ **Template pattern**: Use existing `include.params` pattern
3. ✅ **Responsive behavior**: CSS aspect-ratio approach
4. ✅ **Accessibility**: Title attribute on iframe

## Research Conclusion

No blockers identified. The implementation approach is straightforward and follows established patterns in the codebase. Ready to proceed to Phase 1 design.
