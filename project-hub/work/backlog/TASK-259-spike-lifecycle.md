# Task: The Spike Lifecycle — POC Home, Results, and Release Filing

**ID:** TASK-259
**Type:** Task
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-29
**Workspace:** framework
**Depends On:**
**Completed:**

---

## Summary

Gary and Claude settled how a spike's parts move through its life during BUG-258's
pre-implementation review (2026-09-29). BUG-258 carried out decision 6, which was the
engine change. This card carries out decisions 1–5, which are conventions, template text
and a release rule.

## Decisions (Gary, 2026-09-29)

1. **POC code for a workspace spike lives in `workspaces/<ws>/poc/<SPIKE-id>/`**, and the
   spike card links to it. The product scaffold already creates `poc/`, but nothing says what
   it is for. For a spike with no workspace, the code goes in the card's bundle folder.
2. **Results go where the issue belongs.** If the spike was specific to a workspace, its
   results and lessons learned stay in that `<ws>`. General knowledge goes to
   `kb/<domain>/research/`. The card's answer section links to wherever the results went.
3. **The card is ordinary.** It ends in `done/` or `cancelled/`, then leaves `done/` with the
   next release after it finishes. The release sweep files it under
   **`release/<ws>/spikes/`**, not a version folder. It does not wait for the feature it
   informed to ship: if the answer is "don't build it", no feature ever ships and the spike
   would sit in `done/` forever.
4. **Spike and feature are joined by links, not timing.** The spike's `Related:` names the
   feature it informs, and the feature's `Related:` names the spike.
5. **Spikes are never in release notes.** A spike ships nothing. They appear in activity and
   progress reports (FEAT-163). Filing them under `spikes/` means the folder keeps them out of
   the notes, with no filter needed.
6. *(Done in BUG-258)* **No record leaves its namespace root.** The `history/spikes/` redirect
   is gone.

**Rejected:**
- **Filing a spike in the version folder, with "Investigated" in the notes.** The notes say
  what shipped; a spike ships nothing.
- **Holding the spike until its feature releases.** It needs a special rule in the sweep, and
  it can never finish if the answer is "no".

## Acceptance Criteria

- [ ] Product workspace README documents `poc/`: one folder per spike, `<SPIKE-id>/`, linked from the card; the code graduates to `src/` by `git mv` or stays as the record, never deleted
- [ ] The work-item template (or TECH-228's spike template, if it lands first) carries a POC-location line and an answer/results line with links
- [ ] kb domain README ([_domain_/README.md:22-24](../../../workspaces/framework/templates/workspaces/knowledgebase/_domain_/README.md)) no longer points at "the project hub's research area", which the new build doesn't have. It says where the investigation record lives: the spike card, its bundle, and the workspace `poc/`
- [x] The release-filing rule (decision 3) and the notes rule (decision 5) are written onto FEAT-028's card as requirements *(2026-09-29)*
- [x] The activity-report rule (decision 5) is written onto FEAT-163's card *(2026-09-29)*
- [ ] Decision 4's two-way link is stated in `/fw-new`'s guidance for a SPIKE
- [ ] Plugin CHANGELOG updated

## Related

- **BUG-258**: decision 6; where these decisions were made
- **TECH-228**: the spike template; its "Spikes archive to `history/spikes/`" carry-in is superseded
- **FEAT-028**: the release command; carries decisions 3 and 5
- **FEAT-163**: workspace reporting; carries decision 5's activity side
