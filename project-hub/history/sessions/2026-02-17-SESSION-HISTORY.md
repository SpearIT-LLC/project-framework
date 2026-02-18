# Session History: 2026-02-17

**Date:** 2026-02-17
**Participants:** Gary Elliott, Claude Code
**Session Focus:** Roadmap Creation - Themes & Strategic Planning

---

## Summary

Resumed roadmap creation (deferred from 2026-02-16 evening session after market research). Completed housekeeping (archiving pre-plugin-era roadmap, establishing planning/ folder), then spent the session in deep strategic conversation to define the 5 project themes for the new roadmap. The session ended mid-planning-period discussion (roadmap not yet written to file).

---

## Work Completed

### Housekeeping: Roadmap Archive & Folder Setup

- Moved old roadmap (`framework/docs/project/ROADMAP.md`) → `project-hub/history/archive/ROADMAP-2026-02-04.md`
- Created `project-hub/planning/` directory (per new policy from yesterday)
- Committed: `cec52e3`

---

## Strategic Decisions Made

### 1. Five Project Themes Established (Final)

After extended exploration, locked in 5 themes for the new roadmap:

**Theme 1: Project Guidance**
- High-level, strategic, before and above the code
- AI-assembled expert team assesses ideas, assembles disciplines, ensures research and MVP definition
- The `/swarm` command lives here (kick-off meeting concept)
- Periodic reviews, retrospectives, course corrections

**Theme 2: Developer Guidance**
- Structured AI expertise at the code level
- Applies project context to code reviews, architecture, technical decisions
- Future work - builds on Project Guidance patterns once those are established
- Insight: Developers already use AI for code review, but not in a structured/contextual way

**Theme 3: Workflow**
- File-based Kanban system: work item lifecycle, policies, Kanban rules
- The foundational tracking loop everything else builds on

**Theme 4: Reporting & Visibility**
- AI-generated communication artifacts
- Session history, roadmaps, status summaries
- Key insight: "AI does a very good job summarizing information quickly, something humans are not so crazy about"
- Serves the solo IC who needs to report upward without spending an hour writing it

**Theme 5: Distribution & Onboarding**
- Plugin-first delivery, marketplace, documentation, setup experience

**Rationale for splitting Project/Developer Guidance:**
- Different altitudes: PM doesn't care about database schema; Senior Dev doesn't care about market analysis
- Different timelines: Project Guidance is now; Developer Guidance is future (post-Project MVP)
- Sequentially dependent: Can't have contextualized developer guidance without a structured project first

### 2. `/swarm` Command Concept Defined

**Concept:** A command that assembles an AI expert team appropriate to the problem - not hardcoded project types, but dynamic based on what you're building.

**Conversation flow:**
1. "Tell me about what you're trying to accomplish"
2. Clarifying questions to understand scope/complexity/stakeholders
3. "Here's who needs to be in the room..." (recommends disciplines)
4. Team conducts kick-off

**Always produces:**
- Project brief (what, for whom, why)
- Recommended structure (light/medium/full - scales to project size)
- Starter backlog (5-10 work items)
- Open risks/questions flagged by the team

**Scope:** Works for ANY new problem (software, business idea, research initiative) - not just software projects.

**MVP approach:** The kick-off meeting is the right starting point - build from the beginning of the workflow, not some middle step. Learn the pattern at project level, then adapt to Developer Guidance later.

### 3. Reporting & Visibility as Standalone Theme

**Decision:** Session history, roadmap, and status summaries get their own theme rather than folding into Workflow.

**Rationale:**
- Reporting is genuinely distinct from workflow management
- AI's speed advantage at summarization is a real user pain point solved
- "Reporting upward" use case (solo ICs contracted into larger orgs) is a key differentiator
- These are communication artifacts, not just workflow mechanics

### 4. Theme Naming Exploration

Explored playful names (historical figures: "Curie's Queries", "Turing's Ensuring", etc.) and corporate terms (PMO, CoE, Tiger Team).

