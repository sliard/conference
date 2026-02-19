# Tasks: Event Photo Gallery

**Input**: Design documents from `/specs/002-photo-gallery/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: Not required for this content-only feature

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: User Story 1 - View Event Photo Gallery (Priority: P1) 🎯 MVP

**Goal**: Add a Gallery section to the homepage displaying all 16 event photos with descriptive alt text, using the existing gallery.html component.

**Independent Test**: Navigate to the homepage, scroll to the gallery section, and verify all 16 photos display in a grid with proper alt text. Click a photo to confirm lightbox opens.

### Implementation for User Story 1

- [X] T001 [US1] Add Gallery configuration to `index.md` front matter with title "Galerie" (or "Photos de l'événement")
- [X] T002 [US1] Add all 16 photos to Gallery.photos array in `index.md` with their alt text:
  - 20251003_100241.webp: "Conference attendees networking and discussing during a break"
  - 20251003_153358.webp: "Group photo of DevFest attendees gathered together"
  - P1030411.webp: "Conference organizer welcoming attendees at the start of the event"
  - P1030435.webp: "Speaker presenting to the audience at DevFest Perros-Guirec"
  - P1030460.webp: "Speaker at podium with projector screen showing presentation slides"
  - P1030566.webp: "Speaker presenting with scenic coastal view visible through large windows"
  - P1030612.webp: "Attendee taking notes during a conference session"
  - P1030723.webp: "Speaker presenting at podium with microphone"
  - P1030879.webp: "Two women presenting together at the conference podium"
  - P1030901.webp: "Event staff member holding a '15 min' time card during a talk"
  - P1030915.webp: "Audience watching a presentation attentively in the conference room"
  - P1030989.webp: "Speaker presenting with DevFest banners visible in the background"
  - P1040064.webp: "Audience member asking a question using a microphone during Q&A"
  - P1040076.webp: "Attendees listening during the Q&A session"
  - P1040112.webp: "Speaker presenting in front of a large DevFest sign"
  - P1040144.webp: "Speaker gesturing at podium with coastal landscape visible through windows"

**Checkpoint**: At this point, User Story 1 should be fully functional. Run `bundle exec jekyll build` to verify clean build.

---

## Phase 2: User Story 2 - Accessibility Support (Priority: P2)

**Goal**: Ensure all gallery photos have descriptive alt text that works with screen readers.

**Independent Test**: Use a screen reader or browser inspector to verify each photo has unique, non-empty alt text that describes the image content.

### Implementation for User Story 2

- [X] T003 [US2] Verify all 16 photos in `index.md` Gallery.photos have descriptive alt text (already completed in T002)
- [X] T004 [US2] Validate alt text is not generic (e.g., not "photo" or "image") and describes actual scene content

**Checkpoint**: At this point, User Story 2 should be complete. Screen readers should announce meaningful descriptions for each photo.

---

## Phase 3: Polish & Validation

**Purpose**: Final validation and build verification

- [X] T005 Run `bundle exec jekyll build` and verify no errors or warnings
- [X] T006 Verify gallery displays correctly at http://localhost:4000
- [X] T007 Confirm responsive behavior (2-column grid on desktop, single column on mobile)

---

## Dependencies & Execution Order

### Phase Dependencies

- **User Story 1 (P1)**: No dependencies - uses existing infrastructure. Start immediately.
- **User Story 2 (P2)**: Depends on User Story 1 completion (alt text is added in T002)
- **Polish (Phase 3)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Independent - adds Gallery configuration to index.md
- **User Story 2 (P2)**: Depends on User Story 1 - validates alt text accessibility

### Within Each User Story

- Sequential execution within this simple feature
- T001 must complete before T002 (create Gallery structure before adding photos)

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: User Story 1 (T001, T002)
2. **STOP and VALIDATE**: Run Jekyll build and test gallery locally
3. Deploy/demo if ready

### Incremental Delivery

1. Add User Story 1 → Test gallery displays correctly → Deploy (MVP!)
2. Validate User Story 2 → Confirm accessibility → Done

---

## Notes

- This is a content-only feature - no new code files or dependencies
- All infrastructure exists: `_includes/gallery.html` component, photos in `assets/2025/photos_event/`
- Main work: Add Gallery YAML front matter to `index.md` following existing patterns
- Alt text must be in English as per the photo inventory in spec.md
- Photo URLs should follow pattern: `assets/2025/photos_event/FILENAME.webp`
- Commit after T002 when all photos are added
