# Bug: Starter CLAUDE.md does not deliver the framework collaboration contract

**ID:** BUG-181
**Type:** Bug
**Priority:** High
**Version Impact:** MINOR
**Created:** 2026-07-13
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->
**Theme:** Distribution & Onboarding

---

## Summary

`templates/starter/CLAUDE.md` (82 lines) omits nearly the entire AI collaboration contract that
`framework/CLAUDE.md` (501 lines) defines. A project created from the framework ships **without** role
wiring, the ADR-001 checkpoint policy, the AI Reading Protocol, the `/fw-*` command reference, or the
full Epistemic Standards. The framework's core guarantees do not reach the projects it creates.

---

## Bug Description

**What is happening (actual behavior)?**

A new project scaffolded from `templates/starter/` gets a `CLAUDE.md` containing: a weak bootstrap
block, a truncated Epistemic Standards, a one-line `framework.yaml` pointer, three small link tables,
and a stub "Project-Specific Notes" section. That is all.

**What should happen (expected behavior)?**

The derived project's AI should operate under the same contract this repo's AI does — the contract the
framework exists to distribute.

**Impact:**

Every project created from the framework. The AI in a derived project will not, by default:

| Missing | Consequence in a derived project |
|---|---|
| **Roles** (`framework.yaml` → `roles.default`) | AI never adopts a role. `framework.yaml` ships the `roles` section; nothing tells the AI to read it. |
| **ADR-001 Checkpoint Policy** | No "state your approach and wait for approval" gate. The framework's single most-cited rule. |
| **AI Reading Protocol** | AI does not know when to read which collaboration doc. |
| **`/fw-*` command reference** | AI does not know the commands exist. |
| **"Never present inference as fact"** | Present in root and framework standards; **dropped** from starter's Epistemic Standards. |
| **Core standards summary** (code/security/testing/git) | No pointer into the collaboration guides. |
| **Emergency Reference** | No WIP-limit / version-mismatch / archival recovery. |

---

## Reproduction Steps

**Steps to Reproduce:**

1. Read `templates/starter/CLAUDE.md` (82 lines).
2. Read `framework/CLAUDE.md` (501 lines).
3. Diff their section headings.
4. Observe that starter carries none of: AI Reading Protocol, AI Roles, AI Workflow Checkpoint Policy,
   Core Standards Summary, ADR decision tree, Working with Claude, Emergency Reference, Framework
   Commands.

**Reproducibility:** Always.

**Verified 2026-07-13.**

---

## Root Cause Analysis

**File(s) Affected:**
- `templates/starter/CLAUDE.md` — the omission
- `framework/CLAUDE.md` — the contract that should reach the template

**Root Cause:**

Not drift between copies — **omission**. The starter template was authored as a small project shell and
was never given the contract. The framework then evolved its contract (roles, ADR-001, `/fw-*`,
Epistemic Standards) in `framework/CLAUDE.md` only, and nothing ever propagated.

**Why was this missed?**

The framework repo dogfoods its own contract via `framework/CLAUDE.md`, so the gap is invisible from
inside this repo. It only appears when you ask what a *derived* project actually receives.

---

## The delivery mechanism already exists (verified 2026-07-13)

**No build change is required.** `tools/Build-FrameworkArchive.ps1` **Step 5.5** already copies
`framework/CLAUDE.md` into the archive at `framework/CLAUDE.md`, commented *"canonical source — not
duplicated in the starter template."* A **drift-guard** at lines 113–128 hard-errors the build if
`templates/starter/framework/` exists, precisely to prevent a stale checked-in copy.

So every derived project already ships **two** CLAUDE.md files:

| File | Source | Auto-loaded by Claude? |
|---|---|---|
| `CLAUDE.md` (root) | `templates/starter/CLAUDE.md` — 82 lines | **Yes** |
| `framework/CLAUDE.md` | copied fresh from canonical at build — 501 lines | No |

**The contract is physically present in every derived project. The root CLAUDE.md — the only one Claude
auto-loads — never tells anyone it is there.** It links to
`framework/docs/collaboration/workflow-guide.md` but *never* to `framework/CLAUDE.md`.