**Decision:** Keep theme names professional/clear for marketplace discoverability. Put the personality in the experience itself (how `/swarm` introduces itself, how the team speaks).

---

## Decisions NOT Yet Made

### Current Planning Period (Section 2 - In Progress)

**Status:** Conversation paused at this point when session-history was invoked.

**Context established:**
- Two things in flight: FEAT-127.4 (Full Plugin build & test), Light Plugin marketplace submission
- Question posed but not answered: "Is the current period goal 'ship both plugins' or is there more to it?"

**Resume point:** Answer the planning period goal question, then define name, themes, duration, success criteria.

---

## Files Modified

- `project-hub/history/archive/ROADMAP-2026-02-04.md` - Created (moved from `framework/docs/project/ROADMAP.md`)
- `project-hub/planning/` - Directory created (empty, awaiting ROADMAP.md)

---

## Current State

### In done/ (awaiting release with epic)
- FEAT-127.1 - Full Framework Plugin Structure & Core Commands
- FEAT-127.2 - Session History Integration
- FEAT-127.3 - Roadmap Command

### In doing/
- FEAT-127 - Full Framework Plugin (parent/epic)

### In todo/
- FEAT-127.4 - Build & Testing (final step)

### Roadmap Status
- 5 themes: ✅ Approved
- Current planning period: ⏳ In progress (resume next)
- Future planning periods: ⏳ Pending
- File write: ⏳ Pending

---

## Next Steps

1. **Resume roadmap creation** - Answer planning period goal, define current period
2. **Write ROADMAP.md** → `project-hub/planning/ROADMAP.md`
3. **FEAT-127.4** - Build & test Full Plugin, version to 1.0.0
4. **Light Plugin marketplace submission** (CHORE-133)

---

## Afternoon Session - FEAT-127.4 Completion & Product Strategy

**Session Focus:** Full Plugin Build & Testing + v1.1 Roadmap Planning

### Work Completed

#### FEAT-127.4: Full Plugin Build & Testing (Complete ✅)

- Bumped `spearit-framework` plugin version: `1.0.0-dev3` → `1.0.0`
- Built production package: `distrib/plugin-full/spearit-framework-v1.0.0.zip` (29 KB, 5 commands, 3 skills)
- Published to local dev marketplace via `Publish-ToLocalMarketplace.ps1`
- Verified marketplace update picks up new version without reinstall (junction architecture confirmed)
- Moved FEAT-127.4 and FEAT-127 parent epic to done/

#### Plugin Description Refinement

- Full plugin: "Complete project management suite for power users…" → **"Project collaboration and guidance"**
- Light plugin: "AI collaboration partner to plan and organize your Kanban workflow" → **"Essential Kanban workflow"**
- Rationale: Removed redundancy ("AI" in an AI product, "inside Claude Code" in a Claude Code plugin)

### Strategic Decisions Made

#### 5. Four Product Layers Defined

Identified four distinct layers the plugin suite addresses:

| Layer | Description |
|---|---|
| **Kanban Workflow** | Foundation — both plugins. Create, move, track work items. |
| **Project Guidance** | Strategic: backlog, status, pre-flight checks. Full plugin only. |
| **Developer Guidance** | Code-level: architecture, schema review, testing, refactoring. Full plugin only. |
| **Reporting & Visibility** | Communication artifacts: session history, roadmaps, status summaries. Full plugin only. |

**Decision:** Kanban Workflow layer is complete and shared. The three guidance/reporting layers define the v1.1+ roadmap for the full plugin.

#### 6. Commands-First, Skills-Later Pattern Confirmed

**Developer Guidance vision:** Passive skill that interjects like a peer programmer ("are you sure you want to do that?") — but commands are the right MVP. Validate guidance content first, promote to ambient behavior later.

**Milestone path:**
```
v1.1  Project guidance commands
v1.2  Developer guidance commands
v1.3  claude-project.yaml (project-agnostic)
v2.0  Passive skill interception
```

#### 7. claude-project.yaml as Project-Agnostic Unlock

