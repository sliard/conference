# Feature Specification: Speaker Videos

**Feature Branch**: `001-speaker-videos`
**Created**: 2026-02-17
**Status**: Draft
**Input**: User description: "Add YouTube videos for each speaker in the program below the title/description of the talk. Modify _includes/speakers.html template to use params as in _includes/video.html, fill index.md with video parameters for 10 conference talks."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Speaker Talk Video (Priority: P1)

As a conference website visitor, I want to watch a speaker's recorded talk directly on their profile section, so I can learn from their presentation without leaving the site.

**Why this priority**: This is the core value of the feature - making conference content accessible to visitors who couldn't attend or want to revisit talks.

**Independent Test**: Can be fully tested by navigating to a speaker's section and verifying the embedded YouTube video loads and plays correctly.

**Acceptance Scenarios**:

1. **Given** a speaker has a video URL configured in index.md, **When** the page loads, **Then** an embedded YouTube player appears below the speaker's bio
2. **Given** a speaker has no video URL configured, **When** the page loads, **Then** the speaker section displays without a video player (no visual disruption)
3. **Given** the page is viewed on mobile, **When** the video section renders, **Then** the player is responsive and fits within the viewport

---

### User Story 2 - Access Videos from Agenda Talks (Priority: P1)

As a visitor reviewing the conference program, I want to watch recorded talks directly from the agenda section, so I can immediately access content that interests me.

**Why this priority**: The agenda is where users browse topics; having videos there provides immediate value and engagement.

**Independent Test**: Can be tested by scrolling to the agenda section, finding a talk, and verifying the video appears below the talk description.

**Acceptance Scenarios**:

1. **Given** a talk in the agenda has a video configured, **When** viewing that agenda item, **Then** the embedded video appears below the talk description
2. **Given** a talk has multiple speakers, **When** the video is displayed, **Then** it appears once (associated with the talk, not duplicated per speaker)

---

### User Story 3 - Consistent Video Presentation (Priority: P2)

As a website visitor, I want all videos to have a consistent look and feel, so the viewing experience feels professional and cohesive.

**Why this priority**: While valuable for brand consistency, this is secondary to having functional videos.

**Independent Test**: Can be tested by verifying all video players use the same styling and dimensions.

**Acceptance Scenarios**:

1. **Given** multiple videos are embedded on the page, **When** viewing them, **Then** they all have consistent dimensions and styling
2. **Given** videos are embedded, **When** the page loads, **Then** they use the standard include template pattern like other video sections on the site

---

### Edge Cases

- What happens when a YouTube URL is malformed or the video is unavailable?
- How does the system handle speakers who share a talk (multiple speakers, one video)?
- What if a speaker has a video but no talk in the agenda (opening/closing remarks)?
- How does the responsive layout behave on very small screens?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support adding YouTube video URLs to speaker data in index.md front matter
- **FR-002**: System MUST conditionally display video embed only when a video URL is provided (no empty players)
- **FR-003**: Videos MUST be displayed below the speaker's bio and social links in the speakers section
- **FR-004**: The _includes/speakers.html template MUST be refactored to use parameter-based includes (similar to video.html pattern with `include.params`)
- **FR-005**: The following 10 videos MUST be configured in index.md:
  - Mot d'introduction: https://youtu.be/qIaJlpvo8ro
  - Alain Buzacarro - L'ignorance, ce fléau: https://youtu.be/qkXRisXkWkQ
  - Stéphane Prohaszka - Dette technique: https://youtu.be/wK6P20OwoTw
  - Hannah Issermann & Isabelle Chanclou - Accessibilité: https://youtu.be/oLStptnR4fk
  - Cédric Clavier - Monolithes vs Microservices: https://youtu.be/KzksOfS6yH8
  - Christophe Milon - Holacratie: https://youtu.be/tJPS_zDv6cQ
  - Pierrick Blons - DDD tactique: https://youtu.be/L8HUvUqwShI
  - Présentation Ada Lovelace: https://youtu.be/4l5PEjqyeMM
  - Sébastien Ferrer - Troubleshooting: https://youtu.be/6mXvcaVCJis
  - Frédéric Bouchery - Code sale: https://youtu.be/fQPaAPiT62o
- **FR-006**: Video embeds MUST be responsive and display correctly on desktop and mobile devices
- **FR-007**: Videos MUST use proper YouTube embed URLs (youtube.com/embed/ format) for security and functionality

### Key Entities

- **Speaker**: A conference presenter with name, photo, bio, social links, and optionally a YouTube video URL
- **Agenda Item**: A scheduled talk with title, description, speakers, and optionally a video reference
- **Video Configuration**: YouTube embed URL and metadata associated with either a speaker or agenda item

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 10 conference videos are accessible directly from the website without leaving the page
- **SC-002**: Video sections render correctly (no layout shifts or broken embeds) on both desktop and mobile viewports
- **SC-003**: Speakers without videos display cleanly without empty player placeholders
- **SC-004**: The Jekyll build completes successfully without Liquid template errors
- **SC-005**: Site visitors can play videos with a single click (embedded player, not external link)

## Assumptions

- The existing `_includes/video.html` pattern using `include.params` is the desired approach for consistency
- Videos are associated with speakers in the speakers section and optionally with talks in the agenda
- YouTube embed URLs follow the standard format: `https://www.youtube.com/embed/VIDEO_ID`
- All videos are publicly available on YouTube (no authentication required)
