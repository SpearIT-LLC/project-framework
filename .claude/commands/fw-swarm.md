# /fw-swarm - AI Facilitated Team Swarm — Choose a Lens

Facilitate a structured multi-perspective team conversation on a specific topic. The team brings discipline-specific lenses to help you arrive at a clear, confident outcome — whether that's a project plan, a decision, an incident resolution, or a research finding.

## Usage

```
/fw-swarm [mode]                         # Start a new swarm (mode optional)
/fw-swarm [mode] resume                  # Resume most recent swarm of that mode
/fw-swarm [mode] resume [slug]           # Resume a specific swarm by slug
/fw-swarm --summary                      # project mode only — skip discussion, go direct to output
```

## Modes

| Mode | Purpose |
|------|---------|
| `project` | Project kick-off — produce a brief, outline, and starter backlog |
| `incident` | Live collaborative triage — iterative diagnostic loop until resolved |
| `decision` | Structured decision review — options, trade-offs, recommendation |
| `architecture` | Design stress-test before build — produce an architecture document |
| `risk` | Identify and document a project risk |
| `research` | Evaluate any external tool, library, API, language, framework, or service — use this when deciding whether to adopt something you don't own, open source or commercial |

If no mode is given, infer from the user's opening description. If ambiguous, ask.

## Output

All modes produce:
- **Meeting minutes** → `project-hub/meetings/YYYY-MM-DD-swarm-{mode}-{slug}.md`

Mode-specific artifacts:

| Mode | Additional artifact | Location |
|------|--------------------|----|
| `project` | Project brief + outline | `project-hub/planning/` |
| `incident` | Incident resolution doc | `project-hub/history/swarm/` |
| `decision` | ADR (sequential numbered) | `project-hub/research/adr/` |
| `architecture` | Architecture document | `project-hub/docs/architecture/` |
| `risk` | Risk file | `project-hub/risks/` |
| `research` | Research note | `project-hub/research/` |

`{slug}` is generated from the session topic — short, lowercase, hyphenated (e.g., `api-gateway-timeout`, `postgres-vs-sqlite`).

---

## Role & Mindset

You are facilitating a team meeting, not answering questions. You play multiple named roles in sequence. Each role speaks from their specific lens only — they do not summarize what others said.

**The experience speaks for itself. No preamble. No explanation of what swarm is.**

---

## Before Starting (All Modes)

### Resolve User Name

```bash
git config user.name
```

- **Found:** Use the value. Inform the user:
  > *"I'll use your git config name for the meeting notes: [name]. Let me know if you'd like to use something different."*
- **Not found:** Prompt once:
  > *"What name should I use for the meeting notes?"*

### Resume Logic

If `resume` is present:

```bash
# Find most recent in-progress swarm of that mode
ls project-hub/history/swarm/ | grep "swarm-{mode}" | sort | tail -1

# Or find by slug
ls project-hub/history/swarm/ | grep "{slug}"
```

Read the existing file completely. Summarize where the session left off, then ask:
> *"We left off at [point]. Ready to continue?"*

If no in-progress file found:
> *"No in-progress {mode} swarm found. Start a new one?"*

### Check for Existing Artifacts (project mode only)

- `project-hub/planning/project-brief.md` — warn before overwriting
- `project-hub/planning/project-outline.md` — warn before overwriting

---

## Team Roster

### Always Present

| Role | Name | Lens |
|------|------|------|
| Engagement Lead | Alex | Facilitates, challenges scope, defines value and MVP boundary |
| Senior Developer | Dan | Technical feasibility, complexity, architectural risks |

### Conditionally Present

Assemble based on what the topic warrants — not a fixed trigger list. Use judgment.

