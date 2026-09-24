# FEAT-030: Add work/hold/ Folder to Workflow

**ID:** FEAT-030
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-01-08
**Theme:** Workflow

---

## Summary

Add a work/hold/ folder to the workflow structure for work items that are paused due to urgent interruptions or external blockers.

---

## Problem Statement

**Issue identified during:** FEAT-026 implementation discussions

Reality of work: Urgent items sometimes interrupt planned work, requiring the current work item to be paused.

**Current workaround:**
- Items stay in doing/ folder even when paused (misleading)
- Or get moved back to todo/ (loses "was in progress" context)
- Ad-hoc solutions that don't capture the "on hold" state

**Who is affected?**
- Individual developers managing interruptions
- Team members trying to understand what's actively being worked on
- Process adherence when reality doesn't match workflow structure

---

## Requirements

### Functional Requirements

- [-] Add work/hold/ folder to project-hub/work/ structure
- [-] Document when to use hold/ vs. other folders
- [x] Define what "on hold" means (vs. blocked, paused, etc.)
- [x] Establish process for moving items to/from hold/
- [-] Update workflow documentation with hold/ folder usage

### Non-Functional Requirements

- [-] Documentation: Update workflow-guide.md and CLAUDE.md
- [-] Compatibility: Ensure existing work items not affected
- [-] Simplicity: Keep workflow simple and intuitive

---

## Design

### Folder Structure

```
project-hub/work/
├── backlog/          # Not yet prioritized
├── todo/             # Ready to start
├── doing/            # Actively working on NOW
├── hold/             # On hold (NEW)
├── done/             # Completed, ready for release
└── releases/         # Released items
```

### When to Use hold/

**Move item to hold/ when:**
- Urgent work interrupts current item (emergency fix, critical request)
- External blocker prevents progress (waiting on decision, dependency)
- Temporarily paused but intend to resume (not abandoned)

**hold/ is NOT for:**
- Blocked items waiting on other work items (stays in doing/ or todo/)
- Items you're not sure about (belongs in backlog/)
- Abandoned items (archive or cancel)

**Characteristics of held items:**
- Clear reason for hold documented in work item
- Expected to resume eventually
- Not actively being worked on

### Process

**Moving to hold/:**
1. Update work item with hold reason and date
2. Move file to work/hold/
3. Optional: Add note about what will unblock

**Resuming from hold/:**
1. Verify blocker is resolved or interruption complete
2. Update work item with resume date
3. Move to doing/ to resume work

---

## Documentation Updates

### Files to Update

- [-] framework/process/workflow-guide.md - Add hold/ folder explanation
- [-] framework/CLAUDE.md - Update folder list
- [-] Work item templates - Add "Hold Information" section (optional)
- [-] INDEX.md - Reference hold/ folder usage

### New Documentation

Minimal - add section to workflow-guide.md:

```markdown
## work/hold/ - On Hold Items

Items in hold/ are temporarily paused due to:
- Urgent interruptions (higher priority work)
- External blockers (waiting on decisions, dependencies)

**Process:**
1. Document hold reason in work item
2. Move to hold/ folder
3. When unblocked, move to doing/ to resume

**Hold is NOT for:**
- Items blocked by other work items (stay in doing/)
- Items you're uncertain about (backlog/)
- Abandoned items (archive/)
```

---

## Implementation Checklist

- [-] Create work/hold/ folder
- [-] Update workflow-guide.md with hold/ documentation
- [-] Update CLAUDE.md folder structure
- [-] Add examples of when to use hold/
- [-] Consider adding Hold Information section to templates (optional)
- [-] Update INDEX.md

---

## Alternatives Considered

**Option 1: Use status field instead of folder**
- Pros: No new folder needed
- Cons: Folder IS status in our workflow, adding field-based status is redundant
- Decision: Folder approach maintains consistency

**Option 2: Use blocked/ folder name**
- Pros: Clear that item can't progress
- Cons: "Blocked" implies dependency on something specific; "hold" is more general
- Decision: "hold" better captures temporary pause for various reasons

**Option 3: Keep items in doing/ with status note**
- Pros: No new folder
- Cons: doing/ should reflect active work; mixing active and paused items is misleading
- Decision: Separate folder provides clearer state

---

## Success Metrics

- Clearer workflow state visibility (doing/ truly reflects active work)
- Reduced confusion about work item status
- Better handling of real-world interruptions
- Improved process adherence

---

## References

- Source: project-hub/research/backlog-ideas-from-feat-026.md (Item #1)
- Origin: FEAT-026-followup.md line 8
- Related: TECH-027 (cross-reference conventions)

---

## Notes

**Philosophy:**
- Acknowledge reality - interruptions happen
- Provide explicit structure rather than ad-hoc solutions
- Keep workflow simple and practical

**Scope:**
- This is a structural addition (folder + documentation)
- No automation or tooling required
- Manual process is sufficient

---

**Last Updated:** 2026-01-08

---

## RESOLVED — 2026-09-23 (TASK-242)

**`hold/` is adopted, with this card's purpose intact and its definition sharpened.**

Decided in **TASK-242**, which settled the board's terminal and parked states as one set rather
than folder-by-folder:

> **hold** — a decision to prioritise another card
> **blocked** — cannot proceed due to some external issue

**That is this card's distinction, stated more tightly.** This card said hold is *"temporarily
paused but intend to resume"* and explicitly **not** for *"blocked items waiting on other work"* —
which is exactly the line TASK-242 draws by giving that case its own folder.

**A combined `park/` folder was proposed and rejected.** More concise, but *blocked* and *hold* are
what a newcomer — including a fresh AI session — understands without a lookup (Gary, 2026-09-23).

**What changed from this card's design:**

- **The folder set is the new build's** (`kanban/`), not `project-hub/work/`. This card's folder
  diagram predates ADR-009.
- **`accept/` now exists** between `doing` and `done`, which this card did not anticipate. It
  matters here: **a card with merged code does not go to `hold/`** — it stays in `accept/` or
  returns to `doing/` (TASK-242 decision 1). This card's *"urgent work interrupts current item"*
  case therefore applies to work **not yet implemented**, not to half-finished code.
- **Transitions are mechanized**, not documented: `backlog|todo|doing → hold` and
  `hold → backlog|todo|doing`. No `hold ↔ blocked` — a changed cause goes via a real state rather
  than shuffling between parked folders.

**Implementation is FEAT-229.3**, which encodes TASK-242's transition set.

**On the checklists above:** the two items TASK-242 genuinely answered — *define what "on hold"
means* and *when to use hold/ vs other folders* — are `[x]`. **Everything else is `[-]`
(cancelled / not applicable)**, because every one names an **old-build** path
(`project-hub/work/`, `framework/process/workflow-guide.md`, `framework/CLAUDE.md`, `INDEX.md`)
that this work no longer touches. The folder lands in `kanban/` via FEAT-229.3, and the new build
has no workflow-guide to update.

`[-]` is used deliberately rather than `[x]`: ticking them would claim old-build documentation was
updated when it never will be (TECH-177's convention — cancelled work does not block completion,
and it is not the same as completed work).

**Closing as resolved, not superseded** — the folder this card asked for exists, for the reason it
gave. Open 2026-01-08 → 2026-09-23.