That is the whole bug: **a missing pointer, not a missing file.**

---

## Fix Design → **owned by ADR-007**

> **SUPERSEDED 2026-07-13, same session.** This item originally proposed *"starter delegates by
> reference — add a pointer to `framework/CLAUDE.md`."* Investigating that fix exposed a far larger
> problem and the design moved to an ADR. **The fix design now lives in
> [ADR-007](../../research/adr/007-ai-collaboration-contract-and-claude-md.md)** (Proposed). This item
> remains the *bug record*; do not implement from the superseded design below.

**What the investigation found, and why the pointer fix died:**

An audit of `framework/CLAUDE.md`'s 501 lines against every file it links to (2026-07-13) found it is
**~23 lines of genuinely unique content — 4.6%.** The other ~95% is a condensed restatement of guides
that already own it. And it is not the *fourth* copy but the **fifth**: `workflow-guide.md` →
`collaboration/README.md` → `architecture-guide.md` → `CLAUDE-QUICK-REFERENCE.md` (334 lines, same
folder) → `CLAUDE.md`. Accounting for `CLAUDE-QUICK-REFERENCE.md`, the unique residue is **~8 lines**.

Pointing at it would have been **pointing at a duplicate that had already rotted** — the audit found the
command list 6 commands stale, ADR template paths that do not exist, a "complete 11-step workflow"
reference to a workflow that does not exist (and `workflow-guide.md` pointing back at a "CLAUDE.md Step
9" that also does not exist — a circular dangling reference), a permissions section that materially
misdescribes the project's actual security posture, and a folder tree wrong in ~8 ways.

**ADR-007's answer** (see the ADR for the reasoning):
- **D1** — `CLAUDE.md` is a *contract*, not a manual: binding rules that exist nowhere else, plus
  bootstrap, plus project identity. ≤150 lines. No restatement of any guide.
- **D2** — **retire `framework/CLAUDE.md`.** Relocate its ~8 unique lines; delete the rest. A
  `CLAUDE.md` that Claude never auto-loads is a misleading filename on a duplicate document.
- **D2a** — the root cause: this repo's *"Which Project Are You Working On?"* framing licensed a second
  contract to exist. The repo is **one** project.
- **D3** — route through `framework.yaml`'s existing `sources:` index. **No summary layers.**
- **D4** — **derive the region, not the file.** Every root `CLAUDE.md` is explicitly partitioned into
  `<!-- BEGIN FRAMEWORK CONTRACT -->` (derived, replaced on upgrade) and
  `<!-- BEGIN USER INSTRUCTIONS -->` (the user's, never touched). The contract is authored **once** and
  composed into each channel at build time.

**What this bug's fix becomes:** an *instance* of ADR-007 — the starter's `CLAUDE.md` gains the derived
framework-contract region. **Re-scope this item once ADR-007 is ratified.**

---

## Still-valid findings (independent of the fix design)

**The delivery gap is real and is what this bug records.** A derived project ships an 82-line root
`CLAUDE.md` (auto-loaded) and a 501-line `framework/CLAUDE.md` (never loaded, never linked to). The
contract does not reach the AI. That is true regardless of how ADR-007 resolves.

**`templates/starter/framework.yaml` is more correct than the repo's.** It already carries the full
25-entry `sources:` index, `policies:`, and `roles:` — and its `project-structure` points at
`PROJECT-STRUCTURE.md`, while the **repo's** `framework.yaml:79` points at
`framework/docs/PROJECT-STRUCTURE-STANDARD.md`, **which does not exist**. `/fw-topic-index` reads that
block, so the repo's topic index currently resolves to a missing file. *(Small, separable, verified —
file as its own BUG if ADR-007 does not sweep it up.)*

**Starter's `framework.yaml` pointer is weaker than root's.** Starter's bootstrap says only *"check
project configuration"*; root's says *"check `roles.default` for your starting role."* A derived project
therefore never learns that `framework.yaml` drives role selection. Whatever shell survives ADR-007 must
carry the stronger form.

---

## Testing

### Verification Steps

*(Deferred to ADR-007's implementation item — the fix design is no longer this item's to specify.)*

1. Scaffold a project from `templates/starter/`.
2. Confirm the derived root `CLAUDE.md` contains a populated framework-contract region.
3. Confirm an AI reading **only** the derived root `CLAUDE.md` receives: roles wiring, the ADR-001
   checkpoints, the `/fw-*` commands, and the full Epistemic Standards.
4. Confirm the USER INSTRUCTIONS region survives a simulated framework upgrade untouched.

### Regression Testing

- [ ] `Setup-Framework.ps1` still renders `{{PROJECT_NAME}}` / `{{DATE}}` placeholders correctly
- [ ] No broken relative links in the derived project
- [ ] `templates/NEW-PROJECT-CHECKLIST.md` still accurate

---

## Documentation Updates

- [ ] `templates/NEW-PROJECT-CHECKLIST.md` — if the CLAUDE.md story changes
- [ ] `framework/CHANGELOG.md`

---

## Implementation Checklist

<!-- ⚠️ AI: Complete items in order. STOP at each [ ] and wait for approval. -->

- [x] **Root cause investigated** — 2026-07-13. Found the delivery gap, and found that the artifact to
      be delivered is itself ~95% duplicate and materially stale.
- [ ] **BLOCKED — ADR-007 must be ratified first.** It owns the fix design (D1–D5). Do not implement
      from this item's superseded design.
- [ ] Re-scope this item as an ADR-007 implementation instance once the ADR is Accepted
- [ ] **PRE-IMPLEMENTATION REVIEW COMPLETED**
- [ ] *(remaining steps depend on ADR-007's ratified D4 — do not enumerate them yet)*

---

## Documentation

<!-- Dogfooding FEAT-180 (mandatory documentation section). -->

| Surface | What it must say | Audience |
|---|---|---|
| `templates/starter/CLAUDE.md` | where the contract lives; what is project-local | AI in a derived project |
| `templates/NEW-PROJECT-CHECKLIST.md` | that CLAUDE.md delegates, and what to fill in | human starting a project |
| `framework/CHANGELOG.md` | derived projects now receive the contract | upgraders |

---

## Related

- **ADR-007** (Proposed 2026-07-13) — **owns the fix design.** This item is the bug record; the ADR is
  the answer. **This item is blocked on its ratification.**
- **ADR-006** — established one-authored-source + per-channel derivation for the work-item type SoT.
  ADR-007 applies the same principle to the collaboration contract.
- **ADR-001** — the checkpoint policy that derived projects currently do not receive. Its three
  checkpoints exist **only** in the two files ADR-007 retires.
- **DECISION-050** — framework-as-dependency. Why `framework/CLAUDE.md` is present in every derived
  project at all.
- **DECISION-036** — template access strategy. Check for conflict when ADR-007 is implemented.
- **TECH-169 / DECISION-162** — the command-tier copy/drift problem. **Same class of bug, different
  artifact**: N tiers, no propagation rule. ADR-007 states the rule; feed it into both.
- **FEAT-180** — mandatory `## Documentation` section. Dogfooded above.

---

## Notes

**Discovered 2026-07-13** while deciding where to put a new "Response Style" section (bottom-line-up-
front response guidance). The question "which CLAUDE.md does this go in?" exposed that the three files
have no propagation rule at all — and that starter was missing far more than the new section.

**Response Style is a live instance of this bug.** It was added to `/CLAUDE.md` (root) on 2026-07-13.
It belongs in `framework/CLAUDE.md` (the contract). Under the fix, starter inherits it for free. Until
this item lands, decide deliberately where it goes — do not add a third copy.

**Also observed while auditing** (not fixed here, low severity — file separately if they persist):
- `framework/CLAUDE.md:417` — Emergency Reference still says
  `cp templates/FEATURE-TEMPLATE.md ...`: the pre-**TECH-176** template name, and `cp` where the
  framework mandates `git mv`.

---

**Last Updated:** 2026-07-13
