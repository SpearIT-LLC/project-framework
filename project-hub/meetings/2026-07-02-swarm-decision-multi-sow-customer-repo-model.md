# Swarm: Decision — Multi-SOW Single-Customer Repo Model

**Date:** 2026-07-02
**Mode:** decision
**Participants:** Gary Elliott, Alex (Engagement Lead), Dan (Senior Developer), Sam (Architect), Morgan (Security Analyst)

---

## Topic

How should a solo contractor structure repos/projects for a single customer with
multiple, independent SOWs — keeping clean start/finish per SOW while sharing
customer context and, above all, keeping history legible? The situation didn't fit
the four project types cleanly (framework / application / library / toolbox).

## Team Discussion

**Framing (Alex).** The repo is a *workspace*, not a deliverable — deliverables
ship out to the client. "Done" for an SOW means it goes quiet but stays
referenceable. Gary's sharpest pain is **history**, and he leaned toward one repo
per customer while wanting the failure modes of each option on the table.

**Two histories (Dan).** Git history (commits/tags) is per-repo and linear — in a
shared repo, SOW commits interleave, recoverable only via path filters. Framework
history (`project-hub/history/`) is file-based and can be kept clean per SOW
regardless of repo boundary. Gary cares more about the file-based work history,
which is "free" in either model.

**Three models, not two (Sam).** A (one repo, SOW folders), B (repo per SOW +
context repo), C (submodules). Gary rejected C on prior submodule pain — detached
HEADs, pointer commits, ceremony not worth it for a solo dev. B detaches shared
context and multiplies repos. A was the right shape.

**The Kanban correction (Gary → team).** Gary caught that the team's first framing
of Model A implied *multiple* `project-hub/` Kanban boards — which breaks the whole
point of Kanban for a one-person shop. He connected the model to the existing
`toolbox` type ("one project, many tools"). Dan owned the error: one pair of hands
→ one board. Sam reconciled: the SOW is a **theme/dimension**, not a separate
spine. Result: **one framework spine + one board at the customer root**, SOW as a
`Theme` tag + a deliverables/history folder.

**Already-built check (Dan/Claude, verified).** The `Theme:` frontmatter field
already exists in FEATURE, BUG, and TECH templates. So tagging is done; the gap is
**reporting by theme** and **history recording by theme**, plus a **scalable
content folder structure**.

**Security (Morgan).** Shared context concentrates secret blast radius; a committed
secret is permanent and customer-wide. Gary confirmed the "secrets never in repo"
philosophy, customer repos always private, contractor access rare and repo-scoped.

**Project type — introduce `engagement`, don't reuse `toolbox` (Gary → team).**
The session's first draft reused `toolbox`. Gary questioned whether a distinct 5th
type would be cleaner long-term, noting the tension already felt. He articulated the
decisive distinction: `toolbox` is a flat set of *homogeneous peers* (utility
scripts, each independent, same kind of thing), whereas a single-customer engagement
is *heterogeneous activities of different kinds* (org info, source, operations,
knowledge base, deliverables) that **grow wider over a long engagement**. A toolbox
doesn't sprawl into a KB + ops runbook + source tree; a customer does. Dan conceded
his conservative "reuse for now" position given the distinction is structural and a
real customer repo is imminent. Named **`engagement`** (over `client` / `workspace`)
— Gary's call, with the note that the *schema description* is what makes it clear or
confusing at the setup picker, so wording was made explicit. Detailed folder
structure deferred to FEAT-164 (sketch→use→formalize). Adding the type requires an
audit of type-branching points; the one with functional impact is
`framework-roles.yaml` → `project_type_defaults` (needs an `engagement` default role
or it falls through to `fallback_default`). ADR-005 amended in place. The actual
schema edit was deliberately **not** applied this session — Gary noted it must be
tied to a work item so a new distribution archive carries its history; it is
implemented via FEAT-165.

**Terminology — "stream," not "SOW" (Gary → team).** Gary flagged that "SOW" bakes
in a granularity assumption: his new project is defined *by* SOW, but the HPC/Honda
precedent has *multiple deliverables under one SOW*. The container term must stay
flexible. Team tested `engagements/` (implies SOW-level, rejected), reusing `theme`
(rejected — `Theme` already means *stable category* per ROADMAP-TEMPLATE; overloading
it mixes permanent-category and temporary-container meanings), and `deliverables/`
(rejected — a stream holds internal notes/research too, not only shippable output;
also collides with the "repo isn't the deliverable" principle). Landed on
**`streams/`** as the neutral container, with an optional `deliverables/` *subfolder*
inside each stream for the client handoff boundary. **`Stream`** (which bounded body
of work, temporary) is kept distinct from **`Theme`** (what kind of work, stable
category); an item may carry both.

## Decisions / Conclusions

- **Model A adopted** — one repo per customer, **streams** as folders under
  `streams/`, one framework spine, one Kanban board.
- **New `engagement` project type** (NOT `toolbox`) — decided this session, but the
  schema edit is deferred to FEAT-165 so it carries history into the distribution
  archive. Distinct because it holds heterogeneous, sprawling customer activities vs.
  toolbox's homogeneous script peers.
- **Container term = "stream"** (neutral across SOW / deliverable / phase
  granularity), with an optional `deliverables/` subfolder per stream. `Stream` kept
  distinct from the existing `Theme` (stable-category) dimension.
- **ADR filed & amended in the framework repo** (ADR-005) because the model requires
  framework changes, not just conventions.
- **Follow-up backlog (framework repo):** FEAT-163 (decide stream field; report by
  stream; ensure session/git/release history records by stream), FEAT-164 (scalable
  `streams/` + `customer/` content folder structure), FEAT-165 (introduce the
  `engagement` type + audit all type-branching points).
- **Next session:** scaffold the actual customer repo skeleton.

## Open Questions

- **Stream field:** reuse `Theme:` or add a distinct `Stream:` field (team leans
  distinct; decided in FEAT-163 / scaffolding session).
- Exact shape of the stream-reporting command: `/fw-status --stream` filter vs. a new
  `/fw-stream` view (to be decided in FEAT-163).
- How far to formalize git tag namespacing per stream (deferred — low priority since
  the repo is not a deliverable).

## Artifacts

- ADR: [project-hub/research/adr/005-multi-sow-customer-repo-model.md](../research/adr/005-multi-sow-customer-repo-model.md)
- Backlog: FEAT-163, FEAT-164, FEAT-165 (project-hub/work/backlog/)
- Note: `framework/docs/ref/framework-schema.yaml` edit **deferred** to FEAT-165 (not applied this session)

---
*AI-generated meeting record via /fw-swarm decision on 2026-07-02.*