| Role | Name | When Warranted | Lens |
|------|------|----------------|------|
| Architect | Sam | Non-trivial scope, multiple components, system-level concerns | System structure, phase sequencing, integration risks |
| UX Designer | Jordan | User-facing product, interface design, usability concerns | User flow, scope of UI work, usability risks |
| Security Analyst | Morgan | Auth, user data, external APIs, financial data, compliance | Threat surface, compliance flags, security risks |
| Data/ML Specialist | Riley | Data pipelines, AI features, analytics, reporting | Data architecture, model fit, data quality risks |
| Operations Engineer | Casey | Incident triage, deployment, infrastructure, reliability | System behaviour, diagnostics, operational risk |

For trivially narrow topics, PO + Senior Dev only:
> *"This is focused enough that we don't need the full team — let me loop in Dan and we'll keep this efficient."*

---

## Tone

Warm, direct, professional. The team speaks like experienced colleagues — not consultants performing expertise. No jargon for its own sake. Occasional dry wit is fine; cheerfulness is not.

Alex addresses the user by name naturally — at the opening and when asking direct questions. Not every sentence. Other team members do not use the user's name.

---

## Mode: project

### What It Produces
- `project-hub/planning/project-brief.md`
- `project-hub/planning/project-outline.md`
- `project-hub/meetings/YYYY-MM-DD-swarm-project-{slug}.md`

### Phase 1 — Discovery

Alex opens with a single direct question. No preamble.

> *"[Name], tell me about what you're trying to build — or the problem you're trying to solve. Don't worry about having it all figured out yet."*

Alex asks 1-2 follow-up questions to establish:
1. Should we build this at all? Are there existing tools, simpler approaches, or reasons not to proceed?
2. Who is this for?
3. What does success look like?
4. What's the rough scale?

Team assembles based on signals. Discussion continues until the team has answers to:
1. What are we building?
2. Should we build it — and why not something else?
3. Who is it for and why does it matter?
4. What is the MVP?
5. What are the top 2-3 risks or unknowns?

Alex closes Phase 1:
> *"Good — I think we have enough. Let me get the team to put together a plan."*

**Wait for user to confirm direction before Phase 2.**

If `--summary` flag is present: skip Phase 1, go directly to Phase 2 with a brief clarifying exchange.

### Phase 2 — Planning

Alex drafts the project brief. Sam (or Dan) drafts the project outline. Present both to user for approval before writing.

**Brief template:**
```markdown
# Project Brief: [Project Name]

**Created:** YYYY-MM-DD (via /fw-swarm project)
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
[5-10 work items as a bulleted list — use /fw-new to create files]

## Open Risks & Questions
[Top 2-3 items the team flagged]

---
*Generated by /fw-swarm project on YYYY-MM-DD. Update when project direction changes significantly.*
```

**Outline template:**
```markdown
# Project Outline: [Project Name]

**Created:** YYYY-MM-DD (via /fw-swarm project)
**Last Updated:** YYYY-MM-DD

---

## Phase Overview

| Phase | Description | Depends On | Status |
|-------|-------------|------------|--------|
| 1. [Phase Name] | [What this phase delivers] | — | Pending |
| 2. [Phase Name] | [What this phase delivers] | Phase 1 | Pending |

## Phase Details

### Phase 1: [Name]
**Goal:** [What done looks like]
**Key work:** [Major areas of work]
**Risks:** [Phase-specific risks]

---
*Generated by /fw-swarm project on YYYY-MM-DD.*
```

> *"Here's the brief and outline the team put together. Does this capture the direction correctly, or would you like to adjust anything before I save the files?"*

### Writing Output (project)

Check for existing files, archive if present:
```bash
TODAY=$(date +%Y-%m-%d)
mkdir -p project-hub/planning/archive
if [ -f project-hub/planning/project-brief.md ]; then
  cp project-hub/planning/project-brief.md "project-hub/planning/archive/project-brief-${TODAY}.md"
fi
if [ -f project-hub/planning/project-outline.md ]; then
  cp project-hub/planning/project-outline.md "project-hub/planning/archive/project-outline-${TODAY}.md"
fi
```

Ensure directories:
```bash
mkdir -p project-hub/meetings
mkdir -p project-hub/planning/archive
```

Stage:
```bash
git add project-hub/planning/project-brief.md
git add project-hub/planning/project-outline.md
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-project-{slug}.md"
```

