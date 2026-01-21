# TECH-048: Remove Small Team References from Documentation

**ID:** TECH-048
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-01-11

---

## Summary

Update all framework documentation to accurately reflect current scope: solo developers only. Remove or qualify all references to "small teams" or "2-5 developers" until FEAT-047 (team ID collision support) is implemented.

---

## Problem Statement

**Issue:** Framework documentation currently claims to support small teams (2-5 developers), but the ID assignment system (TECH-046) only works reliably for solo developers. This creates false expectations.

**Where the problem exists:**
- Marketing materials / executive summaries
- README.md files
- PROJECT-STATUS.md
- CLAUDE.md files
- Potentially: templates, guides, other docs

**Who is affected:**
- **Small teams** attempting to adopt framework (will hit ID collisions)
- **Solo developers** who might be confused by team-oriented language
- **Framework credibility** (claiming features we don't have)

**Current state:**
- We've identified the limitation
- TECH-046 updated with caveat
- FEAT-047 created for future team support
- But docs still claim team support

---

## Requirements

### Functional Requirements

- [ ] Identify all locations mentioning "team" or "2-5 developers"
- [ ] Update scope to "solo developers"
- [ ] Add "Future:" notes about planned team support (FEAT-047)
- [ ] Ensure no false claims remain
- [ ] Maintain aspirational roadmap (teams are future goal)

### Non-Functional Requirements

- [ ] Clear and honest about current limitations
- [ ] Professional tone (not apologetic)
- [ ] Forward-looking (teams coming, not never)
- [ ] No breaking changes to structure

---

## Implementation Approach

### Phase 1: Audit

**Search for team-related references:**
```bash
grep -r "team" framework/ --include="*.md"
grep -r "2-5" framework/ --include="*.md"
grep -r "small team" framework/ --include="*.md"
grep -r "collaborative" framework/ --include="*.md"
grep -r "multi-user" framework/ --include="*.md"
```

**Document findings:**
- File paths
- Current text
- Proposed replacement
- Priority (user-facing vs internal)

---

### Phase 2: Update High-Priority Files

**Files to update (priority order):**

1. **README.md (monorepo root)**
   - Current: Likely mentions small teams
   - Update: "Solo developers and AI assistants"
   - Add: "Small team support planned (see roadmap)"

2. **framework/README.md**
   - Current: May claim team support
   - Update: Scope to solo developers
   - Add: Future roadmap note

3. **framework/PROJECT-STATUS.md**
   - Current: Features list might mention teams
   - Update: "Current scope: Solo developers"
   - Add: Known limitations section

4. **framework/CLAUDE.md**
   - Current: May have team collaboration guidance
   - Update: Focus on solo + AI workflow
   - Qualify: Any team references as "planned"

5. **Any executive summaries or marketing content**
   - Current: Pitches to small teams
   - Update: Primary audience is solo developers
   - Add: Team support on roadmap

---

### Phase 3: Update Templates

**Check templates for team references:**
- CLAUDE-TEMPLATE.md
- README-TEMPLATE.md
- PROJECT-STATUS-TEMPLATE.md

**Update if needed:**
- Make team language optional/future
- Focus on solo developer as primary use case

---

### Phase 4: Update Process Documentation

**workflow-guide.md:**
- Review for team workflow sections
- Clarify current scope
- Add "Future: Team Workflows" section referencing FEAT-047

**workflow-guide.md:**
- Ensure ID discovery (TECH-046) caveat is clear
- No false team workflow claims

---

## Documentation Strategy

### Tone and Messaging

**What to say:**
- ✅ "Designed for solo developers working with AI assistants"
- ✅ "Currently validated for solo developer workflows"
- ✅ "Small team support (2-5 developers) planned - see FEAT-047"
- ✅ "The framework is extensible for team use with additional work"

**What NOT to say:**
- ❌ "Sorry, teams aren't supported" (too apologetic)
- ❌ "Teams will never work" (too negative)
- ❌ "Enterprise-ready for teams" (false claim)
- ❌ Remove all team mentions (loses aspirational roadmap)

**Approach:**
Be honest about current scope while maintaining credibility and vision for growth.

---

### Example Replacements

**Before:**
> "Perfect for solo developers and small teams (2-5 people) collaborating with AI assistants."

**After:**
> "Perfect for solo developers collaborating with AI assistants. Small team support (2-5 developers) is on the roadmap (see FEAT-047)."

---

**Before:**
> "Team members can coordinate work items through the kanban workflow."

**After:**
> "The kanban workflow tracks work items for solo developers. Team coordination features are planned for future releases."

---

**Before:**
> "Target users: Solo developers, small teams, anyone tired of losing context."

**After:**
> "Target users: Solo developers using AI assistants. (Small team support planned - see roadmap)."

---

## Files to Check

### Definite Updates Needed:
- [ ] README.md (root)
- [ ] framework/README.md
- [ ] framework/PROJECT-STATUS.md
- [ ] framework/CLAUDE.md

### Likely Updates Needed:
- [ ] framework/docs/collaboration/workflow-guide.md
- [ ] QUICK-START.md
- [ ] Any recent executive summaries (check session history)

### Templates to Review:
- [ ] framework/templates/documentation/CLAUDE-TEMPLATE.md
- [ ] framework/templates/documentation/README-TEMPLATE.md
- [ ] framework/templates/documentation/PROJECT-STATUS-TEMPLATE.md

### Might Need Updates:
- [ ] framework/patterns/ (if any team patterns exist)
- [ ] framework/collaboration/ guides
- [ ] examples/hello-world/ documentation

---

## Success Metrics

**How do we know this work is complete?**

1. ✅ All user-facing docs accurately state "solo developer" scope
2. ✅ No false claims about team support
3. ✅ Clear roadmap notes about FEAT-047 (future team support)
4. ✅ Professional tone maintained
5. ✅ Grep searches for "team" return only appropriate references
6. ✅ No conflicting scope statements across docs

**Validation:**
- Read through updated docs as if you're a new user
- Check for consistency across all files
- Ensure no lingering team claims

---

## Implementation Checklist

- [ ] Phase 1: Audit complete (all team references identified)
- [ ] Phase 2: High-priority files updated
- [ ] Phase 3: Templates reviewed and updated
- [ ] Phase 4: Process docs updated
- [ ] Grep verification (no inappropriate team claims)
- [ ] Consistency check across all docs
- [ ] Professional tone validated
- [ ] Roadmap notes added where appropriate

---

## Dependencies

**Requires:**
- FEAT-047 created (for roadmap references)
- TECH-046 updated (with solo limitation)

**Blocks:**
- None (but should complete before major public release)

**Related:**
- Scope reduction discussion (2026-01-11 session)
- Honest assessment of current capabilities

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Changed
- **TECH-048: Documentation Scope Clarification**
  - Updated all documentation to accurately reflect solo developer scope
  - Removed false small team support claims
  - Added roadmap references for planned team features (FEAT-047)
  - Maintained honest and professional tone about current limitations
```

---

## Notes

**Priority:** Medium
- Not blocking current development
- Important for credibility before public release
- Should complete before marketing push

**Honesty is credibility:**
Better to be clear about limitations than to over-promise and under-deliver. Users respect transparency.

**Future-focused:**
This isn't about giving up on teams - it's about being accurate while building toward that goal.

**Discovered During:**
Discussion about TECH-046 ID algorithm limitations and scope assessment (2026-01-11)

---

**Last Updated:** 2026-01-11
