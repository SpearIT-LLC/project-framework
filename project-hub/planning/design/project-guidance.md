# Project Guidance — Design Document

**Status:** Draft — Revised 2026-02-20
**Author:** Gary Elliott + Claude Code
**Related Work Item:** FEAT-136, FEAT-146
**Last Updated:** 2026-02-20

---

## Purpose

This document defines the intended user experience, conversation flow, outputs, and information architecture for the **Project Guidance** theme of the SpearIT Framework. It is the prerequisite design document for implementing the `/swarm` command and all related Project Guidance features.

**Goal of `/swarm`:** Give the user a clear, confident project direction — what to build, for whom, and in what order — before they commit to any work.

---

## 1. Project Lifecycle Overview

The full lifecycle a user follows from idea to execution, with handoffs:

```
/swarm (kick-off — Phase 1: Discovery + Phase 2: Planning)
    ↓ produces
Project Brief    →  project-hub/planning/project-brief.md
Project Outline  →  project-hub/planning/project-outline.md
    ↓ informs
Roadmap  →  project-hub/planning/ROADMAP.md  (via /fw-roadmap)
    ↓ defines
Planning Period (with goals + success criteria)
    ↓ generates
Work Items  →  project-hub/work/backlog/
    ↓ executed via
Kanban Workflow  (todo → doing → done)
    ↓ captured in
Session History + Status Reports
    ↓ reviewed in
Periodic Review  (end of planning period)
    ↓ leads to
New Planning Period  OR  Retrospective  OR  New Swarm
```

### Handoff Details

| Step | Triggered By | Produces | Who Initiates Next |
|---|---|---|---|
| `/swarm` | User (new project or pivot) | Meeting notes + Project Brief + Project Outline | User, when outputs are approved |
| Project Brief | `/swarm` Phase 2 output | `project-brief.md` — what, why, for whom (stable) | User, when brief is approved |
| Project Outline | `/swarm` Phase 2 output | `project-outline.md` — phases, sequence, dependencies (evolves) | User, when outline is approved |
| Roadmap | User runs `/fw-roadmap` | `ROADMAP.md` — planning periods, goals, progress (living) | User, at planning period start |
| Planning Period | Roadmap defines it | Named period with goals + success criteria | User, pulls backlog into todo |
| Work Items | Backlog grooming / `/swarm` starter backlog | `project-hub/work/backlog/*.md` | User, pulls to todo when ready |
| Kanban Workflow | Work items exist | Done items, session histories | Ongoing, self-managing |
| Periodic Review | End of planning period | Updated brief/roadmap, new backlog items | User, starts new period or new swarm |

### Document Purposes

| Document | Answers | Cadence |
|---|---|---|
| `project-brief.md` | What, why, for whom | Stable — updated on pivot only |
| `project-outline.md` | Phases, sequence, dependencies | Evolves as project progresses |
| `ROADMAP.md` | Planning periods, goals, progress | Living — updated each period |

### The Repeat Loop

At the end of a planning period, the user has three paths:

- **New Planning Period** — project is on track, continue. Update roadmap, pull new backlog items.
- **Periodic Review** *(Future command)* — structured check-in: what did we learn, what changes? Updates brief and roadmap.
- **New Swarm** — significant pivot. The project direction has changed enough that a new kick-off is warranted. Produces a new project brief and outline (prior versions archived).

The distinction: a **new swarm** reestablishes direction. A **periodic review** refines it.

---

## 2. MVP Scope Definition

### In Scope (PI MVP)

| Capability | Notes |
|---|---|
| `/swarm` two-phase kick-off | Phase 1: Discovery, Phase 2: Planning |
| Sequential named-role discussion | PO assembles team based on signals, not a fixed list |
| Meeting notes saved to file | `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` |
| Project brief saved to file | `project-hub/planning/project-brief.md` |
| Project outline saved to file | `project-hub/planning/project-outline.md` |
| Starter backlog (5-10 items) | Written to chat; user creates files manually or with `/fw-new` |
| Open risks/questions | Included in meeting notes |
| `--summary` flag | Bottom-line output, skips team discussion |

### Out of Scope (Future)

| Capability | When |
|---|---|
| Periodic review command | PI: Developer Intelligence or later |
| Retrospective command | Future |
| Dynamic discipline roster | Future |
| Smart suggestion ("no brief found, run `/swarm`?") | Future |
| Voice/TTS team discussion | Future (platform dependent) |
| Human meeting notes template | Future (folder structure created now) |
| Starter backlog auto-created as files | Future (FEAT-TBD) |
| `/fw-roadmap` reads project outline as input | Future (next PI) |

