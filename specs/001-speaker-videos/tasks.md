---
description: "Task list for Speaker Videos feature implementation"
---

# Tasks: Speaker Videos

**Input**: Design documents from `/specs/001-speaker-videos/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/, research.md, quickstart.md
**Feature Branch**: `001-speaker-videos`

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: Project validation and preparation

- [x] T001 Verify Jekyll development environment by running `bundle exec jekyll build` in repository root

---

## Phase 2: User Story 1 - View Speaker Talk Video (Priority: P1)

**Goal**: Enable visitors to watch recorded talks directly on speaker profile sections

**Independent Test**: Navigate to a speaker's section and verify the embedded YouTube video loads and plays correctly

### Implementation for User Story 1

- [x] T002 [P] [US1] Add `video_url` field to speaker data for Alain Buzacarro in `index.md`
- [x] T003 [P] [US1] Add `video_url` field to speaker data for Stéphane Prohaszka in `index.md`
- [x] T004 [P] [US1] Add `video_url` field to speaker data for Hannah Issermann in `index.md`
- [x] T005 [P] [US1] Add `video_url` field to speaker data for Isabelle Chanclou in `index.md`
- [x] T006 [P] [US1] Add `video_url` field to speaker data for Cédric Clavier in `index.md`
- [x] T007 [P] [US1] Add `video_url` field to speaker data for Christophe Milon in `index.md`
- [x] T008 [P] [US1] Add `video_url` field to speaker data for Pierrick Blons in `index.md`
- [x] T009 [P] [US1] Add `video_url` field to speaker data for Sébastien Ferrer in `index.md`
- [x] T010 [P] [US1] Add `video_url` field to speaker data for Frédéric Bouchery in `index.md`
- [x] T011 [US1] Refactor `_includes/speakers.html` to use `include.params` pattern matching `video.html`
- [x] T012 [US1] Add conditional video embed rendering in `_includes/speakers.html` when `speaker.video_url` is present
- [x] T013 [US1] Add responsive iframe styling for video embeds in `_includes/speakers.html`
- [x] T014 [US1] Update `_layouts/home_conference.html` to pass `page.Speakers` as params to speakers include
- [x] T015 [US1] Add `title` attribute to iframe for accessibility in `_includes/speakers.html`

**Checkpoint**: At this point, User Story 1 should be fully functional - speakers with videos show embedded players, speakers without videos display correctly

---

## Phase 3: User Story 2 - Access Videos from Agenda Talks (Priority: P1)

**Goal**: Enable visitors to watch recorded talks directly from the agenda section

**Independent Test**: Scroll to the agenda section, find a talk with speakers, and verify the video appears below the talk description (via speaker link)

### Implementation for User Story 2

- [x] T016 [US2] Verify agenda speaker IDs match speaker section IDs for video linking in `index.md`
- [x] T017 [US2] Add anchor links from agenda items to corresponding speaker sections in `_includes/agenda.html`

**Checkpoint**: At this point, User Stories 1 AND 2 should both work - agenda links to speakers with videos

---

## Phase 4: User Story 3 - Consistent Video Presentation (Priority: P2)

**Goal**: Ensure all videos have consistent look and feel for a professional viewing experience

**Independent Test**: Verify all video players use the same styling, dimensions, and follow the include template pattern

### Implementation for User Story 3

- [x] T018 [US3] Add CSS for responsive video wrapper with 16:9 aspect ratio in `_includes/speakers.html`
- [x] T019 [US3] Ensure iframe styling matches existing `video.html` implementation
- [x] T020 [US3] Verify all 9 speaker videos display consistently across desktop and mobile viewports

**Checkpoint**: All user stories should now be independently functional with consistent presentation

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and quality assurance

- [x] T021 Run Jekyll build validation: `bundle exec jekyll build` completes without Liquid errors
- [x] T022 Verify responsive behavior on mobile viewport (iframe scales correctly)
- [x] T023 Verify speakers without `video_url` display cleanly without empty player placeholders
- [x] T024 Validate YouTube embed URLs are in correct format (`/embed/` not `/watch?v=`)
- [x] T025 Run quickstart.md validation steps from feature documentation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **User Story 1 (Phase 2)**: Depends on Setup completion
- **User Story 2 (Phase 3)**: Depends on User Story 1 completion (requires working speaker videos to link to)
- **User Story 3 (Phase 4)**: Depends on User Story 1 completion (requires videos to be styled consistently)
- **Polish (Phase 5)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup - Foundation for all video functionality
- **User Story 2 (P1)**: Can start after US1 - Extends video access to agenda section
- **User Story 3 (P2)**: Can start after US1 - Quality/consistency improvements

### Within Each User Story

- Data updates (video_url additions) can happen in parallel
- Template refactoring must happen before conditional rendering logic
- Styling must be added after template structure is complete

### Parallel Opportunities

- All 9 speaker `video_url` additions (T002-T010) can run in parallel
- US2 and US3 can proceed in parallel once US1 is complete
- Polish phase tasks marked [P] can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all video URL additions together:
Task: "Add video_url field to speaker data for Alain Buzacarro in index.md"
Task: "Add video_url field to speaker data for Stéphane Prohaszka in index.md"
Task: "Add video_url field to speaker data for Hannah Issermann in index.md"
Task: "Add video_url field to speaker data for Isabelle Chanclou in index.md"
Task: "Add video_url field to speaker data for Cédric Clavier in index.md"
Task: "Add video_url field to speaker data for Christophe Milon in index.md"
Task: "Add video_url field to speaker data for Pierrick Blons in index.md"
Task: "Add video_url field to speaker data for Sébastien Ferrer in index.md"
Task: "Add video_url field to speaker data for Frédéric Bouchery in index.md"

# Then template work (depends on data being ready):
Task: "Refactor _includes/speakers.html to use include.params pattern"
Task: "Add conditional video embed rendering in _includes/speakers.html"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: User Story 1 - Add all 9 speaker videos and template support
3. **STOP and VALIDATE**: Test that videos display correctly for all speakers
4. Verify Jekyll build succeeds

### Incremental Delivery

1. Complete Setup + US1 → Foundation with working speaker videos
2. Add US2 → Agenda links to speakers with videos
3. Add US3 → Consistent styling across all videos
4. Each phase adds value without breaking previous functionality

### Parallel Team Strategy

With multiple developers:

1. One developer: Add all video_url fields to index.md (T002-T010)
2. Another developer: Refactor speakers.html template (T011-T015)
3. Once US1 complete:
   - Developer A: Agenda linking (US2)
   - Developer B: Styling consistency (US3)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Video URLs must use embed format: `https://www.youtube.com/embed/VIDEO_ID`
- Hannah Issermann and Isabelle Chanclou share the same video (co-presenters)
- "Mot d'introduction" and "Présentation Ada Lovelace" are special segments without dedicated speaker profiles
