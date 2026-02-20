# Chore: Sync fw-session-history local command with plugin enhancements

**ID:** CHORE-146
**Type:** Chore
**Priority:** Low
**Created:** 2026-02-19

---

## Summary

Update `.claude/commands/fw-session-history.md` to match the improvements made in the `spearit-framework` plugin version - specifically adding the Senior Technical Writer mindset block, the missing directory fallback, and aligning the output template (minus the Role field).

---

## Scope

- Add Role & Mindset block (Senior Technical Writer)
- Add `project-hub/` missing directory fallback in Behavior step 1
- Drop `**Role:**` field from output template
- Drop `*See also* workflow-guide.md` cross-reference
- Keep inline template (vs. plugin's external file reference)
- Keep `/fw-move` integration point references (not plugin-namespaced)

---

## Completion Criteria

- [ ] Local command has Senior Technical Writer mindset block
- [ ] Local command has directory fallback note
- [ ] Output template matches plugin template (no Role field)
- [ ] No broken cross-references

---

## Dependencies

None

---

**Last Updated:** 2026-02-19
**Status:** Backlog
