# Session History: 2026-09-12

**Date:** 2026-09-12
**Participants:** Gary Elliott, Claude Code
**Session Focus:** dev-marketplace verification; BUG-215/BUG-225 merge

---

## Summary

Started as a marketplace refresh check and became a drift audit. Verified the dev-marketplace
is serving framework-dev 0.4.7 correctly, then found three stale artifacts along the way — a
fossil manifest, a stale dev guide, and (the substantive one) a 2026-09-11 design decision
that had been propagated to some artifacts but not others. Merged BUG-225 into BUG-215 to
eliminate the cross-dependency that drift had created. No engine code was changed.

---

## Work Completed

### Marketplace verification (no card)

- Confirmed dev-marketplace registered as a `directory` source at
  `Projects\claude-local-marketplace`, updated 00:57:45Z, serving `spearit-framework-dev`
  **v0.4.7** — matching `workspaces/framework/.claude-plugin/plugin.json`.
- Confirmed live in-session via `/plugin` + `/reload-plugins` (9 plugins, 22 skills, 7 agents).
- **The marketplace is a symlink farm, not a copy** (`framework -> workspaces/framework`), so
  file edits are live and no build step exists or is needed for framework-dev.

### BUG-215 / BUG-225 merge

- Read `Publish-ToLocalMarketplace.ps1` end to end; established it generates the marketplace
  manifest from each plugin's own `plugin.json` and never reads the repo-level one.
- Traced UAT-36's failure to the engine, not the test.
- Merged BUG-225 into BUG-215 (design sections verbatim, 10 acceptance criteria), superseded
  BUG-225 in place, corrected BUG-215's stale verification notes.

### DOC-234 created

- Note to fix `framework/docs/plugin-development-guide.md`, with four verified defects.

---

## Decisions Made

1. **UAT-36's 2026-09-12 run is a FAIL, not a PASS.**
   - The run refused with `→ closed requires a resolution and no terminal is available to
     prompt`, `moved: 0  failed: 2`, nothing half-applied. The draft note called it a PASS.
   - **Right end state, wrong mechanism.** That message is the no-tty arm of the prompt branch
     (`fw-move.sh:174-184`), not the per-record refusal UAT-36 specifies. With a terminal
     attached, the same command prompts instead. The test asserts behaviour identical with and
     without a tty; the engine cannot currently deliver that.

2. **BUG-225 merged into BUG-215; not the reverse.**
   - BUG-215 was already in `doing/`, so folding backlog content into it needs no transition
     and no ripeness review. The reverse would have promoted a backlog card through the gate
     and abandoned BUG-215's accumulated test evidence.
   - **This also unblocked the work under the Implementation Rule:** the engine change had been
     stranded on a `backlog/` card, so `fw-move.sh` could not legitimately be edited at all.

3. **The two cards were never two bugs.**
   - One engine change (remove the prompt, fix the report) plus one verification, same file,
     same commit. BUG-225's own "Also in scope" section already argued for one commit.
   - The 2026-09-11 split was *correct when made* — BUG-215 was one step from done and BUG-225
     was cosmetic. It inverted when the supersession moved behaviour onto BUG-225 and BUG-215's
     UAT-34/36 were rewritten to the new design. **Nothing re-evaluates a split when its
     premise changes.**

4. **BUG-225 Version Impact PATCH → MINOR.**
   - It absorbed the prompt removal, which changes what `--resolution` accepts and what
     `→ closed` does. That is behaviour, not presentation.

