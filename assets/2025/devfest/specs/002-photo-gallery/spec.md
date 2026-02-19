# Feature Specification: Event Photo Gallery

**Feature Branch**: `002-photo-gallery`
**Created**: 2026-02-17
**Status**: Draft
**Input**: User description: "add a photo gallery of the event with _includes/gallery.html component into the index.md page. add alt to photo depending on what you see on them. photos are in assets/2025/photos_event folder. Add them all."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Event Photo Gallery (Priority: P1)

As a website visitor, I want to browse photos from the DevFest Perros-Guirec 2025 event so that I can see what the conference was like and get a feel for the atmosphere.

**Why this priority**: The photo gallery provides visual social proof of the event's success and helps future attendees understand the conference experience. This is the core value of the feature.

**Independent Test**: Can be fully tested by navigating to the gallery section on the homepage and verifying all 16 photos display correctly with proper alt text, and that clicking photos opens the lightbox view.

**Acceptance Scenarios**:

1. **Given** I am on the DevFest Perros-Guirec homepage, **When** I scroll to the gallery section, **Then** I see a grid of event photos with a section title
2. **Given** I am viewing the gallery section, **When** I look at any photo, **Then** I see descriptive alt text that accurately describes what's in the image
3. **Given** I am viewing the gallery section, **When** I click on a photo, **Then** the lightbox opens showing the full-size image

---

### User Story 2 - Accessibility Support (Priority: P2)

As a visually impaired user, I want photo descriptions via screen readers so that I can understand the visual content of the event photos.

**Why this priority**: Accessibility compliance is important for inclusive design and may be legally required. This ensures all users can benefit from the gallery content.

**Independent Test**: Can be tested using a screen reader to verify that all 16 photos have meaningful alt text that describes the scene, people, and context.

**Acceptance Scenarios**:

1. **Given** I am using a screen reader, **When** I navigate to a gallery photo, **Then** the screen reader announces descriptive alt text for that image
2. **Given** I am using a screen reader, **When** I navigate through all gallery photos, **Then** each photo has unique, non-generic alt text

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST display a photo gallery section on the homepage using the existing `_includes/gallery.html` component
- **FR-002**: The gallery MUST include all 16 photos from the `assets/2025/photos_event/` folder
- **FR-003**: Each photo MUST have descriptive alt text that accurately describes the visual content
- **FR-004**: The gallery MUST be integrated into `index.md` using the `include.params` pattern consistent with other sections
- **FR-005**: The gallery MUST display in a responsive 2-column grid layout (as defined in the existing gallery component)
- **FR-006**: Each photo MUST be clickable to open a lightbox view (as defined in the existing gallery component)
- **FR-007**: The gallery section MUST have a title and optional description configured via front matter

### Key Entities

- **Gallery**: A collection of event photos displayed in a grid layout with lightbox functionality
- **Photo**: An image file with associated metadata including URL path and descriptive alt text
  - `url`: Path to the image file (relative to site baseurl)
  - `alt`: Descriptive text describing the visual content for accessibility

### Photo Inventory

The following 16 photos must be included with their respective alt text:

| Filename | Alt Text |
|----------|----------|
| 20251003_100241.webp | Conference attendees networking and discussing during a break |
| 20251003_153358.webp | Group photo of DevFest attendees gathered together |
| P1030411.webp | Conference organizer welcoming attendees at the start of the event |
| P1030435.webp | Speaker presenting to the audience at DevFest Perros-Guirec |
| P1030460.webp | Speaker at podium with projector screen showing presentation slides |
| P1030566.webp | Speaker presenting with scenic coastal view visible through large windows |
| P1030612.webp | Attendee taking notes during a conference session |
| P1030723.webp | Speaker presenting at podium with microphone |
| P1030879.webp | Two women presenting together at the conference podium |
| P1030901.webp | Event staff member holding a "15 min" time card during a talk |
| P1030915.webp | Audience watching a presentation attentively in the conference room |
| P1030989.webp | Speaker presenting with DevFest banners visible in the background |
| P1040064.webp | Audience member asking a question using a microphone during Q&A |
| P1040076.webp | Attendees listening during the Q&A session |
| P1040112.webp | Speaker presenting in front of a large DevFest sign |
| P1040144.webp | Speaker gesturing at podium with coastal landscape visible through windows |

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 16 photos from the assets/2025/photos_event folder are displayed in the gallery
- **SC-002**: Each photo has unique, descriptive alt text that accurately describes the image content
- **SC-003**: The gallery section displays correctly on desktop (2-column grid) and mobile (single column) devices
- **SC-004**: Clicking any photo opens the lightbox functionality as defined in the existing gallery component
- **SC-005**: The gallery section is accessible via screen readers with meaningful photo descriptions
