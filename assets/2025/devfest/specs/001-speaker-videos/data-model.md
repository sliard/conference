# Data Model: Speaker Videos

**Feature**: Speaker Videos
**Date**: 2026-02-17
**Status**: Draft

## Entities

### Speaker (Extended)

The existing Speaker entity is extended with an optional video URL field.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | String | Yes | Speaker's full name |
| id | String | Yes | Unique identifier for the speaker (used for anchor links) |
| organization | String | No | Speaker's company or affiliation |
| photo_url | String | No | Path to speaker photo (relative to site root) |
| bio | String | No | Speaker biography (supports HTML/Markdown) |
| social_links | Array | No | List of social media links (LinkedIn, GitHub, etc.) |
| video_url | String | **NEW** | YouTube embed URL for the speaker's talk |

**Example YAML**:
```yaml
Speakers:
  list:
    - name: "Alain Buzacarro"
      id: "alain_b"
      organization: "Instinct Pioneer"
      photo_url: "assets/2025/photos_speakers/ABU.jpg"
      bio: >
        Après plusieurs expériences en tant que consultant...
      social_links:
        - type: linkedin
          url: https://www.linkedin.com/in/buzzacaro
      video_url: "https://www.youtube.com/embed/qkXRisXkWkQ"
```

### Video Configuration

Implicit entity representing the video embed configuration.

| Field | Type | Description |
|-------|------|-------------|
| url | String | YouTube embed URL |
| title | String | Title for accessibility (derived from talk title) |
| width | String | CSS width (typically "100%") |
| height | String | CSS height (typically auto with aspect-ratio) |

### Agenda Item (Related)

Agenda items reference speakers by ID. Videos are associated with speakers rather than agenda items to avoid duplication when multiple speakers share a talk.

| Field | Type | Description |
|-------|------|-------------|
| slot_begin_time | String | Talk start time (HH:MM format) |
| slot_type | String | "talk", "quickie", or "break" |
| title | String | Talk title |
| description | String | Talk description (HTML supported) |
| speakers | Array | References to speaker IDs |

## Relationships

```
┌─────────────────┐       ┌─────────────────┐
│   Speaker       │       │  Agenda Item    │
├─────────────────┤       ├─────────────────┤
│ - name          │       │ - slot_time     │
│ - id (PK)       │◄──────┤ - speakers[]    │
│ - organization  │  1:M  │ - title         │
│ - photo_url     │       │ - description   │
│ - bio           │       └─────────────────┘
│ - social_links  │
│ - video_url     │◄── NEW
└─────────────────┘
```

**Relationship Notes**:
- One Speaker can have zero or one video
- One Agenda Item can have one or more Speakers
- Videos are displayed in the Speaker section, not Agenda section (per spec FR-003)

## Validation Rules

1. **Video URL Format**: Must be a valid YouTube embed URL (`https://www.youtube.com/embed/VIDEO_ID`)
2. **Video ID Extraction**: Video ID must be 11 characters (YouTube standard)
3. **Conditional Display**: Template must check for presence of `video_url` before rendering iframe
4. **Optional Field**: Speakers without `video_url` must display without error or visual disruption

## State Transitions

Not applicable - this is a static content feature with no runtime state changes.

## YAML Schema (Front Matter)

```yaml
Speakers:
  title: String
  list:
    - name: String (required)
      id: String (required)
      organization: String
      photo_url: String
      bio: String
      social_links:
        - type: String
          url: String
      video_url: String  # NEW FIELD
```

## Data Migration

**From**: Current `index.md` without video URLs
**To**: Updated `index.md` with video URLs added to 10 speakers

**Migration Script**: Manual YAML edit (no automated migration needed for this feature)

**Speakers Requiring Video URLs**:

| Speaker ID | Speaker Name | Video URL |
|------------|--------------|-----------|
| alain_b | Alain Buzacarro | https://www.youtube.com/embed/qkXRisXkWkQ |
| stephane_prohaszka | Stéphane Prohaszka | https://www.youtube.com/embed/wK6P20OwoTw |
| hannah_issermann | Hannah Issermann | https://www.youtube.com/embed/oLStptnR4fk |
| isabelle_chanclou | Isabelle Chanclou | https://www.youtube.com/embed/oLStptnR4fk |
| cedric_clavier | Cédric Clavier | https://www.youtube.com/embed/KzksOfS6yH8 |
| christophe_milon | Christophe Milon | https://www.youtube.com/embed/tJPS_zDv6cQ |
| pierrick_blons | Pierrick Blons | https://www.youtube.com/embed/L8HUvUqwShI |
| sebastien_ferrer | Sébastien Ferrer | https://www.youtube.com/embed/6mXvcaVCJis |
| frederic_bouchery | Frédéric Bouchery | https://www.youtube.com/embed/fQPaAPiT62o |

**Note**: The "Mot d'introduction" and "Présentation Ada Lovelace" are special segments without dedicated speaker profiles. These may need special handling or could be added to the agenda section separately.