5. **The kanban criterion stays `[ ]`, and still blocks BUG-215.**
   - Initially marked `[x]` as out-of-scope. **Reverted — that was wrong.** The card's own
     convention is that `[ ]` is deliberate because the done-gate counts only `[ ]`; checking
     off an out-of-scope item makes it indistinguishable from completed work and silently drops
     it from the gate. Exactly the problem TECH-230 exists to fix.
   - **Open at the done-gate:** strike it entirely (it is FEAT-229's criterion) or accept that
     BUG-215 waits on the D5 crossover. Recommendation recorded on the card: strike it.

6. **Diagnosis of the "cascade" — an unpropagated decision, not coupled work.**
   - Gary: *"One change cascading into multiple others."* The 2026-09-11 supersession existed in
     five places: the engine (old design), UAT-34/36 (new design), BUG-225 (absorbed the
     behaviour), BUG-215's notes (described the rewrite as pending when it was done).
   - Nothing edited tonight *caused* another edit. Every edit was catching up to a day-old
     decision. **The fix for drift is fewer copies or a failing check — not more splitting.**
     Splitting made it worse: BUG-225 existed to keep the cards independent and became the
     cross-dependency.
   - Three instances of one pattern in one evening: the 0.4.3 manifest, the dev guide, and this.
     The Single-Source Rule covers content; **decisions have no equivalent mechanism.**
     TECH-189 is the closest fix and sits in `backlog/`.

---

## Findings Not Yet Actioned

- **`.claude-plugin/marketplace.json` (repo root) is a fossil**, stale at 0.4.3 vs 0.4.7.
  Verified to have no reader and no writer: the publish script targets the *external* path, and
  a repo-wide grep for `marketplace.json` returns no other match. Deletion recommended; the one
  thing grep cannot rule out is whether it serves as a fallback if someone adds *this repo*
  directly as a marketplace source.
- **`framework/docs/plugin-development-guide.md`** — four defects, see DOC-234.
- **MEMORY.md** shows `.\tools\Publish-ToLocalMarketplace.ps1 -Build`; the script takes no
  parameters (`param()`, line 35). `-Build` is from an older revision.
- **Stale `installed_plugins.json` entries** for `spearit-framework-dev@dev-marketplace` point
  at a cache path the junction model never populates, duplicated by a `c:\`/`C:\` case
  difference. Cosmetic — loading does not consult that path. The publish script's clean step
  removes them.

---

## Files Modified

- `project-hub/work/doing/BUG-215-new-move-engine-drops-batch-moves.md` — merged in BUG-225's
  design sections and 10 acceptance criteria; corrected the stale "UAT-36 not run; being
  rewritten" note; recorded the 2026-09-12 UAT-36 run as a FAIL with its mechanism; restated
  the kanban criterion's ownership; updated Related.
- `project-hub/work/backlog/BUG-225-move-engine-batch-output-misattributes-bundles.md` —
  SUPERSEDED header pointing at BUG-215; Version Impact PATCH → MINOR; struck the expired
  "filed separately" premise with an explanation of how the dependency inverted. Body kept as
  the record of the split.

## Files Created

- `project-hub/work/backlog/DOC-234-plugin-dev-guide-stale-for-framework-dev.md` — doc fix note.
- `project-hub/history/sessions/2026-09-12-SESSION-HISTORY.md` — this file.

## Files Moved

- None. BUG-225 remains in `backlog/` pending `git mv` to `archive/` — deliberately left to the
  gate rather than moved directly.

---

## Current State

### In doing/
- **BUG-215** — now carries the whole engine change. 12 unchecked criteria: 10 merged engine
  criteria, the built-plugin verification, the kanban criterion. **Unblocked: the engine change
  is now on a card in `doing/`, so `fw-move.sh` may legitimately be edited.**
- **TECH-232** — untouched this session.

### In backlog/
- **BUG-225** — superseded, awaiting `git mv` to `archive/`.
- **DOC-234** — new.
- **TECH-189** (drift guard) — named tonight as the systemic fix for decision drift.

---

## Next Session

1. Make the engine change on BUG-215: remove the prompt branch (`read`, `/dev/tty`, `[ -t 0 ]`),
   accept `--resolution` on a list, and land the shared report formatter — one commit.
2. Then the built-plugin verification, **in this order**: publish → `/plugin install
   spearit-framework-dev@dev-marketplace --scope local` → restart → `--reset` and re-seed →
   UAT-33..36 as one set. **Install last** — the publish script's clean step strips
   `*@dev-marketplace` from `installed_plugins.json`, returning the cache to empty.
3. Settle the kanban criterion at the done-gate.
4. `git mv` BUG-225 to `archive/`.

---

**Last Updated:** 2026-09-12
