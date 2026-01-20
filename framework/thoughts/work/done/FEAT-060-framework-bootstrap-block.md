# Feature: Framework Bootstrap Block for Root CLAUDE.md

**ID:** 060
**Type:** Feature
**Version Impact:** PATCH (documentation enhancement)
**Status:** Done
**Created:** 2026-01-17
**Completed:** 2026-01-20
**Developer:** Claude

---

## Summary

Add a minimal bootstrap section to the root `/CLAUDE.md` that makes the AI aware of `framework.yaml`, roles, and policies without duplicating the full guidance from `/framework/CLAUDE.md`. This ensures the roles system (FEAT-059) triggers reliably at session start.

---

## Problem Statement

**What problem does this solve?**

The root `/CLAUDE.md` is automatically injected into the AI's context at session start, but `/framework/CLAUDE.md` (which contains the full roles and workflow guidance) is not. The AI needs to know *that* a framework exists and *when* to read more, without reading 580 lines upfront.

Without this bootstrap block:
- AI may not realize roles exist
- AI may not check `framework.yaml` for policies
- AI may not ask "What kind of work are we doing?" at session start
- FEAT-059 (context-aware AI roles) may not trigger as intended

**Who is affected?**

- AI assistants working with projects using this framework
- Users who expect role-based behavior from session start

**Current workaround (if any):**

User must explicitly ask AI to read `/framework/CLAUDE.md`, or AI must proactively decide to read it (unreliable).

---

## Requirements

### Functional Requirements

- [x] Add ~15 line bootstrap section to root `/CLAUDE.md`
- [x] Bootstrap must reference `framework.yaml` as the config hub
- [x] Bootstrap must indicate roles and policies exist
- [x] Bootstrap must specify when to read full guidance
- [x] Bootstrap must not duplicate content from `/framework/CLAUDE.md`

### Non-Functional Requirements

- [x] Performance: No additional file reads required at session start (just awareness)
- [x] Compatibility: Existing workflow unchanged, just better triggered
- [x] Documentation: Self-contained change to `/CLAUDE.md`

---

## Design

### Proposed Bootstrap Block

```markdown
## Framework Bootstrap

This project uses the SpearIT Project Framework. Before acting, check:

1. **Read `framework.yaml`** - Contains policies and role configuration
2. **Check `roles.default`** - Adopt this role's mindset (see `roles.definitions` path)
3. **Before workflow actions** (moving work items, releases) - Read the policy referenced in `policies.onTransition`

**When to read full guidance:**
- Working on framework itself -> [framework/CLAUDE.md](framework/CLAUDE.md)
- Unsure what role applies -> Ask "What kind of work are we doing?"
- About to modify code/docs -> Check role mindset first

**Key principle:** Policies exist. Read before acting on workflow, releases, or role-specific work.
```

### Architecture Impact

**Files Modified:**
- `/CLAUDE.md` - Add bootstrap section after "Project Configuration" section

**Files Added:**
- None

### Implementation Approach

1. Insert bootstrap block after the existing "Project Configuration" section in `/CLAUDE.md`
2. Keep it concise (~15 lines)
3. Use action-oriented language ("Before acting, check...")
4. Reference but don't duplicate `/framework/CLAUDE.md` content

---

## Dependencies

**Requires:**
- FEAT-059 (context-aware AI roles) - The system this enables

**Blocks:**
- None

**Related:**
- FEAT-059 (context-aware AI roles)

---

## Testing Plan

### Manual Testing Steps

1. Start a new session with the framework
2. Verify AI reads `framework.yaml` early in session
3. Verify AI asks about work context or adopts default role
4. Test that workflow actions (moving work items) trigger policy lookup
5. Verify AI knows to read `/framework/CLAUDE.md` for detailed guidance when needed

### Edge Cases

- [x] AI enters via different sub-project (examples/hello-world) - bootstrap still applies
- [x] User immediately gives command without context - AI should ask or adopt default role

---

## Security Considerations

N/A - Documentation only.

---

## Documentation Updates

### Files to Update

- [x] `/CLAUDE.md` - Add bootstrap section

### New Documentation Needed

- None (self-contained)

---

## Implementation Checklist

- [x] Design reviewed and approved
- [x] Bootstrap block added to `/CLAUDE.md`
- [x] Verified no duplication with `/framework/CLAUDE.md`
- [x] Manual testing completed
- [ ] CHANGELOG.md updated (pending release)

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- Framework bootstrap block in root CLAUDE.md
  - Ensures AI awareness of framework.yaml, roles, and policies at session start
  - Enables reliable triggering of context-aware AI roles (FEAT-059)
```

---

## Notes

This feature emerged from the observation that FEAT-059 (context-aware AI roles) might not trigger reliably because the detailed guidance lives in `/framework/CLAUDE.md`, which is not automatically read at session start. The bootstrap block creates awareness without duplication.

---

## References

- FEAT-059: Context-Aware AI Roles
- Session discussion: 2026-01-17

---

**Last Updated:** 2026-01-17
