# Bug: New Move Engine Drops Batch Moves

**ID:** BUG-215
**Type:** Bug
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-01
**Workspace:** framework
**Completed:** 2026-09-21

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

---

## Merged in from BUG-225 (2026-09-12)

**Why merged:** BUG-225 was filed 2026-09-11 as a cosmetic output-layer card, correctly,
while this card was one verification step from done. The 2026-09-11 supersession then moved
the **prompt removal** onto BUG-225 (behaviour, not presentation), and this card's **UAT-34
and UAT-36 were rewritten** to the post-supersession design. That inverted the dependency:
this card could no longer pass its own UAT until BUG-225 shipped, and BUG-225 sat in
`backlog/` — so the engine change was unreachable under the Implementation Rule.

The two cards were never two bugs. They are **one engine change** (remove the prompt, fix
the report) plus **one verification**. Merging eliminates the cross-dependency by
construction. BUG-225 is archived as superseded; its design sections are carried here whole.

### Remove the prompt

**Decided 2026-09-11**, superseding this card's own 2026-09-07 design (see the SUPERSEDED
block above). The engine does not prompt. A `→ closed` with no `--resolution` is **refused
per record**, naming what is missing and the valid codes; `--resolution` applies to the
**whole batch**.

**What comes out:** the `read`/`/dev/tty` branch and the `[ -t 0 ]` guard — the latter wrong
independently of this decision: it tests **stdin** while the read is from **`/dev/tty`**, so a
piped invocation failed closed while a usable terminal was attached.