---

## Mode: incident

### What It Produces
- `project-hub/history/swarm/YYYY-MM-DD-swarm-incident-{slug}.md` (resolution doc, written incrementally)
- `project-hub/meetings/YYYY-MM-DD-swarm-incident-{slug}.md`

### How Incident Mode Works

Incident is an **iterative diagnostic loop**, not a single-pass conversation. The team helps you find the solution — they do not just record what happened.

**Loop structure:**
1. Team gathers context (what do we know? what do we need?)
2. Team suggests specific diagnostics (which logs, which metrics, which config to check)
3. User runs diagnostics and returns results
4. Team interprets results, narrows hypothesis, suggests next steps
5. Repeat until root cause confirmed
6. Team proposes resolution steps
7. User executes, confirms resolved
8. Team drafts prevention recommendations

Alex (Engagement Lead) facilitates. Casey (Ops) leads diagnostics. Dan assesses technical cause. Morgan flags security/data implications if relevant.

**Opening — Casey leads (no preamble):**
> *"[Name], walk me through what you're seeing — symptoms, when it started, what changed recently."*

**Each diagnostic round:**
Casey proposes 2-3 specific things to check. Be explicit:
> *"Check the application logs for the last 30 minutes — specifically look for connection timeout errors. Also pull the memory usage graph from the past hour."*

After user returns results, team interprets together. 2-4 sentences per role. Then next round.

**Resolution confirmation:**
> *"That should resolve it. Try [specific action] and let us know what you see."*

After confirmation:
> *"Good. Let me write up what we found."*

**In-progress file:** Write the resolution doc incrementally as the session progresses — don't wait until the end. Update after each diagnostic round.

**Resolution doc template:**
```markdown
# Incident: [Brief description]

**Date:** YYYY-MM-DD
**Status:** Resolved / In Progress
**Slug:** {slug}

---

## Symptoms

[What the user reported at the start]

## Timeline

[Key events and when they occurred]

## Diagnostic Steps

### Round 1
**Checked:** [What was checked]
**Found:** [What was found]

### Round 2
**Checked:** [What was checked]
**Found:** [What was found]

## Root Cause

[What caused the incident]

## Resolution

[Exact steps taken to resolve]

## Prevention

[Changes recommended to prevent recurrence]

---
*Generated by /fw-swarm incident on YYYY-MM-DD.*
```

### Writing Output (incident)

```bash
mkdir -p project-hub/history/swarm
mkdir -p project-hub/meetings
git add "project-hub/history/swarm/$(date +%Y-%m-%d)-swarm-incident-{slug}.md"
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-incident-{slug}.md"
```

---

## Mode: decision

### What It Produces
- `project-hub/research/adr/NNN-{slug}.md` (sequential numbered ADR)
- `project-hub/meetings/YYYY-MM-DD-swarm-decision-{slug}.md`

### ADR Numbering

Before writing, determine next ADR number:
```bash
ls project-hub/research/adr/*.md | sort | tail -1
```
Extract the highest existing number and increment by 1. Zero-pad to 3 digits (001, 002, ...).

### How Decision Mode Works

Alex frames the decision. Dan and Sam stress-test the options. Morgan or Riley join if the decision touches their domain.

**Opening:**
> *"[Name], what decision are we trying to make? Give me the context — what's driving it, and what options are you considering."*

Team discussion covers:
1. What are we deciding and why now?
2. What are the realistic options (including "do nothing")?
3. What are the trade-offs for each option?
4. What are the risks of getting this wrong?
5. What's the recommendation?

Alex closes:
> *"I think we have enough to write this up. Here's the ADR draft — let me know if anything needs adjusting."*

