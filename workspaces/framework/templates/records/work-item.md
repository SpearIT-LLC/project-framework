<!-- Work-item template (plugin: templates/records/work-item.md).
     Created ONLY by fw-new.sh, into kanban/backlog/ as TYPE-nnn-<slug>.md.
     One shared sequence per kanban queue; the PREFIX carries the type, the
     FOLDER carries the status (backlog -> todo -> doing -> accept -> done).
     Never create or move by hand - use /fw-new and /fw-move.

     TYPES (ADR-006, five accepted): FEAT BUG TECH TASK SPIKE.
     Any prefix already on disk outside these five is legacy - parsed, never
     offered for creation.

     SUB-ITEMS - two mechanisms, different jobs (TASK-219 Group 1):
       Dotted id (FEAT-021.1) = tight coupling. The child lives and dies with
         the parent, moves with it, and counts as part of the SAME one item
         against the WIP limit. Use when the child makes no sense alone.
       Parent: field    = provenance. The child stands alone, is worked and
         moved separately, counts as its OWN item against WIP, but traces back.
         Use for work DISCOVERED during a parent (the common case).
     Max depth for dotted ids is 3 (parent.child.grandchild). Needing a 4th
     level means the parent is too big.

     Working material (drafts, logs, screenshots) lives in a sibling folder
     named for the id (FEAT-nnn/) that the move engine carries with the record.
     Completed: is stamped by the move engine on -> done; leave it blank.
     Delete optional fields that do not apply rather than leaving placeholders. -->
# __TITLE__

**ID:** __ID__
**Type:** __TYPE__
**Priority:** __High | Medium | Low__
**Created:** __CREATED__
**Workspace:** __workspace name, or delete if repo-level__
**Parent:** __TYPE-nnn - only for discovered work that stands alone; or delete__
**Depends On:** __TYPE-nnn, TYPE-nnn - must be in done/ before this can start; or delete__
**Completed:**

## Summary

__One or two sentences: what this is and why it is needed. Written so a reader
who has never seen the card knows whether it concerns them.__

## Problem Statement

__What is the current state, why it is a problem, and what the desired state is.
For a BUG: what happens, what should happen, and how to reproduce it.__

## Proposed Solution

__The approach. Name the files or areas affected. Record options considered and
why the chosen one won - a decision without its reason gets re-litigated.__

## Acceptance Criteria

<!-- The done-gate reads these. [ ] and [/] block the move to done/;
     [x] done and [-] cancelled/not-applicable pass. Write them so they can be
     checked, not admired. -->

- [ ] __Something observable that is true when this is finished__
- [ ] __Verified against the built plugin, not the source tree__

## Notes

__Anything that does not fit above: constraints, quotes from the discussion that
settled a decision, things deliberately left out of scope.__

## Related

- __TYPE-nnn - how it relates, not just that it does__
