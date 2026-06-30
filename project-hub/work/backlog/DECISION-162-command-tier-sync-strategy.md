# Decision: Command-Tier Sync Strategy (fw-* vs. plugin command drift)

**ID:** DECISION-162
**Type:** Decision
**Priority:** Medium
**Version Impact:** None
**Created:** 2026-06-30
**Theme:** Workflow Commands / Distribution

---

## Summary

The framework's `/fw-*` commands have drifted substantially from the plugin command sets that mirror them (e.g. `move` differs by 427 lines, `swarm` 697, `roadmap` 436). Decide whether/how to keep the commands the tiers **share** in sync — and whether they should pull from a single source — without erasing the intentional difference in tier *scope*.

---

## Context

**What triggered this decision?**

While scoping TECH-161 (a session-history command fix), we discovered the `session-history` command exists in three forms that are NOT identical: `.claude/commands/fw-session-history.md` (inline template), `plugins/spearit-framework/commands/session-history.md` (external template file), plus the plugin's `templates/session-history-template.md`. A full inventory followed.

**The tiers are intentional** (maintainer, 2026-06-30):
- `.claude/commands/fw-*` — full framework (11 commands, superset)
- `plugins/spearit-framework` — advanced plugin (8 commands, most functionality)
- `plugins/spearit-framework-light` — basic / mostly Kanban (3 commands)

Different command **counts** are by design. The problem is **behavioral drift in the commands they share**. Hard numbers in the inventory: [`project-hub/research/command-tier-drift-inventory.md`](../../research/command-tier-drift-inventory.md).

Key facts from the inventory:
- **The two plugins are in sync with each other** (`move`, `new` = 0 differing lines full↔light).
- **`fw-*` is ahead and has diverged** from the plugins: `swarm` 697, `roadmap` 436, `move` 427, `backlog` 207 differing lines (namespace-normalized). The `fw-*` commands gained functionality (e.g. `fw-move`'s `--force`/batch/`blocked`/`move.sh`) the plugins never received — so the "advanced plugin" runs older logic than the framework.

**What are the constraints?**

- Tiers must remain *different in scope* (the plugins intentionally offer fewer commands; light is deliberately minimal).
- Plugin commands use a namespaced invocation (`/spearit-framework:*`) — any shared-source approach must preserve that.
- Plugins have their own packaging/build (`tools/Build-Plugin.ps1`) and marketplace constraints.
- Some structural differences may be intentional (e.g. plugin uses an external template file vs. `fw-*` inline) — must distinguish intentional from accidental.

---

## Options Considered

### Option A: Accept the drift; sync manually, case by case

**Description:** Keep three independently-maintained sets. When a shared command changes in `fw-*`, manually port the relevant bits to the plugin(s).

**Pros:**
- No new tooling; maximum per-tier flexibility
- Tiers can diverge intentionally where desired

**Cons:**
- Drift recurs (this is how we got here); "I THINK we updated some" is unverifiable
- The advanced plugin silently ships older behavior than the framework

### Option B: Bring plugins up to fw-* parity once, then maintain manually

**Description:** One-time effort to re-sync the shared commands (move, swarm, roadmap, backlog, session-history, help) to current `fw-*` behavior (adapting namespace + tier scope), then keep syncing by hand.

**Pros:**
- Closes the current gap; users get current behavior
- No architectural change

**Cons:**
- Re-drifts over time without a guard (same failure mode returns)
- Sizable one-time effort

### Option C: Single source + per-tier generation

**Description:** Maintain shared command *content* in one canonical place (`.claude/commands/` as source of truth) and have the plugin builds **generate** the plugin commands from it — applying namespace substitution and a per-tier include/exclude list (light = subset, full = larger subset). Mirrors the TECH-159 "build copies canonical fresh" pattern, extended to plugins.

**Pros:**
- Eliminates drift structurally (one source); tiers differ only by an explicit manifest
- Consistent with the direction TECH-159 set for the starter
- Intentional per-tier differences are encoded as data (the include list), not divergent copies

**Cons:**
- Requires build work in `Build-Plugin.ps1` (namespace rewrite, manifest, any intentional template-location differences)
- Some commands genuinely differ between tiers (not just subset) — needs a way to express intentional per-tier overrides

### Option D: Accept tiers as fully independent products (no sync intended)

**Description:** Declare the plugins separate products that deliberately may lag/differ; document that `fw-*` is the leading edge and plugins follow their own roadmap.

**Pros:**
- No sync burden; honest about current reality
- Plugins evolve on their own cadence

**Cons:**
- Users reasonably expect "the same command" to behave the same; silent behavioral differences are surprising
- Abandons the value of a shared framework definition

---

## Decision

**Chosen Option:** _TBD — to be decided when this item is worked._

**Rationale:** _TBD_

**Trade-offs Accepted:** _TBD_

---

## Consequences

**What changes as a result of this decision?** _(depends on chosen option)_

**What follow-up work is needed?**

- [ ] If B or C chosen: a TECH item to re-sync (and, for C, build tooling in `Build-Plugin.ps1`)
- [ ] Decide a per-tier command manifest (which shared commands belong in full vs. light)
- [ ] Classify the `session-history` inline-vs-external-template difference as intentional or accidental
- [ ] Coordinate with TECH-161 (the rollover fix must land in whichever copies survive the decision)

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->
<!-- User can say "continue to completion" to approve remaining steps at once. -->

- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
  - AI presents: the inventory, the four options, a recommendation
  - User explicitly approves the chosen option before proceeding
- [ ] Chosen option recorded with rationale + trade-offs
- [ ] Follow-up work items created per the decision
- [ ] CHANGELOG.md updated (if it changes framework/plugin behavior)

---

## Related

- **Inventory / evidence:** [`project-hub/research/command-tier-drift-inventory.md`](../../research/command-tier-drift-inventory.md)
- **TECH-161** — session-history per-date rollover fix; narrowly scoped to the `fw` + full-plugin copies pending this decision.
- **TECH-159** — eliminated the analogous starter-command drift via "build copies canonical fresh"; precedent for Option C.
- **TECH-160** — plugin build execution-model alignment; an Option-C build approach would touch `Build-Plugin.ps1` and should coordinate with it.
