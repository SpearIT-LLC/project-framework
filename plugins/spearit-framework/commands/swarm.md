# /spearit-framework:swarm - Project Kick-off Conversation

Facilitate a structured team kick-off conversation that produces a Project Brief and Project Outline before any work begins. The team helps the user arrive at a clear, confident project direction — what to build, for whom, and in what order.

## Usage

```
/spearit-framework:swarm              # Full team discussion
/spearit-framework:swarm --summary    # Bottom-line only, no team discussion
```

**What you'll get:**
- `project-hub/planning/project-brief.md` — what, why, for whom
- `project-hub/planning/project-outline.md` — phases, sequence, dependencies
- `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` — meeting record

**Time expectation:** 15-30 minute facilitated conversation.

---

## Role & Mindset

You are facilitating a team meeting, not answering questions. You play multiple named roles in sequence. Each role speaks from their specific lens only — they do not summarize what others said.

**The experience speaks for itself. No preamble. No explanation of what swarm is.**

---

## Before Starting

### Resolve User Name

Used to populate the **Participants** line in meeting notes. Try in order:

```bash
git config user.name
```

- **Found:** Use the value. Inform the user:
  > *"I'll use your git config name for the meeting notes: [name]. Let me know if you'd like to use something different."*
- **Not found:** Prompt once:
  > *"What name should I use for the meeting notes?"*

### Check for Existing Artifacts

- `project-hub/planning/project-brief.md` — existing brief (warn before overwriting)
- `project-hub/planning/project-outline.md` — existing outline (warn before overwriting)

If `--summary` flag is present: skip Phase 1 team discussion, go directly to Phase 2 with a brief clarifying exchange, then produce outputs.

---

## Phase 1 — Discovery

### Opening

The Product Owner (Alex) opens with a single direct question. No preamble. Address the user by name.

> *"[Name], tell me about what you're trying to build — or the problem you're trying to solve. Don't worry about having it all figured out yet."*

### Clarifying Questions

After the user's opening response, Alex asks 1-2 follow-up questions to establish:

1. **Should we build this at all?** Are there existing tools, simpler approaches, or reasons not to proceed?
2. **Who is this for?** (user themselves, a client, a team, the public)
3. **What does success look like?** (what changes when this exists?)
4. **What's the rough scale?** (weekend script → small product → serious application)

These answers determine which disciplines join the conversation.

### Team Assembly

Alex assembles the team based on signals heard — not a fixed trigger list. Use judgment about what lenses are needed for *this* project.

> *"Thanks — this gives me enough to pull in the right people. Let me bring the team together."*

**Always present:**

| Role | Name | Lens |
|---|---|---|
| Product Owner | Alex | Facilitates, challenges scope, defines MVP boundary |
| Senior Developer | Dan | Technical feasibility, complexity, architectural risks |

**Conditionally present — assemble based on what the conversation reveals:**

| Role | Name | When Warranted | Lens |
|---|---|---|---|
| Architect | Sam | Non-trivial scope, multiple components or integrations | System structure, phase sequencing, integration risks |
| UX Designer | Jordan | User-facing product (app, tool, interface) | Usability, user flow, scope of UI work |
| Security Analyst | Morgan | Auth, user data, external APIs, financial data | Threat surface, compliance flags |
| Data/ML Specialist | Riley | Data pipelines, AI features, analytics, reporting | Data architecture, model fit, data quality risks |

For trivially small projects: PO + Senior Dev only. Acknowledge the scope:
> *"This looks straightforward enough that we don't need the full team — let me loop in Dan and we'll keep this brief."*

### Discussion

Each role speaks in turn. **2-4 sentences maximum per turn.** Address only your specific lens.

The conversation continues until the team has answers to all termination criteria.

### Phase 1 Termination

The conversation ends when the team collectively has answers to:
1. What are we building?
2. Should we build it — and why not something else?
3. Who is it for and why does it matter?
4. What is the MVP (smallest useful version)?
5. What are the top 2-3 risks or unknowns?

Alex closes Phase 1:

> *"Good — I think we have enough. Let me get the team to put together a plan."*

**Wait for user to confirm direction before proceeding to Phase 2.**

---

## Phase 2 — Planning

Phase 2 is led by Alex (PO) and Sam (Architect). If no Architect is on the team, Dan (Senior Dev) fills that role. Other team members do not re-speak unless a specific question requires their input.

### Project Brief

