# Bug: New Move Engine Drops Batch Moves

**ID:** BUG-215
**Type:** Bug
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The ADR-009 build's `fw-move.sh` accepts exactly one id per invocation. The old engine
accepts a list — `fw-move 001,002,003 todo` — so moving several records now costs one
command each.

Found 2026-09-01 while discussing the operations/kanban convergence (TASK-213). Gary:
"before we used to be able to move multiple cards in one pass using `fw-move
001,002,003 todo`. Now we have to add the prefix which makes the command longer to
enter."

**Note on the prefix half of that report:** bare numerics already work in the new
engine — `case "$PREFIX" in ""|INC|REQ) NS="operations"` maps an empty prefix to
operations, so `fw-move.sh 12 closed` is valid today. What was actually lost is the
**batch**, not the bare form. Recorded because the two are easy to conflate.

## Evidence

New engine (`workspaces/framework/scripts/fw-move.sh`):

```bash
[ ${#ARGS[@]} -eq 2 ] || { echo "Usage: fw-move.sh <id> <open|onhold|closed> ..." >&2; exit 1; }
```

Old engine (`.claude/scripts/fw-move.sh`), which documents and implements the list:

```bash
#   bash .claude/scripts/fw-move.sh "FEAT-145, FEAT-146" todo
IFS=', ' read -ra TOKENS <<< "$RAW_LIST"
```

The old `/fw-move` command doc advertises `/fw-move "FEAT-042, 043" todo` and batch
examples; the new engine's does not.

## Reproduction

1. In a repo with an operations workspace holding open records 1, 2, 3.
2. `bash fw-move.sh "1, 2, 3" closed --resolution resolved`
3. Observe: usage error, exit 1. Each record must be moved by its own invocation.

**Reproducibility:** Always.

## Fix Design

Split the id argument on commas/spaces and loop, as the old engine does. Points to settle
at implementation:

- **Per-item outcome reporting.** The old engine reports moved / skipped / failed counts;
  the new one is single-shot. A batch needs the same summary.
- **Partial failure.** If item 2 of 3 fails its transition check, do items 1 and 3 still
  move? The old engine continues and reports; that is the precedent, and it matches
  `git mv` semantics per item. **Decided 2026-09-07: validate per item inside the loop,
  continue on failure, report at the end.** A batch may therefore partially apply — which
  is the old engine's behaviour and what the per-item summary exists to make visible.
- **~~`--resolution` applies to the whole batch.~~ Decided 2026-09-07: per record.**
  Gary: *"I think each card gets its own resolution."* The reasoning is that
  `Resolution:` is a per-record classification and the close gate is **already
  per-record** — it asks for the code *and a one-line reason*, plus the
  durable-knowledge question for incidents, and that answer lands in each record's own
  **Outcome** section. One shared code paired with N individually-written outcomes is
  incoherent.

  **Mechanism: prompt per card.** A batch `→ closed` asks for each record's code in
  turn. Rejected: per-id inline syntax (`"1:duplicate, 2:resolved"`) — invents a grammar
  to make a judgment step look mechanical; and refusing batch `→ closed` outright —
  unnecessary once prompting works.

  **`--resolution` on a batch:** with more than one id, the flag cannot express the
  decision. Reject it rather than silently applying one code to all.
  Single-id invocations keep the flag exactly as today (scriptable, no prompt).

  > ### ⚠️ SUPERSEDED 2026-09-11 — the whole per-record decision above
  >
  > **The engine does not prompt. `--resolution` applies to the whole batch.**
  >
  > The 2026-09-07 text above is kept because it is the record of why per-record
  > prompting looked right, and the new decision only makes sense against it. **It is
  > not the design. Do not implement it.**
  >
  > **Two decisions, in order:**
  >
  > **1. Prompting comes out of the engine entirely.** Gary: *"In the kanban cards, we
  > simply reject the move if it's missing the proper criteria. I see no reason not to
  > do the same thing for operations."* A `→ closed` move with no `--resolution` is
  > refused, per record, with stdout naming what is missing and the valid codes. The
  > human resolves and runs again — the kanban experience, and the only one the old
  > engine has ever offered (it never prompts: every `read` in it is string parsing).
  >
  > Removes `read`, `/dev/tty`, and `[ -t 0 ]`. Which also disposes of a guard bug found
  > the same day: `[ -t 0 ]` tests **stdin** while the read was from **`/dev/tty`**, so
  > `echo x | fw-move.sh … closed` failed closed while a usable terminal was attached.
  > The engine becomes fully mechanical and headless-safe — what FEAT-221 needs anyway.
  >
  > **2. `--resolution` applies to the whole batch.** Gary: *"adding multiple resolutions
  > to the same operation is not likely to be needed. […] If I had a batch of INC about
  > the same root issue, then they would all close with the same resolution."*
  >
  > **This inverts the 2026-09-07 conclusion on its own evidence.** That decision assumed
  > a batch close meant *different records with different outcomes*, which is what made a
  > shared code incoherent. The realistic case is the opposite: **a batch close happens
  > precisely because the records share a root cause**, and sharing a cause means sharing
  > a classification. Records that genuinely differ get closed separately — you would have
  > to open them separately to remember what each was about.
  >
  > **What stays per-record:** the one-line reason and the durable-knowledge answer, each
  > in its own record's **Outcome** section. The code is shared; the story is not.
  >
  > **And the code is cheap by design** (settled the same day): `Resolution:` is a filter
  > for counting and excluding noise, not knowledge. The diagnosis — the thing worth
  > having — belongs in the kb, linked from Outcome. That hand-off is enforced nowhere
  > today: **FEAT-226**.
  >
  > **Fallout to land with this change:**
  > - `fw-move.sh` — remove the prompt branch; refuse `→ closed` without a code, per record
  > - `commands/fw-move-ops.md` — the close gate still asks its questions (it is an AI-side
  >   judgment step); it then passes one `--resolution` for the batch
  > - **UAT-36** — currently specifies per-record prompting. Rewrite to "refuses per record
  >   without a code"
  > - The T6 / N6-N10 no-tty cases become moot — there is no prompt to fail
  >
  > Full reasoning: `project-hub/history/sessions/2026-09-11-SESSION-HISTORY.md`,
  > decisions 15-18.
- **`sweep` is unaffected** — it already operates on a set.

## Acceptance Criteria

- [x] `fw-move.sh "1, 2, 3" onhold` moves all three *(T1)*
- [x] ~~`fw-move.sh "1, 2, 3" closed` prompts for each record's resolution in turn~~
      *(T11b — two records, two different codes stamped)* — **superseded 2026-09-11:
      no prompting. Replaced by:** a batch `→ closed` with no `--resolution` is refused
      per record, naming the valid codes
- [x] ~~`--resolution` with a multi-id list is rejected with a clear message~~ *(T3)* —
      **superseded 2026-09-11: `--resolution` now applies to the whole batch.** T3
      verified the opposite behaviour and is retired with it
- [x] `fw-move.sh 1 closed --resolution duplicate` still works unprompted (single id) *(T5)*
- [x] Comma-separated, space-separated, and mixed forms all parse; quoted and unquoted
      *(T1 quoted commas, T4 unquoted spaces)*
- [x] Full ids, bare numerics, and mixed lists all work *(T9 confirms prefix routing;
      bare numerics throughout)*
- [x] Per-item summary reported (moved / skipped / failed), matching the old engine *(T1, T4, T7)*
- [x] A failing item does not prevent the others from moving *(T4 — 1 ok, 99 missing, 3 ok)*
- [x] Command doc shows the batch form

**The namespace half (rescoped 2026-09-07) — not yet started:**

- [x] **The namespace is an argument, never inferred** — `/fw-move` renamed
      `/fw-move-ops`, which always passes `operations` *(N1–N4)*
- [x] Bare numerics work, unambiguously, because the namespace came from the command
      *(N1, N5)*
- [x] One script invoked as `fw-move.sh <namespace> <ids> <target>`, policy table at the
      top; the `""|INC|REQ) NS="operations"` guess is gone *(no `OPS_` refs remain)*
- [x] ADR-009's "table entry, not a second engine" note is **confirmed** — the kanban row
      is declared with its authored folder set and refuses clearly until wired *(N4, N12)*
- [ ] **A second command exists for kanban.** Deferred deliberately: the kanban policy
      (transitions, dependency gate, acceptance gate) is not ported, and the live board
      is `project-hub/work/` under the root `/fw-move` until the D5 crossover. Owned by
      the crossover work, not this card — see Related

**Verification:**

- [ ] Verified against the built plugin, not the source tree (TECH-188) — **outstanding.**
      Tested at source via `--root` against a scratch git fixture (12 cases, below).
      The built-plugin cycle needs a publish step that was not available in the remote
      session of 2026-09-07. Left as `[ ]` rather than `[/]` deliberately: the done-gate
      counts only `[ ]` today, so `[ ]` is both true and enforced. TECH-177 makes `[/]`
      blocking, but that is its work, not this card's.

      **2026-09-10 — published, still unverified.** Bumped to `0.4.7` and ran
      `tools/Publish-ToLocalMarketplace.ps1` (needs **`pwsh`**; PowerShell 5.1 refuses it).
      This did **not** close the criterion, for a structural reason worth knowing:
      **the dev-marketplace entries are symlinks to the source tree**
      (`framework -> workspaces/framework`), so testing "against the marketplace" is
      testing the same files. The built-artifact check means the **installed cache**
      (`~/.claude/plugins/cache/`), a real copy exercised via `${CLAUDE_PLUGIN_ROOT}`.
      Verified after a plugin refresh: cache empty, no `installed_plugins.json` entry —
      the publish script's clean step removes it, and a marketplace *update* does not
      reinstall.

      **To close:** `/plugin install spearit-framework-dev@dev-marketplace --scope local`,
      restart, then re-run the cases that exercise the fix.

      **2026-09-11 — the runbook cases now exist, and the set has changed.** The four
      cases were written into `workspaces/framework/tests/UAT-COMMANDS.md` as section
      **D2 (UAT-33..36)**, against 900-block fixtures seeded by
      `workspaces/framework/tests/seed-uat-fixtures.sh --root <repo> operations`.

      Run at source 2026-09-11 (**does not close this criterion** — the dev-marketplace
      entry is a symlink to the source tree):
      - **UAT-33** PASS — 3 moved, bundle travelled, substring trap cleared (`901` moved
        INC-901, left INC-9010)
      - **UAT-34** PASS — refused pre-flight, nothing half-applied
      - **UAT-35** PASS *(caveat: start state drifted — ran as skip+skip+fail rather than
        the documented partial-failure path)*
      - **UAT-36** — **not run; being rewritten.** It specifies per-record prompting,
        which the supersession above removes.

      The built-plugin run still needs: install to the cache, restart, `--reset` and
      re-seed, then UAT-33..36 as one set.

---

## Test Evidence (2026-09-07, source tree via `--root`)

Scratch git fixture: four INC records in `open/`, one carrying an artifact bundle.

| # | Case | Result |
|---|---|---|
| T1 | Batch `"1, 2, 3" onhold`, quoted commas | 3 moved; bundle `INC-002/` moved with its record |
| T2 | Single id still works | moved, no summary line (single move prints its own) |
| T3 | `--resolution` on a batch | refused, exit 1 |
| T4 | Partial failure `1 99 3` unquoted | 1 and 3 moved, 99 reported, exit 1 |
| T5 | Single `closed --resolution resolved` | stamped `Closed:` + `Resolution:` |
| T6 | Batch `→ closed` with no tty | both items failed cleanly — **no hang**, exit 1 |
| T7 | Already in target | skipped (not failed), exit 0 |
| T8 | `closed` is terminal | refused |
| T9 | Kanban prefix `BUG-215` | refused with the crossover pointer |
| T10 | Unknown resolution code | refused |
| T11b | Interactive prompt, two records | `duplicate` and `cancelled` stamped per record |
| T12 | `sweep` regression | prior-year record bucketed to `closed/2025/` |

**Namespace half, 2026-09-08** (fixture with both `operations/` and `kanban/`):

| # | Case | Result |
|---|---|---|
| N1 | Batch with explicit namespace | 3 moved, bundle carried |
| N2 | Namespace omitted | refused — the id list is read as a namespace and rejected |
| N3 | Unknown namespace | refused, lists known namespaces |
| N4 | `kanban` declared but not wired | refused with the crossover pointer — **no half-move** |
| N5 | Partial failure, unquoted list | 1 and 3 moved, 99 reported, exit 1 |
| N6–N10 | Single close, batch `--resolution` refusal, no-tty close, terminal guard, already-in-target | all unchanged from T5–T8 |
| N11 | `sweep` with namespace | bucketed to `closed/2025/` |
| N12 | `sweep` for kanban | refused |
| N13 | Per-record prompting | two records, two different codes stamped |

**T6 is the one worth keeping in mind:** a non-interactive batch close fails rather than
hanging on a `read` that can never return. That is the headless case FEAT-221 cares about.

## Related

- **BUG-225** — the batch output layer (bundle line misattributed, report format). Found by
  this card's UAT; filed separately so this card stays closeable. **Carries the prompt
  removal from the 2026-09-11 supersession.**
- **FEAT-226** — the durable-knowledge hand-off, enforced nowhere. The reason the
  `Resolution:` code is allowed to stay cheap.
- **TASK-213** — surfaced during that discussion; independent of the root move.
- **ADR-009 D5** — the crossover that makes the new engine the only engine; this gap
  must close before then, or the board loses batch moves at graduation.