### Minimum Viable Kick-off

For a trivially small project (a script, a one-off tool), `/swarm` should still complete — but with a lighter team and shorter conversation. The Product Owner and Senior Dev are always present. Specialist roles are skipped if scope doesn't warrant them.

The conversation terminates when the team has enough to write a brief and outline. For a simple script that may be 3-4 exchanges. For a complex product it may be 10-12.

### Explicit Exclusions (MVP)

- `/swarm` does **not** create work item files automatically
- `/swarm` does **not** read or modify an existing roadmap
- `/swarm` does **not** run retrospectives or periodic reviews
- `/swarm` does **not** suggest itself proactively from other commands

---

## 3. `/swarm` Conversation Design

### Invocation

```
/swarm                    # Standard kick-off
/swarm --summary          # Bottom-line only (no team discussion shown)
```

### Phase 1 — Discovery

#### Opening

The facilitator (Product Owner) opens with a single warm, direct question:

> *"Tell me about what you're trying to build — or the problem you're trying to solve. Don't worry about having it all figured out yet."*

No preamble. No explanation of what swarm is. The experience speaks for itself.

#### Clarifying Question Sequence

After the user's opening response, the Product Owner asks 1-2 follow-up questions to establish:

1. **Should we build this at all?** Are there existing tools, simpler approaches, or reasons not to proceed?
2. **Who is this for?** (user themselves, a client, a team, the public)
3. **What does success look like?** (what changes when this exists?)
4. **What's the rough scale?** (weekend script → small product → serious application)

These answers determine which disciplines join the conversation.

#### Team Assembly

After initial clarification, the Product Owner assembles the team based on signals heard — not a fixed trigger list. The PO uses judgment about what lenses are needed for *this* project.

> *"Thanks — this gives me enough to pull in the right people. Let me bring the team together."*

Each discipline then speaks in turn. **2-4 sentences maximum per turn.** Each role addresses only their specific lens — they don't summarize what others said.

If scope is trivial, the Product Owner may note: *"This looks straightforward enough that we don't need the full team — let me loop in [Senior Dev] and we'll keep this brief."*

#### Phase 1 Termination Condition

