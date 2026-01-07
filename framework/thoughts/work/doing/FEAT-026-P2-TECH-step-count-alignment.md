# FEAT-026 Sub-Item: Align Step Count References

**ID:** FEAT-026-P2-TECH-step-count-alignment
**Parent:** FEAT-026-structure-migration
**Type:** Technical Debt
**Priority:** P2 (Should fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

Fix inconsistency between "9 Steps" and "11 Steps" references across documentation.

---

## Problem

**From followup line 45:**
"We reference The 9 Steps, but CLAUDE references 11. This is another case of duplication. Let's make a note to clean this up."

Documentation is inconsistent about workflow step count:
- Some docs reference "The 9 Steps"
- CLAUDE.md references "The 11 Steps"
- Actual step count unclear

---

## Investigation Needed

1. **Find all step count references:**
   - Search for "9 steps"
   - Search for "11 steps"
   - Search for "steps" in workflow context

2. **Identify actual canonical workflow:**
   - What is the official step count?
   - Where is the source-of-truth?
   - Has it changed over time?

3. **Determine which is correct:**
   - Option A: 9 steps (update CLAUDE.md)
   - Option B: 11 steps (update other refs)
   - Option C: Neither (establish correct count)

---

## Files to Check

- framework/CLAUDE.md
- framework/CLAUDE-QUICK-REFERENCE.md (line 17 mentions this)
- framework/process/* files
- Any workflow guides
- README.md

---

## Strategy

1. **Define canonical workflow** with exact step count
2. **Document in ONE place** as source-of-truth
3. **Update all references** to match
4. **Use consistent terminology** everywhere

---

## Implementation

1. **Search** for all step count references
2. **Review** actual workflow documentation
3. **Establish** correct count
4. **Update** all references to match
5. **Remove** unnecessary step enumerations (link to source instead)

---

## Completion Criteria

- [ ] All step count references found
- [ ] Canonical workflow and step count established
- [ ] All references updated to match
- [ ] Contradictions resolved
- [ ] Source-of-truth clearly designated
- [ ] Changes committed

---

**Last Updated:** 2026-01-06