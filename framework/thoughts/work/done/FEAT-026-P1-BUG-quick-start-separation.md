# FEAT-026 Sub-Item: Clarify README Quick Start vs QUICK-START.md

**ID:** FEAT-026-P1-BUG-quick-start-separation
**Parent:** FEAT-026-structure-migration
**Type:** Bug (Confusion/Duplication)
**Priority:** P1 (Critical - must fix before merge)
**Status:** Todo
**Created:** 2026-01-06

---

## Summary

There is confusion between the "Quick Start" section in README.md and the dedicated QUICK-START.md file. Need clear separation of purpose.

---

## Problem

**From followup line 23:**
"So we have a quick start guide in the readme and a quick start doc? I think we made a decision to make a clear separation between these two."

Currently:
- `README.md` has a "Quick Start" section
- `QUICK-START.md` exists as a separate file
- Purpose/difference not clear

---

## Decision Needed

What should each contain?

**Option 1: Different Depths**
- README Quick Start: 30-second "what is this, where do I start"
- QUICK-START.md: Complete quick reference guide

**Option 2: Different Audiences**
- README Quick Start: First-time users
- QUICK-START.md: Returning users who need quick lookup

**Option 3: README points to QUICK-START**
- README Quick Start: Just a pointer to QUICK-START.md
- QUICK-START.md: All quick start content

---

## Current State

**README.md Quick Start (lines 23-56):**
- Overview of framework levels
- Copy commands
- Setup checklist references

**QUICK-START.md:**
- Comprehensive quick reference
- Decision trees
- Common operations
- Templates reference

---

## Implementation

1. **Decide on separation strategy** (propose Option 1)
2. **Update README Quick Start** to be brief (3-5 minute read)
3. **Ensure QUICK-START.md** is comprehensive reference
4. **Add clear note** in README about when to use each

**Proposed README Quick Start:**
- 2-3 paragraphs max
- Links to QUICK-START.md and template selection guide
- Points to project-hello-world/ example

**Proposed QUICK-START.md:**
- Keep current comprehensive format
- Add note at top: "This is a comprehensive reference. For a brief overview, see README.md"

---

## Completion Criteria

- [ ] Clear purpose defined for each
- [ ] README Quick Start updated (brief)
- [ ] QUICK-START.md updated (comprehensive)
- [ ] Cross-references added
- [ ] No duplication between files
- [ ] Changes committed

---

**Last Updated:** 2026-01-06