**Still present in the engine as of 2026-09-12** —
[fw-move.sh:137-138](../../../workspaces/framework/scripts/fw-move.sh#L137-L138) (rejects
`--resolution` on a list) and
[:174-184](../../../workspaces/framework/scripts/fw-move.sh#L174-L184) (the prompt branch).

**Why it pairs with the formatter:** with no interactive branch, every line the engine emits
is a report line — which makes a single shared formatter achievable rather than a formatter
plus an escape hatch. Same file, same commit.

### Fix the batch report

Two defects found during UAT-33 on 2026-09-11. The moves are correct; this is presentation.

1. **The bundle notice reads as belonging to the wrong record** — indented under the
   *previous* record's success line.
2. **The batch report is hard to scan**, and the failure reason is detached from its row.

Observed, batch of three with a bundle on the **second** record:

```
✅ INC-901-batch-item-one.md → open/
   bundle INC-902/ moved
✅ INC-902-batch-item-two.md → open/
✅ REQ-903-batch-item-three.md → open/
📊 moved: 3  skipped: 0  failed: 0
```

**The cause is presentational, not ordering** (a first diagnosis during the run said the
bundle was emitted one iteration early — it is not). In `move_one` the record moves, the
bundle notice prints, then the record's own `✅` prints
([:189-191](../../../workspaces/framework/scripts/fw-move.sh#L189-L191),
[:210](../../../workspaces/framework/scripts/fw-move.sh#L210)). So the line belongs to the
record *below* it and the indentation says the opposite.

**Compounding it:** `✅` goes to stdout while `fail_item` writes `❌` to stderr, so on a batch
with failures the reasons detach from their rows when the streams interleave.

**One formatting function in the engine, used by every namespace.** Agreed with Gary
2026-09-11: *"fw-move should behave the same for operations and kanban."* The report must be
produced by shared code so the kanban command inherits it by construction rather than
diverging.

Target shape:

```
Move from onhold → open
  OK       INC-901-batch-item-one.md
  OK       INC-902-batch-item-two.md  (bundle INC-902/)
  FAILED   REQ-903-batch-item-three.md — invalid transition closed → open
  📊 moved: 2  skipped: 0  failed: 1
```

Decisions settled 2026-09-11:

- **Status first, fixed-width, left-aligned.** The eye scans one column. Trailing status
  designators cannot align without padding every filename.
- **Bundle inline on its own record's row.** This *removes* the misattribution rather than
  re-ordering around it: the bundle can no longer be a free-floating line.
- **Failure reason on the row**, not a detached stderr line. The report is read closely only
  when something failed; that is when the reason must be adjacent.
- **Keep the summary line.** Offered for removal and kept: it survives scrollback, it is what
  a script greps, and it matches the old engine's report.
- **Single move keeps its own single-line output** — no header, no summary.

**Open:** whether `❌`/`✅` glyphs survive alongside OK/FAILED/SKIPPED, and whether failure
reasons stay on stderr (scriptable) while rows go to stdout.

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

**Struck 2026-09-21 — a second command for kanban is not this card's criterion.** It was
carried here as an unchecked box while the ownership question was open; **FEAT-229** now
lists it explicitly in its own Scope (items 3 and 4) and Acceptance Criteria. Recorded as
prose rather than ticked: a `[x]` would make out-of-scope work indistinguishable from
completed work and silently drop it from the done-gate, which is the failure the original
note warned against. Removing the box removes it from the gate honestly. Tracked by
**FEAT-229**.

**Merged in from BUG-225 (2026-09-12) — the engine change:**

*All ticks below are the **source-tree** run of 2026-09-13 against `framework-uat` via
`--root`, fixtures re-seeded first. They do **not** close the built-plugin criterion under
Verification, which is a separate check against the installed cache.*

- [x] The engine never prompts: `→ closed` with no `--resolution` is refused per record,
      naming the valid codes; `read`, `/dev/tty` and `[ -t 0 ]` are gone from the script
      *(UAT-36; verified by grep over comment-stripped source — the only `read` left is the
      `IFS=', ' read -ra` list parser)*
- [x] `--resolution` is accepted with a list and applied to the whole batch *(UAT-34 — both
      records stamped `Closed: 2026-09-13`, `Resolution: resolved`)*
- [x] A piped or headless invocation behaves identically to an interactive one *(UAT-36 vs
      UAT-36b — byte-identical output, both exit 1, nothing moved)*
- [x] A batch with a bundle on a non-first record attributes the bundle to the correct
      record, unambiguously — verified with the bundle on the **second** of three
      *(UAT-33 — `(bundle INC-902/)` inline on INC-902's row)*
- [x] Status appears first in a fixed-width column; rows align regardless of filename length
      *(`printf '  %-8s %s\n'`)*
- [x] A failed item's reason appears on that item's row *(UAT-35 — `FAILED   999 — no
      operations record with that id`, in order between the two `OK` rows)*
- [x] The `moved / skipped / failed` summary line is retained *(byte-identical to before;
      asserted verbatim by UAT-33/35, and the script now carries a comment saying so)*
- [x] Single-id moves are unchanged (no header, no summary) *(single move prints one row
      carrying its destination: `OK  INC-904-… → onhold/`)*
- [x] The report is emitted by one shared function, so a second namespace gets it without
      new code — verified by inspection at the call sites *(`row()`; every outcome path —
      OK, SKIPPED, FAILED via `fail_item` — goes through it)*
- [x] Validated: **AI** — re-run the source-tree cases and diff the output shape *(done;
      ten cases below)*; **Human** — UAT-33 and UAT-35 in `framework-uat` read correctly
      without the filesystem needing to be checked to interpret them *(**outstanding — your
      call at the built-plugin run**)*

**Source run 2026-09-13 — ten cases, all pass.** UAT-36 (tty), UAT-36b (piped), unknown
code, UAT-33, UAT-35, single move, already-in-target, terminal guard, UAT-34, stamp check.

**One BUG-225 open question decided during implementation:** *whether failure reasons stay
on stderr.* They do **not**. A stderr copy was implemented first, then removed — every
failure printed twice and the two streams interleaved on a terminal, which is the
detached-reason problem the card exists to fix. Reasons are on the rows, on stdout. `die`
still writes to stderr: a usage error (unknown namespace, bad target, unknown code) is about
the whole invocation, not a record outcome. `commands/fw-move-ops.md` updated to match.

**The other open question — whether `✅`/`❌` glyphs survive alongside OK/FAILED/SKIPPED —
decided by the tests:** the words replace the glyphs on rows, and the `📊` summary line is
kept byte-identical because UAT-33 and UAT-35 assert it verbatim.

**Verification:**

- [x] Verified against the built plugin, not the source tree (TECH-188) — **closed 2026-09-21.**
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

      **2026-09-21 — CLOSED. Verified against the installed cache**, in
      `~/.claude/plugins/cache/dev-marketplace/spearit-framework-dev/**0.4.7**/scripts/fw-move.sh`
      — note the **version directory**, which the 2026-09-10 note's path omits. The cached
      copy was first `diff`ed against the source and is **byte-identical**, so the source-tree
      grep of 2026-09-13 (no `read`/`/dev/tty`/`[ -t 0 ]` beyond the `IFS=', ' read -ra` list
      parser) carries to the artifact.

      Five cases run in `framework-uat` against freshly seeded fixtures, each with a
      **before/after snapshot** diffed against the report:

      - **UAT-33** *(via `/spearit-framework-dev:fw-move-ops`)* — 3 OK → `onhold/`;
        `(bundle INC-902/)` inline on INC-902's own row; `INC-9010` did not move (substring
        trap); `📊 moved: 3  skipped: 0  failed: 0`; exit 0.
      - **UAT-34** *(plugin command)* — batch `--resolution resolved`; both stamped
        `Closed: 2026-09-21` / `Resolution: resolved`, **inserted after `Opened:`** in the
        field block; the `INC-902/` bundle followed across a two-hop path
        (`open → onhold → closed`); `moved: 2`; exit 0.
        **Scope note: the close gate (step 1) was skipped by choice** — the 9xx fixtures have
        no **Outcome** section, so the gate has nowhere to write. Engine mechanics verified;
        the command's judgment step is **not** exercised by this run. See the fixture gap
        below.
      - **UAT-35** *(plugin command, unquoted list)* — `901 999 903 open`: OK / FAILED / OK
        with the failure row **in order between** the two OKs, reason on the row, on stdout;
        `moved: 2  skipped: 0  failed: 1`; exit 1; nothing created for `999`.
      - **UAT-36** *(plugin command)* — `→ closed` with no code refused **per record**, each
        row naming all five codes; `moved: 0  failed: 2`; exit 1; nothing moved. The refusal
        comes from the rule itself, **not** from a no-tty branch — which is the mechanism
        BUG-225 recorded as wrong even when the end state was right.
      - **UAT-36b** *(cached script directly — redirection cannot be applied through a slash
        command)* — tty vs `< /dev/null`, both `> file 2>&1`: **byte-identical, 352 bytes**,
        both exit 1, queue unchanged. This is the headless-safety criterion demonstrated
        rather than argued.

      **A first attempt at UAT-36b produced a false `BYTE-IDENTICAL`**: the plugin path was
      written from memory, omitted the version directory, and both files captured the same
      *bash* "No such file or directory" error. Recorded because the failure mode is general —
      **a `diff` of two failed runs passes**, so a byte-comparison test must also assert the
      content is the expected output, not merely that two captures match.

      **Not exercised by these cases** (none are this card's criteria): the close gate's
      Outcome step, the `closed`-is-terminal refusal, an invalid resolution code (which
      routes to **stderr** as a whole-invocation parse error, unlike a *missing* code's
      per-record row), and the sweep.
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
      - **UAT-36** — not run at that time; being rewritten.

      **2026-09-12 — the rewrite is done; the engine is what is missing.** UAT-34 and
      UAT-36 in `UAT-COMMANDS.md` were both rewritten on 2026-09-11 to the
      post-supersession design and now read correctly. They **fail against the current
      engine**, which still implements the superseded 2026-09-07 behaviour:

      - **UAT-34** expects `--resolution` to apply to a whole batch; the engine rejects it
        on a list ([:137-138](../../../workspaces/framework/scripts/fw-move.sh#L137-L138)).
      - **UAT-36** expects a per-record refusal naming the codes, identical with or without
        a tty; the engine still prompts
        ([:174-184](../../../workspaces/framework/scripts/fw-move.sh#L174-L184)).

      Confirmed by running UAT-36 on 2026-09-12: it refused with *"→ closed requires a
      resolution and no terminal is available to prompt"* — `moved: 0  failed: 2`, nothing
      half-applied, both records left in `open/`. **Right end state, wrong mechanism:** that
      is the no-tty arm of the prompt branch, not the refusal UAT-36 specifies. With a
      terminal attached the same command prompts instead. **Not a PASS.**

      The built-plugin run still needs, in order: land the merged engine change above;
      `/plugin install spearit-framework-dev@dev-marketplace --scope local`; restart;
      `--reset` and re-seed; then UAT-33..36 as one set. **Install last** — the publish
      script's clean step strips `*@dev-marketplace` from `installed_plugins.json`, so
      re-running it after installing returns the cache to empty.

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

- **BUG-225** — ~~the batch output layer, filed separately~~ **merged into this card
  2026-09-12 and archived as superseded.** Its design sections are carried above verbatim
  ("Merged in from BUG-225"), its acceptance criteria into the list above. Do not work it.
- **FEAT-226** — the durable-knowledge hand-off, enforced nowhere. The reason the
  `Resolution:` code is allowed to stay cheap.
- **TASK-213** — surfaced during that discussion; independent of the root move.
- **ADR-009 D5** — the crossover that makes the new engine the only engine; this gap
  must close before then, or the board loses batch moves at graduation.
