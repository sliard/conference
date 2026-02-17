# Template Interface Contract: Speaker Video Include

**Feature**: Speaker Videos
**Contract Type**: Jekyll Include Template Interface
**Status**: Draft

## Overview

This document defines the interface contract for the modified `_includes/speakers.html` template. The template follows the parameterized include pattern used by `_includes/video.html`.

## Template Interface

### File Location
```
_includes/speakers.html
```

### Input Parameters

The template receives data through the `include.params` object.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | String | Yes | Section title (e.g., "Speakers") |
| `list` | Array | Yes | Array of speaker objects |

### Speaker Object Schema

Each item in `list` array must conform to:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | String | Yes | Speaker's full name |
| `id` | String | Yes | Unique identifier for anchor links |
| `organization` | String | No | Company or affiliation |
| `photo_url` | String | No | Relative path to speaker photo |
| `bio` | String | No | Speaker biography (HTML supported) |
| `social_links` | Array | No | Social media links array |
| `video_url` | String | **NEW** | YouTube embed URL |

### Social Link Object Schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `type` | String | Yes | Link type: "linkedin", "github", "blog", or default |
| `url` | String | Yes | Full URL to social profile |

## Usage Example

### Template Invocation
```liquid
{% include speakers.html params=page.Speakers %}
```

### Data Structure (index.md)
```yaml
---
Speakers:
  title: "Speakers"
  list:
    - name: "Alain Buzacarro"
      id: "alain_b"
      organization: "Instinct Pioneer"
      photo_url: "assets/2025/photos_speakers/ABU.jpg"
      bio: "Speaker biography..."
      social_links:
        - type: linkedin
          url: https://www.linkedin.com/in/buzzacaro
      video_url: "https://www.youtube.com/embed/qkXRisXkWkQ"
---
```

## Output Specification

### HTML Structure

The template generates:

```html
<section id="speakers" class="section-padding">
  <div class="container">
    <!-- Section Title -->
    <div class="row">
      <div class="col-12">
        <h2 class="section-title">{{ title }}</h2>
      </div>
    </div>

    <!-- For each speaker -->
    <div class="row pt-5" id="{{ speaker.id }}">
      <!-- Photo column -->
      <div class="col-lg-4 col-8 mb-4 mt-4">
        <img class="img-fluid" src="{{ photo_url }}" alt="{{ name }}">
      </div>

      <!-- Info column -->
      <div class="col-lg-4 col-12">
        <h3>{{ name }}</h3>
        <p class="organization">{{ organization }}</p>
        <p>{{ bio }}</p>

        <!-- Social links (conditional) -->
        <div class="speaker-social-links">
          <!-- Social link icons -->
        </div>

        <!-- VIDEO EMBED (NEW - conditional) -->
        {% if speaker.video_url %}
        <div class="speaker-video mt-4">
          <iframe
            width="100%"
            height="315"
            src="{{ speaker.video_url }}"
            title="Conférence de {{ speaker.name }}"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen>
          </iframe>
        </div>
        {% endif %}
      </div>
    </div>
  </div>
</section>
```

### Conditional Rendering Rules

1. **Photo**: Rendered only if `speaker.photo_url` is present
2. **Social Links**: Rendered only if `speaker.social_links` exists and is non-empty
3. **Video Embed**: Rendered only if `speaker.video_url` is present (NEW)

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Missing `params` | Template renders empty section |
| Missing `params.title` | Section title is empty |
| Missing `params.list` | No speakers rendered |
| Speaker missing `id` | Anchor link will be broken |
| Speaker missing `video_url` | Video section not rendered (graceful degradation) |
| Invalid `video_url` | Browser will show iframe error (validation recommended in data) |

## Backwards Compatibility

The template maintains backwards compatibility:

- Existing speaker data without `video_url` continues to work
- All existing fields behave identically
- New `video_url` field is optional

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-17 | Initial contract with video_url support |