A lightweight config file at project root gives Claude a single place to find project conventions (work item paths, session storage, roadmap location). Enables plugin to work outside the SpearIT framework structure. Prerequisite for passive skills that need project context.

### Work Items Created

- **FEAT-137** - Project Guidance Commands (`status`, `backlog`, `plan`) — v1.1, high priority
- **FEAT-138** - Developer Guidance Commands (`review`, `refactor`, `poc`) — v1.2, depends on FEAT-137
- **FEAT-139** - `claude-project.yaml` Config — v1.3, enables any-project flexibility

### Files Modified

- `plugins/spearit-framework/.claude-plugin/plugin.json` - Version 1.0.0-dev3 → 1.0.0, description updated
- `plugins/spearit-framework-light/.claude-plugin/plugin.json` - Description updated
- `plugins/spearit-framework/CHANGELOG.md` - v1.0.0 entry added
- `distrib/plugin-full/spearit-framework-v1.0.0.zip` - Production build created

### Files Created

- `project-hub/work/backlog/FEAT-137-plugin-project-guidance-commands.md`
- `project-hub/work/backlog/FEAT-138-plugin-developer-guidance-commands.md`
- `project-hub/work/backlog/FEAT-139-claude-project-yaml-config.md`

### Files Moved

- `project-hub/work/todo/FEAT-127.4-full-plugin-build-and-test.md` → `doing/` → `done/`
- `project-hub/work/doing/FEAT-127-full-framework-plugin.md` → `done/`

### Current State

#### In done/
- FEAT-127 - Full Framework Plugin (parent epic) ✅
- FEAT-127.1 through FEAT-127.4 — all complete ✅

#### In doing/
- (empty)

#### In backlog/ (newly added)
- FEAT-137 - Project Guidance Commands
- FEAT-138 - Developer Guidance Commands
- FEAT-139 - claude-project.yaml Config

#### Roadmap Status
- `project-hub/planning/ROADMAP.md` ✅ Complete (written earlier today)
- Current period: PI MVP (targeting mid-March 2026, `/swarm` as primary deliverable)

---

---

## Evening Session - Move Command Bug Discovery & Backlog Refinement

**Session Focus:** Bug triage and backlog refinement following FEAT-127.4 completion

### Work Items Created

- **BUG-140** - Move Command: Child Item Detection Broken
  - Discovered during FEAT-127.4 cleanup when `/move FEAT-127.4 done` and `/move FEAT-136 todo` both failed
  - Root cause: `grep -v "\."` filter in move command logic is too broad — excludes child items (dot in ID) AND fires on path separators (`project-hub/work/backlog/`)
  - Workaround used: direct `git mv` commands
  - Correct fix documented in bug file: anchor the grep pattern to `/${ITEM_ID}\.` (dot after ID only)

- **FEAT-141** - Move Command: Batch Item Support
  - Enhancement to accept comma/space-separated lists of IDs in a single command
  - Intent-first parsing (Claude resolves bare numbers like `136` to full IDs)
  - Depends on BUG-140 (batch inherits the fixed per-item find logic)
  - Outputs per-item success/skip/fail summary

### Work Items Moved

- `FEAT-136` backlog → todo (Project Guidance Design Doc — next active priority; prerequisite for FEAT-137)

### Current State (End of Day)

#### In done/
- FEAT-127, FEAT-127.1, FEAT-127.2, FEAT-127.3, FEAT-127.4 — Full Framework Plugin ✅

#### In doing/
- (empty)

#### In todo/
- FEAT-092 - Sprint Support
- FEAT-136 - Project Guidance Design Doc ← **next priority**

#### In backlog/ (relevant)
- FEAT-137 - Project Guidance Commands (v1.1)
- FEAT-138 - Developer Guidance Commands (v1.2)
- FEAT-139 - claude-project.yaml Config (v1.3)
- FEAT-141 - Move Command Batch Support (depends on BUG-140)
- BUG-140 - Move Command Child Item Detection