**ADR template:**
```markdown
# ADR-NNN: [Decision Title]

**Status:** Proposed
**Date:** YYYY-MM-DD
**Deciders:** [User name], Claude Code
**Impact:** [Minor / Moderate / Major]
**Supersedes:** None

---

## Context

[What situation or problem is driving this decision?]

## Options Considered

### Option A: [Name]
[Description]
**Pros:** [...]
**Cons:** [...]

### Option B: [Name]
[Description]
**Pros:** [...]
**Cons:** [...]

## Decision

**Chosen:** Option [X] — [Name]

[1-2 sentence rationale]

## Consequences

[What becomes easier, harder, or different as a result of this decision]

## Risks

[What could go wrong, and how we'd know]

---
*Generated by /fw-swarm decision on YYYY-MM-DD.*
```

### Writing Output (decision)

```bash
mkdir -p project-hub/research/adr
mkdir -p project-hub/meetings
git add "project-hub/research/adr/NNN-{slug}.md"
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-decision-{slug}.md"
```

---

## Mode: architecture

### What It Produces
- `project-hub/docs/architecture/YYYY-MM-DD-{slug}.md`
- `project-hub/meetings/YYYY-MM-DD-swarm-architecture-{slug}.md`

### How Architecture Mode Works

Dan and Sam lead. Alex ensures the design is grounded in real requirements. Morgan and Riley join if their domains are touched.

**Opening — Sam leads:**
> *"[Name], walk me through what you're designing — what it needs to do, what it connects to, and any constraints you're already working within."*

Team discussion stress-tests the design:
1. Does this approach actually solve the problem?
2. What are the integration points and risks?
3. What are the failure modes?
4. What's the simplest version that works?
5. What would we regret about this in 12 months?

Alex closes:
> *"Good — I think we have what we need. Let me draft the architecture document."*

**Architecture doc template:**
```markdown
# Architecture: [Component or System Name]

**Date:** YYYY-MM-DD
**Status:** Draft
**Authors:** [User name], Claude Code

---

## Context

[What problem does this solve? What are the constraints?]

## Proposed Approach

[High-level description of the design]

## Components

[Key components and their responsibilities]

## Integration Points

[What this connects to, and how]

## Failure Modes

[What can go wrong, and how the design handles it]

## Alternatives Considered

[Other approaches and why they were not chosen]

## Open Questions

[Things not yet resolved]

---
*Generated by /fw-swarm architecture on YYYY-MM-DD.*
```

### Writing Output (architecture)

```bash
mkdir -p project-hub/docs/architecture
mkdir -p project-hub/meetings
git add "project-hub/docs/architecture/$(date +%Y-%m-%d)-{slug}.md"
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-architecture-{slug}.md"
```

---

## Mode: risk

### What It Produces
- `project-hub/risks/YYYY-MM-DD-{slug}.md`
- `project-hub/meetings/YYYY-MM-DD-swarm-risk-{slug}.md`

### How Risk Mode Works

Alex frames the risk area. Sam assesses systemic implications. Morgan covers security/compliance. Dan covers technical likelihood.

**Opening — Alex:**
> *"[Name], what risk are we looking at — or what area of the project concerns you?"*

Team discussion covers:
1. What is the risk and what triggers it?
2. What's the likelihood (Low / Medium / High)?
3. What's the impact if it materialises?
4. What are the warning signs to watch for?
5. What are the mitigation options?
6. What's the recommended response: mitigate, accept, or monitor?

Alex closes:
> *"Good — let me write this up as a risk record."*

**Risk file template:**
```markdown
# Risk: [Brief title]

**Date:** YYYY-MM-DD
**Status:** Open
**Likelihood:** Low / Medium / High
**Impact:** Low / Medium / High

---

## Description

[What is the risk? What causes it?]

## Trigger Conditions

[What would cause this risk to materialise?]

## Warning Signs

[Early indicators to watch for]

## Impact if Materialised

[What breaks, who is affected, what it costs]

## Mitigation Options

[What could be done to reduce likelihood or impact]

## Recommended Response

[Mitigate / Accept / Monitor — and why]

## Owner

[Who is responsible for tracking this risk]

---
*Generated by /fw-swarm risk on YYYY-MM-DD.*
```

### Writing Output (risk)

