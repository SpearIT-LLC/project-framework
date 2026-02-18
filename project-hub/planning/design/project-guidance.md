# Project Guidance — Design Document

**Status:** Draft — Approved 2026-02-17
**Author:** Gary Elliott + Claude Code
**Related Work Item:** FEAT-136
**Last Updated:** 2026-02-17

---

## Purpose

This document defines the intended user experience, conversation flow, outputs, and information architecture for the **Project Guidance** theme of the SpearIT Framework. It is the prerequisite design document for implementing the `/swarm` command and all related Project Guidance features.

---

## 1. Project Lifecycle Overview

The full lifecycle a user follows from idea to execution, with handoffs:

```
/swarm (kick-off)
    ↓ produces
Project Brief  →  project-hub/planning/project-brief.md
    ↓ informs
Roadmap  →  project-hub/planning/ROADMAP.md
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
| `/swarm` | User (new project or pivot) | Meeting notes + Project Brief | User, when ready to plan |
| Project Brief | `/swarm` output | `project-brief.md` — official project direction | User, when brief is approved |
| Roadmap | User runs `/fw-roadmap` | `ROADMAP.md` — themes + planning periods | User, at planning period start |
| Planning Period | Roadmap defines it | Named period with goals + success criteria | User, pulls backlog into todo |
| Work Items | Backlog grooming / `/swarm` starter backlog | `project-hub/work/backlog/*.md` | User, pulls to todo when ready |
| Kanban Workflow | Work items exist | Done items, session histories | Ongoing, self-managing |
| Periodic Review | End of planning period | Updated brief/roadmap, new backlog items | User, starts new period or new swarm |

### The Repeat Loop

At the end of a planning period, the user has three paths:

- **New Planning Period** — project is on track, continue. Update roadmap, pull new backlog items.
- **Periodic Review** *(Future command)* — structured check-in: what did we learn, what changes? Updates brief and roadmap.
- **New Swarm** — significant pivot. The project direction has changed enough that a new kick-off is warranted. Produces a new project brief (prior brief archived).

The distinction: a **new swarm** reestablishes direction. A **periodic review** refines it.

---

## 2. MVP Scope Definition

### In Scope (PI MVP)

| Capability | Notes |
|---|---|
| `/swarm` kick-off conversation | Core deliverable |
| Sequential named-role discussion | Fixed roster, not dynamic |
| Meeting notes saved to file | `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` |
| Project brief saved to file | `project-hub/planning/project-brief.md` |
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

### Minimum Viable Kick-off

For a trivially small project (a script, a one-off tool), `/swarm` should still complete — but with a lighter team and shorter conversation. The Product Owner and Senior Dev are always present. Specialist roles (UX, Security, Data) are skipped if scope doesn't warrant them.

The conversation terminates when the team has enough to write a brief. For a simple script that may be 3-4 exchanges. For a complex product it may be 10-12.

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

### Opening

The facilitator (Product Owner) opens with a single warm, direct question:

> *"Tell me about what you're trying to build — or the problem you're trying to solve. Don't worry about having it all figured out yet."*

No preamble. No explanation of what swarm is. The experience speaks for itself.

### Clarifying Question Sequence

After the user's opening response, the Product Owner asks 1-2 follow-up questions to establish:

1. **Who is this for?** (user themselves, a client, a team, the public)
2. **What does success look like?** (what changes when this exists?)
3. **What's the rough scale?** (weekend script → small product → serious application)

These answers determine which disciplines join the conversation.

### Team Assembly

After initial clarification, the Product Owner briefly introduces the team:

> *"Thanks — this gives me enough to pull in the right people. Let me bring the team together."*

Each discipline then speaks in turn. **2-4 sentences maximum per turn.** Each role addresses only their specific lens — they don't summarize what others said.

If scope is trivial, the Product Owner may note: *"This looks straightforward enough that we don't need the full team — let me loop in [Senior Dev] and we'll keep this brief."*

### Termination Condition

The conversation ends when the team collectively has answers to:
- What are we building?
- Who is it for and why does it matter?
- What is the MVP (what's the smallest useful version)?
- What are the top 2-3 risks or unknowns?
- What structure does the project need (light/medium/full)?

The Product Owner closes the discussion and announces the brief will be written.

### Tone

Warm, direct, professional. The team speaks like experienced colleagues who have done this before — not like consultants performing expertise. No jargon for its own sake. Occasional dry wit is fine; cheerfulness is not.

---

## 4. Discipline Roster (MVP)

Fixed roster for PI MVP. Dynamic expansion (adding a Data Scientist mid-project, etc.) is Future.

### Always Present

| Role | Name (example) | Contributes |
|---|---|---|
| **Product Owner** | Alex | Facilitates, asks market/user questions, defines MVP boundary, writes brief |
| **Senior Developer** | Dan | Technical feasibility, complexity assessment, flags architectural landmines |

### Conditionally Present

Included when project characteristics warrant:

| Role | Name (example) | Triggered When | Contributes |
|---|---|---|---|
| **UX Designer** | Jordan | User-facing product (app, tool, interface) | Usability, user flow, scope of UI work |
| **Security Analyst** | Morgan | Auth, user data, external APIs, financial data | Threat surface, compliance flags, "don't forget" items |
| **Data / ML Specialist** | Riley | Data pipelines, AI features, analytics, reporting | Data architecture, model fit, data quality risks |
| **Scrum Master** | Sam | Medium/full complexity projects | Process, WIP risks, team dynamics (for small teams) |

### Role Invocation Logic

The Product Owner decides which roles to include based on initial clarification:

- **Always:** Product Owner + Senior Dev
- **+ UX Designer:** project has an end-user interface
- **+ Security Analyst:** project handles user accounts, payments, PII, or external APIs
- **+ Data/ML Specialist:** project involves AI, data pipelines, analytics, or significant reporting
- **+ Scrum Master:** medium or full complexity, or user mentions team coordination

For a minimal project, 2 roles. For a complex product, up to 5.

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

**Format:** Structured document — the official project direction. Template:

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

## Recommended Structure
Light / Medium / Full — [brief rationale]

## Starter Backlog
[5-10 work items as a bulleted list — user creates files with /fw-new]

## Open Risks & Questions
[Top 2-3 items the team flagged]

---
*Generated by /swarm on YYYY-MM-DD. Update when project direction changes significantly.*
```

**Single file, not versioned by name.** Prior versions preserved in git history. If the project pivots significantly, the brief is updated and the old version committed with a clear commit message.

### C. Starter Backlog

Output to chat as a bulleted list within the Project Brief. The user creates actual work item files using `/fw-new` or manually. Automatic file creation is Future.

---

## 6. Edge Cases & Failure Modes

### User runs `/swarm` mid-project

**Scenario:** Project already has `project-brief.md`, `ROADMAP.md`, and an active backlog.

**Behavior (MVP):** `/swarm` does not read existing artifacts. It treats this as a fresh conversation. At the end, before writing the brief, it warns:

> *"I see this project already has a brief at `project-hub/planning/project-brief.md`. Saving will overwrite it. Proceed?"*

The user can cancel and treat the output as a review conversation instead.

**Future:** A `/swarm review` variant that reads existing artifacts and conducts a lighter check-in against the current plan.

### User has no clear idea what they're building

**Behavior:** The Product Owner leans in with more questions rather than less. This is the most valuable use case — helping someone think through an unclear idea is the core differentiator. The team asks: *"What problem frustrates you most right now?"* and works from there.

The conversation may end with a project brief that says "We're still exploring — here are the 3 directions worth investigating" rather than a firm MVP definition. That is a valid output.

### Scope is trivially small

**Behavior:** After initial clarification, the Product Owner acknowledges the scope:

> *"This is a focused, well-defined task — we don't need the full team for this. Let me keep it short."*

Minimal team (Product Owner + Senior Dev). Conversation is 3-5 exchanges. Brief is concise. No starter backlog needed if it's a single work item.

### Existing framework artifacts

In MVP, `/swarm` does not read `ROADMAP.md`, existing backlog items, or session histories. It operates from the conversation alone. This is a known limitation — future versions will read context to avoid redundancy.

---

## 7. Information Architecture

```
project-hub/
├── planning/
│   ├── project-brief.md          ← /swarm output: official project direction
│   ├── ROADMAP.md                ← strategic direction (themes + planning periods)
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