### Next Steps

1. Fix **BUG-140** (move command) — quick fix, unblocks FEAT-141 and eliminates manual workaround
2. Write **FEAT-136** design doc — Project Guidance design (prerequisite for FEAT-137 implementation)
3. Implement **FEAT-137** - Project Guidance Commands (status, backlog, plan) for v1.1

---

---

## Late Evening Session - FEAT-136 Complete: Project Guidance Design Doc

**Session Focus:** Design document for Project Guidance theme (`/swarm` command)

### Work Completed

#### FEAT-136: Project Guidance Design Document ✅

Created `project-hub/planning/design/project-guidance.md` — full design specification for the Project Guidance theme and `/swarm` command.

### Key Design Decisions Made

#### Assembly Style
Sequential named-role discussion (not synthesized output). Each role has a human first name + title (e.g., Alex, Product Owner). 2-4 sentences per turn. Full discussion shown live by default; `--summary` flag for bottom-line-only. Meeting discussion saved as meeting notes (the "how we got there" record).

#### Output Format
Two files produced by `/swarm`:
- `project-hub/meetings/YYYY-MM-DD-swarm-kickoff.md` — meeting notes (narrative record)
- `project-hub/planning/project-brief.md` — structured project brief (official direction)

Format: meeting summary narrative wrapping a structured brief template.

#### Team Identity
Named individuals, warm professional tone. Team referred to collectively as "the Project Team" for continuity reference ("On Jan 10 the team agreed..."). Not gimmicky — personality comes from how roles speak.

#### Swarm Trigger
User decides when to run `/swarm` (MVP). Smart suggestion from other commands ("no brief found — run `/swarm`?") is Future.

#### Swarm vs. Periodic Review vs. Retrospective
- **New Swarm** = new project or significant pivot. Reestablishes direction.
- **Periodic Review** *(Future)* = same project, refine direction. Reads existing artifacts.
- **Retrospective** *(Future)* = end-of-period reflection. Looks back and learns.

#### Information Architecture Established
```
project-hub/
├── planning/
│   ├── project-brief.md     ← /swarm output (official project direction)
│   ├── ROADMAP.md
│   └── design/              ← feature design docs
├── meetings/                ← AI-generated and human meeting notes (new)
├── history/sessions/
└── work/
```

Both `project-hub/meetings/` and `project-hub/planning/design/` directories created.

#### Discipline Roster (MVP Fixed)
- **Always:** Alex (Product Owner), Dan (Senior Developer)
- **Conditional:** Jordan (UX), Morgan (Security), Riley (Data/ML), Sam (Scrum Master)
- Invocation logic: triggered by project characteristics detected during clarification

#### Backlog Culling
Captured as placeholder in design doc (Section 8). Future capability — not specced for PI MVP. Will be considered during FEAT-137 design.

### Files Created

- `project-hub/planning/design/project-guidance.md` — complete design doc (9 sections + decisions log)
- `project-hub/meetings/` — directory created (empty, ready for swarm output)

### Files Moved

- `project-hub/work/doing/FEAT-136-project-guidance-design-doc.md` → `done/`

### Current State (End of Session)

#### In done/
- FEAT-136 - Project Guidance Design Doc ✅
- FEAT-127 + all sub-items ✅

#### In doing/
- (empty)

#### In todo/
- FEAT-092 - Sprint Support

#### In backlog/
- FEAT-137 - Project Guidance Commands (v1.1) ← **next priority** (unblocked by FEAT-136)
- FEAT-138 - Developer Guidance Commands (v1.2)
- FEAT-139 - claude-project.yaml Config (v1.3)
- FEAT-141 - Move Command Batch Support (depends on BUG-140)
- BUG-140 - Move Command Child Item Detection

### Next Steps

1. Fix **BUG-140** (move command `grep -v "\."` bug) — eliminates ongoing manual workaround
2. Implement **FEAT-137** - Project Guidance Commands, starting with `/swarm`

---

**Last Updated:** 2026-02-17
