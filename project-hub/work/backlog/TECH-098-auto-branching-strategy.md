# Tech Debt: Auto-Branching Strategy

**ID:** TECH-098
**Type:** Tech Debt
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2026-01-30

---

## Summary

Explore adding automatic branch creation capability to fw-move workflow, potentially as a configurable project setting or recommended based on project type, to support safer isolation of work item changes.

---

## Problem Statement

**What is the current state?**

Current workflow is trunk-based development:
- Work directly on main branch
- Commit incrementally as work progresses
- Works well for solo/small teams on docs/templates
- Simple, low overhead

But no guidance or tooling for when branching makes sense:
- Complex features that span multiple sessions
- Experimental work that might be abandoned
- Work that needs review before merging
- Parallel work on multiple items

**Why is this a problem?**

- No clear guidance on when to branch vs. trunk
- No tooling support for consistent branching
- Manual branch creation prone to inconsistent naming
- May clutter main history for large features
- Harder to abandon experimental work

**What is the desired state?**

Clear branching strategy with optional automation:
- Documented guidance on when to branch
- Optional auto-branch creation integrated with fw-move
- Consistent branch naming conventions
- Project-configurable (some projects always branch, some never)
- Could be recommended based on project type

---

## Proposed Solution

### 1. Document Branching Strategies

Add "Branching Strategy" section to workflow-guide.md:

**Trunk-Based Development (Default):**
- Work directly on main
- Best for: Small items, single-session work, low-risk changes
- Used by: Solo devs, small teams, rapid iteration

**Feature Branches:**
- Branch per work item
- Best for: Multi-session work, experimental features, items needing review
- Workflow:
  ```bash
  /fw-move FEAT-097 doing
  git checkout -b feat-097-release-sizing
  # ... work ...
  /fw-move FEAT-097 done
  git checkout main
  git merge feat-097-release-sizing
  git branch -d feat-097-release-sizing
  ```

**When to Branch:**
- FEAT items (larger scope, multi-session)
- SPIKE items (experimental, might abandon)
- DECISION items (might want review/discussion)
- Items marked "experimental" or "risky"

**When to Use Trunk:**
- TECH items (small improvements)
- BUG items (quick fixes)
- Documentation updates
- Single-session work

### 2. Project Configuration Option

Add to framework.yaml:

```yaml
workflow:
  branching:
    strategy: auto      # or: manual, never
    pattern: "{type}-{id}-{slug}"
    auto_branch_for:    # Auto-branch for these types
      - FEAT
      - SPIKE
      - DECISION
```

**Strategy Options:**
- `auto`: fw-move automatically creates/switches branches based on work item type
- `manual`: User creates branches manually, documentation provides guidance
- `never`: Trunk-based only, no branching (current behavior)

### 3. fw-move Integration

If `branching.strategy: auto`:

**Moving to doing:**
```bash
/fw-move FEAT-097 doing

# AI checks: Is FEAT in auto_branch_for list?
# If yes:
#   - Create branch: feat-097-release-sizing
#   - Switch to branch
#   - Report: "Created and switched to branch feat-097-release-sizing"
```

**Moving to done:**
```bash
/fw-move FEAT-097 done

# AI checks: Are we on feature branch?
# If yes:
#   - Merge to main
#   - Delete feature branch
#   - Report: "Merged feat-097-release-sizing to main and deleted branch"
# If no:
#   - Normal done/ move (trunk-based)
```

**Abandoning work:**
```bash
/fw-move FEAT-097 backlog

# AI checks: Are we on feature branch?
# If yes:
#   - Prompt: "Delete branch feat-097-release-sizing? Changes will be lost."
#   - If confirmed: switch to main, delete branch
```

### 4. Project Type Recommendations

After FEAT-089 (project patterns) is implemented, could recommend:

**Documentation projects:**
- Default: `strategy: manual`
- Rationale: Low risk, trunk works well

**Library projects:**
- Default: `strategy: auto` with `auto_branch_for: [FEAT, SPIKE]`
- Rationale: API changes benefit from isolation

**Application projects:**
- Default: `strategy: auto` with `auto_branch_for: [FEAT, SPIKE, DECISION]`
- Rationale: Features often multi-session, benefit from review

**Files Affected:**
- `framework/docs/collaboration/workflow-guide.md` - Add Branching Strategy section
- `framework/docs/ref/framework-schema.yaml` - Add branching configuration schema
- `.claude/commands/fw-move.md` - Add auto-branch logic
- `framework.yaml` - Example configuration (commented)
- `framework/CHANGELOG.md` - Document branching capability

---

## Acceptance Criteria

- [ ] Branching strategy documented in workflow-guide.md
- [ ] When-to-branch guidance clear (type, scope, session count)
- [ ] framework-schema.yaml has branching configuration schema
- [ ] fw-move supports auto-branching (if configured)
- [ ] Branch naming pattern configurable
- [ ] Works with doing → done → backlog transitions
- [ ] Prompts for confirmation on abandoning branches
- [ ] Example configuration in framework.yaml (commented)
- [ ] CHANGELOG.md updated
- [ ] Tested with both auto and manual modes

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: Branching strategies, configuration options, fw-move integration
  - User explicitly approves before proceeding

- [ ] Document branching strategies in workflow-guide.md
- [ ] Add branching schema to framework-schema.yaml
- [ ] Implement auto-branching logic in fw-move.md
- [ ] Add example configuration to framework.yaml (commented)
- [ ] Test auto mode: Create branch on → doing
- [ ] Test auto mode: Merge branch on → done
- [ ] Test auto mode: Delete branch on → backlog (with prompt)
- [ ] Test manual mode: Documentation only
- [ ] Update CHANGELOG.md
- [ ] Acceptance criteria verified

---

## Notes

**Design Principles:**

1. **Default to simplicity** - Trunk-based unless configured otherwise
2. **User always in control** - Can override, disable, or ignore automation
3. **Consistent naming** - Pattern-based branch names prevent ad-hoc variations
4. **Fail gracefully** - If branching fails, fall back to trunk-based with warning

**Edge Cases to Consider:**

- What if user manually creates branch before /fw-move?
  - Detect existing branch, use it instead of creating new one
- What if merge conflicts occur?
  - Abort merge, report conflict, require manual resolution
- What if user is already on different branch?
  - Warn and ask for confirmation before switching
- What if git is in detached HEAD or other unusual state?
  - Detect and warn, suggest manual workflow

**Future Enhancements:**

- Integration with GitHub/GitLab for PR creation
- Branch protection rules based on work item type
- Auto-rebase vs. auto-merge configuration
- Stash/unstash automation when switching branches

**Relationship to FEAT-089:**

After project patterns (FEAT-089) are documented, we could:
- Recommend branching strategy based on project type
- Set different defaults in templates
- Document strategy variations and trade-offs

**Current Framework:**

For now, framework project likely stays trunk-based:
- Mostly docs/templates (low risk)
- Solo/small team (no parallel work conflicts)
- Rapid iteration preferred
- But having the capability available for users' projects

---

## Related

- `framework/docs/collaboration/workflow-guide.md` - Will add Branching Strategy section
- `.claude/commands/fw-move.md` - Will add auto-branch logic
- `framework/docs/ref/framework-schema.yaml` - Configuration schema
- FEAT-089: Project Patterns - Will inform project-type recommendations
- Session history: `project-hub/history/sessions/2026-01-30-SESSION-HISTORY.md`

---

**Last Updated:** 2026-01-30