Phase 1 ends when the team collectively has answers to:
- What are we building?
- Should we build it, and why not something else?
- Who is it for and why does it matter?
- What is the MVP (what's the smallest useful version)?
- What are the top 2-3 risks or unknowns?

The Product Owner closes Phase 1:

> *"Good — I think we have enough. Let me get the team to put together a plan."*

### Phase 2 — Planning

The Product Owner and Architect (if present) produce the project brief and outline. Other team members do not re-speak in Phase 2 unless a specific question arises.

The PO presents the brief and outline to the user for approval before writing files.

#### Phase 2 Termination Condition

Phase 2 ends when the user approves the brief and outline. Files are then written.

### Tone

Warm, direct, professional. The team speaks like experienced colleagues who have done this before — not like consultants performing expertise. No jargon for its own sake. Occasional dry wit is fine; cheerfulness is not.

---

## 4. Discipline Roster (MVP)

The Product Owner assembles the team based on signals from the conversation. The roster below defines available roles and the kinds of signals that warrant including them — but the PO uses judgment, not a mechanical trigger list.

### Always Present

| Role | Name | Contributes |
|---|---|---|
| **Product Owner** | Alex | Facilitates, challenges scope, defines MVP boundary, writes brief, leads Phase 2 |
| **Senior Developer** | Dan | Technical feasibility, complexity assessment, flags architectural landmines |

### Conditionally Present

| Role | Name | When Warranted | Contributes |
|---|---|---|---|
| **Architect** | Sam | Non-trivial scope; multiple components or integrations | System structure, phase sequencing, integration risks, leads outline in Phase 2 |
| **UX Designer** | Jordan | User-facing product (app, tool, interface) | Usability, user flow, scope of UI work |
| **Security Analyst** | Morgan | Auth, user data, external APIs, financial data | Threat surface, compliance flags, "don't forget" items |
| **Data / ML Specialist** | Riley | Data pipelines, AI features, analytics, reporting | Data architecture, model fit, data quality risks |

### Phase 2 Roles

Phase 2 (Planning) is led by:
- **Product Owner** — owns the brief
- **Architect** — owns the outline (if present); Senior Dev fills this role if no Architect

Other roles do not speak in Phase 2 unless a specific question requires their input.

---

## 5. Outputs

### A. Meeting Notes

**Location:** `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md`

**Format:** Narrative meeting summary capturing the team discussion. Includes:
- Date, participants (role names)
- The problem/idea as stated by the user
- Key points raised by each discipline
- Decisions made during discussion
- Open questions and risks flagged

This is the **record** — it captures how the team got to its conclusions, not just what was decided.

### B. Project Brief

**Location:** `project-hub/planning/project-brief.md`

**Purpose:** What, why, for whom. Stable — updated only when project direction changes significantly.

**Format:**

```markdown
# Project Brief: [Project Name]

**Created:** YYYY-MM-DD (via /swarm)
**Last Updated:** YYYY-MM-DD
**Status:** Active

---

## What We're Building
[1-3 sentence description]

## Who It's For
[Primary user/audience and their core need]

## Why It Matters
[The problem it solves, the value it delivers]

## MVP Definition
[The smallest useful version — what's in, what's explicitly out]

## Starter Backlog
[5-10 work items as a bulleted list — user creates files with /fw-new]

## Open Risks & Questions
[Top 2-3 items the team flagged]

---
*Generated by /swarm on YYYY-MM-DD. Update when project direction changes significantly.*
```

**Archival:** When `/swarm` overwrites an existing brief, the prior version is archived to `project-hub/planning/archive/project-brief-YYYY-MM-DD.md` before writing the new one. Consistent with the ROADMAP.md archival pattern.

### C. Project Outline

**Location:** `project-hub/planning/project-outline.md`

**Purpose:** Phases, sequence, and dependencies. Evolves as the project progresses — phases are checked off, new phases added as needed.

**Format:**

```markdown
# Project Outline: [Project Name]

**Created:** YYYY-MM-DD (via /swarm)
**Last Updated:** YYYY-MM-DD

---

## Phase Overview

| Phase | Description | Depends On | Status |
|---|---|---|---|
| 1. [Phase Name] | [What this phase delivers] | — | Pending |
| 2. [Phase Name] | [What this phase delivers] | Phase 1 | Pending |
| 3. [Phase Name] | [What this phase delivers] | Phase 2 | Pending |

## Phase Details

### Phase 1: [Name]
**Goal:** [What done looks like]
**Key work items:** [Major areas of work]
**Risks:** [Phase-specific risks]

### Phase 2: [Name]
...

---
*Generated by /swarm on YYYY-MM-DD.*
```

**Phase template selection:** The Architect (or Senior Dev) selects from known phase patterns based on project type (e.g., Web App, CLI Tool, Data Pipeline, API Service) and customizes for the specific project. Templates provide structural consistency; AI customization handles project specifics.

**Archival:** Same pattern as project-brief.md — prior version archived to `planning/archive/` before overwrite.

### D. Starter Backlog

Output to chat as a bulleted list within the Project Brief. The user creates actual work item files using `/fw-new` or manually. Automatic file creation is Future.

---

## 6. Edge Cases & Failure Modes

### User runs `/swarm` mid-project

**Scenario:** Project already has `project-brief.md`, `ROADMAP.md`, and an active backlog.

**Behavior (MVP):** `/swarm` does not read existing artifacts. It treats this as a fresh conversation. At the end of Phase 2, before writing files, it warns:

> *"I see this project already has a brief and/or outline. I'll archive the existing files to `project-hub/planning/archive/` before saving the new ones. Proceed?"*

The user can cancel and treat the output as a review conversation instead. If the user proceeds, prior files are archived first, then new files are written.

**Future:** A `/swarm review` variant that reads existing artifacts and conducts a lighter check-in against the current plan.

### User has no clear idea what they're building

**Behavior:** The Product Owner leans in with more questions rather than less. This is the most valuable use case — helping someone think through an unclear idea is the core differentiator. The team asks: *"What problem frustrates you most right now?"* and works from there.

The conversation may end with a project brief that says "We're still exploring — here are the 3 directions worth investigating" rather than a firm MVP definition. That is a valid output.

### Scope is trivially small

**Behavior:** After initial clarification, the Product Owner acknowledges the scope:

> *"This is a focused, well-defined task — we don't need the full team for this. Let me keep it short."*

Minimal team (Product Owner + Senior Dev). Conversation is 3-5 exchanges. Brief is concise. Outline may be a single phase. No starter backlog needed if it's a single work item.

### Existing framework artifacts

In MVP, `/swarm` does not read `ROADMAP.md`, existing backlog items, or session histories. It operates from the conversation alone. This is a known limitation — future versions will read context to avoid redundancy.

---

## 7. Information Architecture

```
project-hub/
├── planning/
│   ├── project-brief.md          ← /swarm output: what, why, for whom (stable)
│   ├── project-outline.md        ← /swarm output: phases, sequence, dependencies (evolves)
│   ├── ROADMAP.md                ← /fw-roadmap output: planning periods, goals, progress (living)
│   ├── archive/                  ← prior versions of brief and outline
│   │   ├── project-brief-YYYY-MM-DD.md
│   │   └── project-outline-YYYY-MM-DD.md
│   └── design/                   ← feature design docs
│       └── project-guidance.md   ← this document
├── meetings/
│   ├── YYYY-MM-DD-swarm-kickoff.md   ← AI-generated swarm meeting notes
│   └── YYYY-MM-DD-[topic].md         ← human or AI notes (future: human template)
├── history/
│   └── sessions/                 ← session histories (Reporting & Visibility theme)
├── research/                     ← research artifacts
└── work/                         ← Kanban folders
```

---

## 8. Backlog Culling (Placeholder)

Future capability for reviewing and pruning stale backlog items. Likely a Project Guidance command — reads backlog items, assesses staleness against current project brief and roadmap, and presents keep/archive/delete recommendations for user approval.

Not specced for PI MVP. Capture here as a design consideration for the Project Guidance command set.

---

## 9. Future Considerations

| Capability | Notes |
|---|---|
| `/swarm review` | Periodic review variant — reads existing artifacts, lighter kick-off |
| `/swarm retro` | End-of-period retrospective — what did we learn? |
| Dynamic discipline expansion | Add a specialist mid-project ("this needs a Data Scientist") |
| Smart suggestion | Other commands detect missing brief and suggest `/swarm` |
| Human meeting notes template | Structured format for live meetings AI can read later |
| Starter backlog auto-creation | `/swarm` creates work item files directly (depends on FEAT-139 claude-project.yaml) |
| Voice/TTS | Team discussion spoken aloud — platform dependent |
| `/fw-roadmap` reads project outline | Roadmap command uses outline as structured input for planning periods |
| Phase template library | Named templates (Web App, CLI Tool, API Service, etc.) for outline generation |

---

## Decisions Log

| Date | Decision | Rationale |
|---|---|---|
| 2026-02-17 | Sequential named roles (not synthesized output) | Preserves the team experience; synthesized output feels like a report |
| 2026-02-17 | Human names + role title (Alex, Product Owner) | Warm, not gimmicky; personality comes from how roles speak, not branding |
| 2026-02-17 | Meeting notes saved to `project-hub/meetings/` | Enables reference continuity ("On Jan 10 the team agreed...") |
| 2026-02-17 | Project brief saved to `project-hub/planning/project-brief.md` | Single source of truth; versioned via git |
| 2026-02-17 | Meeting summary wrapping structured brief | Captures rationale (summary) + machine-readable artifact (brief) |
| 2026-02-17 | User decides when to run `/swarm` (MVP) | Simpler; smart suggestion ("no brief found") is Future |
| 2026-02-17 | Swarm = new/pivot direction; Periodic Review = refine existing | Clear distinction prevents overlap between future commands |
| 2026-02-17 | `--summary` flag for bottom-line output | Accommodates users who want results without team discussion |
| 2026-02-20 | Archive prior brief/outline to `planning/archive/` on overwrite | Read-only reference shouldn't require git restore; consistent with ROADMAP archival pattern |
| 2026-02-20 | `/swarm` produces project-outline.md in addition to project-brief.md | Brief answers what/why/for whom; outline answers phases/sequence/order — different cadences, different purposes |
| 2026-02-20 | Project outline is separate from brief and roadmap | Brief is stable; roadmap is living; outline evolves — three documents, three cadences, three purposes |
| 2026-02-20 | `/swarm` uses two phases: Discovery + Planning | Team has all information needed at end of discovery; separate planning command would be artificial friction |
| 2026-02-20 | Phase 2 led by PO + Architect only | Other roles don't need to re-speak; keeps Phase 2 tight |
| 2026-02-20 | Architect added as conditional role | Senior Dev covers feasibility; Architect covers structure and phase sequencing — distinct lens |
| 2026-02-20 | PO assembles team by judgment, not mechanical trigger list | Signals from conversation determine needs; rigid triggers miss nuance |
| 2026-02-20 | "Should we build this?" added to PO clarifying questions | Preventing wrong-direction work is part of the goal; alternatives should be surfaced early |
| 2026-02-20 | Removed "light/medium/full structure" from termination criteria | Framework plugin tiers are not a project design concern; team recommends approach, doesn't ask user to decide |
| 2026-02-20 | Phase template selection by Architect/Senior Dev | Templates provide structural consistency; AI customization handles project specifics; prevents same problem generating different outlines day to day |
