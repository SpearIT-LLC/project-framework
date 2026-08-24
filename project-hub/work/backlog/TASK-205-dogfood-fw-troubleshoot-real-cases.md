# Task: Dogfood fw-troubleshoot on Three Real Cases, Then Retro

**ID:** TASK-205
**Type:** Task
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-08-24
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The fw-troubleshoot skill (FEAT-202) was designed and tested with fixtures.
The first three **real** incidents will rewrite it more than any amount of
design — that is the actual sharpening plan (agreed 2026-08-24). Run the next
three real problems (Toyota / Honda / SpearIT-internal, whichever arrive)
end-to-end through the skill, in their own repos' kbs, then hold one short
retro here.

## Method

Per case, capture on the case itself (fields already exist):
- **Resolved at rung** — where the ladder actually ended.
- What the skill made you do that was wasted; what it should have asked
  earlier; where the remote-mode evidence flow hurt.

Retro (one session, after case three): patterns across the three → concrete
edits to the skill, the case template, and the first playbook (FEAT-203).
Rung-7 clustering in a domain is the signal that its playbook/reference is
the missing piece.

## Acceptance Criteria

- [ ] Three real cases run through the skill, each with `Resolved at rung`
      filled and retro notes captured
- [ ] Retro held; resulting skill/template edits landed (or filed as cards)
- [ ] First real playbook content identified for FEAT-203

## Related

- **FEAT-202** — the skill under test.
- **FEAT-203 / FEAT-204** — playbooks and collectors; the retro feeds both.
- **FEAT-201** — HPC repo `kb/3dx` is a likely first real domain.