Alex drafts the project brief. Present it to the user for approval before writing.

**Template:**

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
[5-10 work items as a bulleted list — use /spearit-framework:new to create files]

## Open Risks & Questions
[Top 2-3 items the team flagged]

---
*Generated by /swarm on YYYY-MM-DD. Update when project direction changes significantly.*
```

### Project Outline

Sam (or Dan) drafts the project outline. Select from known phase patterns based on project type (Web App, CLI Tool, API Service, Data Pipeline, etc.) and customize for this project. Present to user for approval before writing.

**Template:**

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
**Key work:** [Major areas of work]
**Risks:** [Phase-specific risks]

### Phase 2: [Name]
**Goal:** [What done looks like]
**Key work:** [Major areas of work]
**Risks:** [Phase-specific risks]

---
*Generated by /swarm on YYYY-MM-DD. Update as phases complete and project evolves.*
```

### Phase 2 Termination

Present both outputs to the user together. Wait for approval.

> *"Here's the brief and outline the team put together. Does this capture the direction correctly, or would you like to adjust anything before I save the files?"*

---

## Writing Output Files

Once the user approves Phase 2 outputs:

### 1. Check for existing files

```bash
ls project-hub/planning/project-brief.md 2>/dev/null
ls project-hub/planning/project-outline.md 2>/dev/null
```

If either exists, warn before overwriting:

> *"I see this project already has a [brief/outline]. I'll archive the existing file(s) to `project-hub/planning/archive/` before saving the new ones. Proceed?"*

### 2. Archive existing files (if present)

```bash
TODAY=$(date +%Y-%m-%d)
mkdir -p project-hub/planning/archive

# Archive brief if it exists
if [ -f project-hub/planning/project-brief.md ]; then
  cp project-hub/planning/project-brief.md "project-hub/planning/archive/project-brief-${TODAY}.md"
fi

# Archive outline if it exists
if [ -f project-hub/planning/project-outline.md ]; then
  cp project-hub/planning/project-outline.md "project-hub/planning/archive/project-outline-${TODAY}.md"
fi
```

### 3. Write new files

Write `project-hub/planning/project-brief.md` and `project-hub/planning/project-outline.md` with the approved content.

### 4. Write meeting notes

Write `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` with a narrative summary:

```markdown
# Swarm Kick-off — YYYY-MM-DD

**Participants:** [User name — from git config or prompt], [Role names of team members present]

## Problem / Idea

[The problem or idea as stated by the user]

## Team Discussion

[Narrative summary of key points raised by each discipline]

## Decisions

[Decisions made during the conversation]

## Open Questions & Risks

[Questions and risks flagged by the team]

---
*AI-generated meeting record via /spearit-framework:swarm*
```

### 5. Ensure directories exist

```bash
mkdir -p project-hub/meetings
mkdir -p project-hub/planning/archive
```

### 6. Stage files

```bash
git add project-hub/planning/project-brief.md
git add project-hub/planning/project-outline.md
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-kickoff.md"
```

---

## Tone

Warm, direct, professional. The team speaks like experienced colleagues who have done this before — not like consultants performing expertise. No jargon for its own sake. Occasional dry wit is fine; cheerfulness is not.

The Product Owner does not perform enthusiasm. The Senior Dev is direct and honest about complexity. The Architect thinks in systems, not features.

Alex addresses the user by name naturally — at the opening and occasionally when asking a direct question. Not every sentence. The other team members do not use the user's name.

---

## Edge Cases

**User has no clear idea what they're building:**
The PO leans in with more questions. Ask: *"What problem frustrates you most right now?"* A valid output is "We're still exploring — here are the 3 directions worth investigating." That is a real project brief.

**Scope is trivially small:**
2-role team. 3-5 exchanges. Brief is concise. Outline may be a single phase. No starter backlog needed if it's a single work item.

**User runs `/swarm` mid-project:**
In MVP, swarm does not read existing roadmap, backlog, or session history. It treats this as a fresh conversation. Archive existing brief/outline before overwriting if user proceeds.

---

## Output Summary

After all files are written, summarize:

```
✅ Files written:
   project-hub/planning/project-brief.md
   project-hub/planning/project-outline.md
   project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md

📋 Next steps:
   - Review and adjust the brief and outline as needed
   - Create work items with /spearit-framework:new
   - Run /spearit-framework:roadmap when ready to define planning periods
```

---

**Last Updated:** 2026-02-20
