# Feature: /fw-new — Deterministic Work-Item Create Command with Type Gate

**ID:** FEAT-175
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-08
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Framework Consistency

---

## Summary

Introduce a `fw-new` create command whose **deterministic core** assigns the ID and **enforces the
accepted work-item type** by reading the single source of truth
(`.claude/scripts/work-item-types.txt`, ADR-006), rejecting non-`accepted` types with an actionable
message — the true implementation of ADR-006 **D6** (deterministic enforcement at the create gate).
The rest of item creation stays AI-collaborative (discovery, scoping, writing). This closes the gap
TECH-173 deliberately left open once we established that **type enforcement belongs at creation, not
at move**.

---

## Problem Statement

**What is the current state?** (verified 2026-07-08)

- TECH-173 shipped the type SoT, build-derivation into the full-framework archive, and DRY'd every
  human-facing type list — but **no deterministic gate reads it at creation.**
- The **full framework has no create command at all** (ADR-006 D7 called this "an acknowledged
  oversight"). The only create path is the **plugin `new.md`**, which is AI-driven prose — i.e.
  *probabilistic* enforcement ("the AI reads the list and usually complies").
- ADR-006's settled philosophy (D6, and the project's repeated lesson) is that **where a silent lapse
  is costly, enforcement must be deterministic** — not AI-discretion.

**Why is this a problem?**

- Nothing mechanically stops an off-list type at creation. The SoT exists and is *available*, but no
  code path *gates* on it. The guarantee ADR-006 wanted is not yet realized.
- Type drift can re-enter through the one place it matters most: item birth.

**What is the desired state?**

- A `fw-new` engine (candidate: `.claude/scripts/fw-new.sh`, beside `fw-move.sh`) that:
  1. Reads the SoT and **rejects a non-`accepted` type** with a helpful message listing the
     canonical set (and noting legacy prefixes are recognized-but-not-creatable).
  2. Assigns the next ID deterministically (shares the ID logic already proven in
     `Get-NextWorkItemId` / the plugin `new.md` scan).
  3. Hands off to the AI layer for discovery/scoping/writing (unchanged).
  4. **Commits the new item** once it is fully drafted and settled — a new work item should be a
     durable, tracked artifact from birth, not an uncommitted working-tree file that can be lost.
- The plugin `new.md` flow re-points to (or invokes) this gate rather than restating the list.

---

## Scope

**In scope:**
- The deterministic `fw-new` create engine + type gate reading the SoT.
- Wiring the create command for the **full framework** (closes the D7 "no create command" gap).
- Re-pointing the plugin `new.md` create flow at the deterministic gate.
- **Ship the SoT into the plugin editions** via `Build-Plugin.ps1` derivation (deferred from
  TECH-173 precisely because the plugin had no *consumer* of the SoT until this item introduces one).

**Out of scope:**
- The type taxonomy itself (owned by ADR-006 / TECH-173 — this item consumes it).
- Full create-parity polish across every channel beyond the type gate + ID assignment.

---

## Acceptance Criteria

- [ ] A deterministic create gate reads `.claude/scripts/work-item-types.txt` and **rejects**
      non-`accepted` types with an actionable message
- [ ] Legacy prefixes are **not** offered for creation (but remain recognized elsewhere)
- [ ] Next-ID assignment is deterministic and collision-free (shares existing ID logic)
- [ ] Full framework gains a working create path (closes ADR-006 D7 oversight)
- [ ] Plugin `new.md` re-points at / invokes the gate rather than restating the type list
- [ ] `Build-Plugin.ps1` derives the SoT into each plugin edition (now that a consumer exists)
- [ ] **New item is committed once fully drafted** — the create flow prompts to commit (default-yes)
      after the item is written and settled. (Starting with a prompt per 2026-07-08 discussion;
      may tighten to silent auto-commit later if the prompt becomes annoying. Today's plugin
      `new.md` already prompts at Step 8 — carry that behavior into the deterministic flow.)
- [ ] CHANGELOG.md updated

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED** — AI presents the engine design, gate behavior, ID
      strategy, and plugin/build wiring; user approves
- [ ] Build the `fw-new` engine + deterministic type gate (reads SoT)
- [ ] Wire next-ID assignment (reuse existing logic)
- [ ] Full-framework create command wired
- [ ] Plugin `new.md` re-pointed at the gate
- [ ] Commit-on-create (prompt, default-yes) wired into the create flow
- [ ] `Build-Plugin.ps1` SoT derivation added
- [ ] CHANGELOG.md updated

---

## Related

- **ADR-006** (Accepted 2026-07-07) — **D6** (deterministic enforcement at the mechanical gate) and
  **D7** (`/fw-new` named as separate future work). This item implements D6's create gate.
- **TECH-173** — shipped the SoT, build-derivation (full framework), and DRY. Established that type
  enforcement belongs at **creation, not move**, and deliberately left this gate to this item.
- **BUG-170 / FEAT-145** — the "put the engine where it actually runs, and ship it" lesson.