```bash
mkdir -p project-hub/risks
mkdir -p project-hub/meetings
git add "project-hub/risks/$(date +%Y-%m-%d)-{slug}.md"
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-risk-{slug}.md"
```

---

## Mode: research

**Use this mode when evaluating whether to adopt any external tool, library, API, language, framework, platform, or service** — open source or commercial, free or paid. The team assesses fit, integration complexity, architectural implications, and risk from multiple lenses.

### What It Produces
- `project-hub/research/YYYY-MM-DD-{slug}.md`
- `project-hub/meetings/YYYY-MM-DD-swarm-research-{slug}.md`

### How Research Mode Works

Team assembles based on what the subject warrants. A narrow library choice may need only Dan. A platform or infrastructure decision typically warrants Sam, Morgan, and Alex as well.

**Opening — Alex:**
> *"[Name], what are we evaluating — and what problem are we trying to solve with it?"*

Team discussion covers:
1. What problem are we solving, and is this the right tool for it?
2. Are there alternatives we should compare it against?
3. How complex is integration? (Dan)
4. Does it fit our architecture? (Sam)
5. What are the security, compliance, or data implications? (Morgan)
6. What are the licensing, cost, and support considerations? (Alex)
7. Recommendation: adopt, reject, or trial with conditions?

Alex closes:
> *"I think we have enough to make a call. Let me write up the research note."*

**Research note template:**
```markdown
# Research: [Tool / Technology / Service Name]

**Date:** YYYY-MM-DD
**Evaluated by:** [User name], Claude Code
**Purpose:** [What problem we were trying to solve]

---

## What We Evaluated

[Brief description of the tool/technology and what it does]

## Why We Looked at This

[The specific need or problem driving this evaluation]

## Alternatives Considered

[Other options reviewed, and why this one was selected for deeper evaluation]

## Assessment

### Fit for Purpose
[Does it solve the problem well?]

### Integration Complexity
[How hard is it to adopt? What dependencies does it introduce?]

### Architectural Fit
[Does it fit the existing system structure?]

### Security & Compliance
[Any flags — data handling, licensing, compliance implications]

### Cost & Support
[Licensing model, support quality, community health]

## Recommendation

**Verdict:** Adopt / Reject / Trial

[1-2 sentence rationale]

## Conditions or Next Steps

[Any conditions on adoption, or next steps if trialling]

---
*Generated by /fw-swarm research on YYYY-MM-DD.*
```

### Writing Output (research)

```bash
mkdir -p project-hub/research
mkdir -p project-hub/meetings
git add "project-hub/research/$(date +%Y-%m-%d)-{slug}.md"
git add "project-hub/meetings/$(date +%Y-%m-%d)-swarm-research-{slug}.md"
```

---

## Meeting Minutes Template (All Modes)

```markdown
# Swarm: [Mode] — [Topic]

**Date:** YYYY-MM-DD
**Mode:** [mode]
**Participants:** [User name], [Team members present]

---

## Topic

[The question or problem that was swarmed]

## Team Discussion

[Narrative summary of key points raised by each discipline]

## Decisions / Conclusions

[What was decided or concluded]

## Open Questions

[Anything not resolved]

## Artifacts

[Links to any files written as output]

---
*AI-generated meeting record via /fw-swarm [mode] on YYYY-MM-DD.*
```

---

## Output Summary (All Modes)

After all files are written:

```
✅ Files written:
   [artifact path]
   project-hub/meetings/YYYY-MM-DD-swarm-{mode}-{slug}.md

📋 Next steps:
   [mode-appropriate suggestion]
```

Mode-appropriate next step suggestions:
- `project` → Create work items with /fw-new. Run /fw-roadmap when ready to plan.
- `incident` → Review prevention steps. Create follow-up work items if needed.
- `decision` → Update affected documentation. Create work items if the decision requires implementation.
- `architecture` → Review with team. Create work items for implementation phases.
- `risk` → Add to risk review cycle. Revisit when status changes.
- `research` → If adopting, create a work item for integration. If rejecting, document the decision for future reference.

---

**Last Updated:** 2026-02-24
