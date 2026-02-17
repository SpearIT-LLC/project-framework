# Plugin Market Analysis - February 2026

**Research Date:** 2026-02-16
**Purpose:** Validate SpearIT Framework plugin value proposition and identify competitive landscape
**Research Method:** Web search of Claude Code plugin ecosystem, solo developer PM tools, AI-guided project management solutions
**Status:** Complete - Proceeding with plugin development

---

## Executive Summary

**Finding:** SpearIT Framework occupies a **genuine gap** in the Claude Code plugin ecosystem.

**Key Insight:** No plugins exist that combine file-based workflow with AI-guided professional practices (PM, Scrum Master, Senior Dev roles).

**Recommendation:** Continue plugin development. Reframe value proposition around "AI-guided professional practices for solo developers" rather than just "file-based workflow."

**Strategic Positioning:** Plugins are the primary product. Framework ZIP serves power users who want scripts + customization.

---

## 1. Claude Code Plugin Landscape

### Methodology
- Searched official Anthropic plugin directory
- Reviewed Claude.com plugin marketplace
- Analyzed community plugin collections (awesome-claude-plugins)
- Searched for workflow, project management, kanban, task tracking keywords

### Findings: What Exists

#### Development Workflow Plugins

**1. Deep Trilogy (71,580 installs)**
- **Commands:** `/deep-project`, `/deep-plan`, `/deep-implement`
- **Focus:** Transform vague ideas → structured implementation plans
- **Strength:** One-time planning and decomposition
- **Gap:** No ongoing project management, no work item tracking
- **Source:** [The Deep Trilogy: Claude Code Plugins for Writing Good Software, Fast](https://pierce-lamb.medium.com/the-deep-trilogy-claude-code-plugins-for-writing-good-software-fast-33b76f2a022d)

**2. Feature Dev**
- **Focus:** Feature development workflow with agents for exploration, design, review
- **Strength:** Single feature lifecycle management
- **Gap:** No backlog management, no multi-feature coordination
- **Source:** [Plugins for Claude Code and Cowork | Anthropic](https://claude.com/plugins)

**3. PR Review Toolkit**
- **Focus:** Comprehensive PR review with 5+ specialized agents
- **Strength:** Code quality and review automation
- **Gap:** No project-level tracking or planning
- **Source:** [Create plugins - Claude Code Docs](https://code.claude.com/docs/en/plugins)

**4. Commit Commands (47,422 installs)**
- **Focus:** Git commit workflows (commit, push, PR creation)
- **Strength:** Developer workflow automation
- **Gap:** No strategic planning or work item management
- **Source:** [Plugins for Claude Code and Cowork | Anthropic](https://claude.com/plugins)

#### External Tool Integration

**5. Linear Plugin (Product Management)**
- **Focus:** Direct integration with Linear issue tracker
- **Capabilities:** Pull tickets, update status, manage issues
- **Target:** Teams already using Linear ($8-15/user/month SaaS)
- **Gap:** Solo developers not paying for external tools
- **Source:** [Product Management – Claude Plugin | Anthropic](https://claude.com/plugins/product-management)

**6. Linear Workflow Integration (24 skills)**
- **Focus:** Complete Linear integration skill pack
- **Covers:** Issue tracking, project management, workflows, team collaboration
- **Gap:** Requires Linear subscription, not file-based
- **Source:** [GitHub - shinpr/claude-code-workflows](https://github.com/shinpr/claude-code-workflows)

#### Visualization Tools (External, Not Official Plugins)

**7. Vibe Kanban**
- **Type:** Web-based AI agent orchestrator
- **Supports:** Claude Code, Gemini CLI, Cursor, Amp, OpenAI Codex
- **Strength:** Visual kanban board for multiple AI agents
- **Gap:** Visualization layer only, no methodology or guidance
- **Source:** [Vibe Kanban - Orchestrate AI Coding Agents](https://www.vibekanban.com/)

**8. Backlog.md**
- **Type:** Markdown-native task manager + Kanban visualizer
- **Strength:** File-per-issue, Git-friendly, MCP compatible
- **Gap:** Task tracking only, no AI-guided professional practices
- **Source:** [GitHub - MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md)

**9. Claude-ws (Claude Workspace)**
- **Type:** Web-based management system for Claude Code CLI
- **Features:** Kanban board, code editor, Git integration, SQLite database
- **Strength:** Visual interface for Claude Code sessions
- **Gap:** Visualization and session management, not project methodology
- **Source:** [GitHub - Claude-Workspace/claude-ws](https://github.com/Claude-Workspace/claude-ws)

**10. Claude Code Kanban Automator**
- **Type:** AI-powered Kanban task management system
- **Features:** Task automation, visual project management
- **Gap:** Task execution automation, not strategic guidance
- **Source:** [GitHub - cruzyjapan/Claude-Code-Kanban-Automator](https://github.com/cruzyjapan/Claude-Code-Kanban-Automator)

### Findings: What DOESN'T Exist

**Critical Gaps in Claude Code Ecosystem:**

✅ **File-based workflow methodology** - No plugins teach/enforce file-based project structure
✅ **AI-guided professional practices** - No PM/Scrum Master/Senior Dev role personas
✅ **Standalone workflow for solo developers** - All tools require external services or complex setup
✅ **Work item lifecycle management** - No backlog → todo → doing → done with policy enforcement
✅ **Git-integrated project management** - No plugins use `git mv` or enforce version control practices
✅ **Strategic planning commands** - No roadmap creation, retrospectives, or session history
✅ **Zero-dependency project management** - All alternatives require external tools, databases, or web UIs

**Official Directory Analysis:**
> "Based on available plugins listed, **none explicitly focus on project management, task tracking, kanban boards, backlog management, or planning workflows**."
>
> "The directory emphasizes code-focused plugins (design, review, testing, debugging) rather than project orchestration tools."

---

## 2. Solo Developer Project Management Tools

### Market Trends (2026)

**Key Finding:**
> "Many solo developers are adopting markdown-based approaches integrated with Git, combining task management directly into the coding environment to minimize context switches and maintain productivity."
>
> — [Solo Developer Project Management Systems 2025](https://apatero.com/blog/solo-developer-project-management-systems-2025)

**Best Practice Identified:**
> "Effective systems use simple tools that don't add overhead, such as plain text files, lightweight task managers, or physical notebooks, while avoiding tools designed for team collaboration."

### Popular Tools for Solo Developers

**1. Obsidian**
- **Approach:** Local-first markdown with powerful linking
- **Cost:** Free for personal use
- **Strength:** Flexible, extensible, developer-friendly
- **Gap:** No AI guidance, no methodology enforcement
- **Source:** [Solo Developer PM Systems 2025](https://apatero.com/blog/solo-developer-project-management-systems-2025)

**2. Imdone**
- **Approach:** Single source of truth, file-per-issue in editor
- **Strength:** Editor integration, Git-friendly
- **Gap:** Task tracking only, no strategic planning
- **Source:** [Imdone - Work Jira like code!](https://imdone.io/)

**3. Markdown Projects**
- **Approach:** File-per-issue storage, clean diffs, meaningful merge conflicts
- **Strength:** Natural branch-based workflows
- **Gap:** No AI assistance, manual organization
- **Source:** [Markdown Projects](https://www.markdownprojects.com/)

**4. Taskade (AI-powered)**
- **Approach:** Lightweight PM with AI agents for automation
- **Cost:** Free plan available
- **Strength:** AI agent feature for repetitive tasks
- **Target:** Individuals or smaller remote teams
- **Gap:** External tool, not integrated with development workflow
- **Source:** [Solo Developer PM Systems 2025](https://apatero.com/blog/solo-developer-project-management-systems-2025)

**5. Roo Commander (MDTM - Markdown-Driven Task Management)**
- **Approach:** File-based task management, structured text files in repo
- **Strength:** Single source of truth within project repository
- **Gap:** No AI guidance beyond basic task tracking
- **Source:** [Core Concept: Markdown-Driven Task Management](https://github.com/jezweb/roo-commander/wiki/02_Core_Concepts-03_MDTM_Explained)

### Market Validation

**Evidence of Demand:**
- Deep Trilogy: **71,580 installs** (structured planning)
- Commit Commands: **47,422 installs** (workflow automation)
- Ralph Loop: **59,171 installs** (iterative development)

**Interpretation:** Claude Code users want structure, methodology, and AI-guided workflows. They install plugins that provide professional practices.

---

## 3. AI-Guided Project Planning Landscape

### Enterprise/Team Tools

**Key Finding:**
> "Organizations implementing AI-assisted agile tools report up to 40% faster release cycles and a 35% reduction in planning overhead."
>
> — [The Best AI-Assisted Sprint Planning Tools](https://www.zenhub.com/blog-posts/the-7-best-ai-assisted-sprint-planning-tools-for-agile-teams-in-2025)

**Popular Tools:**
1. **Monday Dev** - Goals, epics, sprints, capacity, AI-powered insights
2. **Miro** - Visual collaboration with AI sprint planning
3. **Jira** - AI-assisted suggestions, capacity forecasting
4. **Taskade** - AI sprint planning generator

**Gap Identified:** All tools target **teams** (5+ people) and require external services. No AI-guided planning for **solo developers** using file-based workflows.

### AI Capabilities in PM Tools

**Common Features:**
- Capacity forecasting (predict workloads from historical velocity)
- Smart assignments (match tasks to people automatically)
- Risk detection (flag potential blockers)
- Sprint optimization suggestions

**SpearIT Opportunity:** Bring these AI capabilities to solo developers WITHOUT team collaboration overhead or external dependencies.

---

## 4. SpearIT Framework Original Value Hypothesis

### Problem Statements (From FEAT-118, 2026-02-08)

**Problem 1: Framework Not Discoverable** ✅ Still Valid
- Framework has zero external users (5 versions internally)
- No presence in Claude Code plugin ecosystem
- Plugin marketplace is the official distribution channel

**Problem 2: No Validated Demand** ✅ Still Valid
- Built in isolation without external user feedback
- Need to test market before investing in comprehensive features
- Plugin is low-risk validation mechanism

**Problem 3: High Barrier to Try** ✅ Still Valid
- Full framework requires project restructuring
- No lightweight "try before you commit" option
- Users with existing projects can't easily test workflow

**Problem 4: Internal Use Could Be Better** ✅ Still Valid
- Plugin would improve SpearIT internal workflow
- Commands would work across multiple projects
- Polishing for external use raises internal quality

### Target Audience

**Primary:** SpearIT Solutions (internal use, improved tooling)
**Secondary:** Solo developers and small teams using Claude Code
**Tertiary:** Claude Code community seeking lightweight project management

### Risk Profile: LOW

**Critical Insight:**
> "Framework will continue to be used internally regardless of external adoption. External users are bonus, not requirement. Plugin serves dual purpose: external distribution + internal tool refinement."

**Interpretation:** Already have ONE paying customer (SpearIT). External adoption is validation, not survival requirement.

---

## 5. Competitive Differentiation

### Value Proposition Matrix

| Feature | SpearIT Framework | Linear Plugin | Obsidian | Deep Trilogy | Vibe Kanban |
|---------|------------------|---------------|----------|--------------|-------------|
| **File-based** | ✅ | ❌ (SaaS) | ✅ | ❌ | ❌ (Web UI) |
| **Zero external deps** | ✅ | ❌ ($8-15/mo) | ✅ | ✅ | ❌ |
| **AI-guided planning** | ✅ | ❌ | ❌ | ⚠️ (one-time) | ❌ |
| **Ongoing PM** | ✅ | ✅ | ⚠️ (manual) | ❌ | ❌ |
| **Role personas** | ✅ (PM/SM/Dev) | ❌ | ❌ | ❌ | ❌ |
| **Git integration** | ✅ (git mv) | ❌ | ❌ | ❌ | ❌ |
| **Methodology** | ✅ | ⚠️ (assumes Linear) | ❌ | ⚠️ (planning only) | ❌ |
| **Works in any project** | ✅ | ✅ | ✅ | ✅ | ✅ |

**Legend:**
- ✅ = Full support
- ⚠️ = Partial support
- ❌ = Not supported

### Positioning Statement

**SpearIT Project Framework:**
> "AI-guided professional project practices for solo developers. Get PM, Scrum Master, and Senior Dev expertise without hiring a team—using file-based workflow that lives in your codebase."

**Differentiation:**
- **vs Linear Plugin:** No $8/month SaaS required. Files live in your repo.
- **vs Obsidian/Imdone:** AI guidance for professional practices, not just task tracking.
- **vs Deep Trilogy:** Ongoing project management, not one-time planning.
- **vs Vibe Kanban:** Methodology and guidance, not just visualization.

**Target Market:**
- Solo developers who want professional structure without process overhead
- 2-3 person teams not ready for Jira/Linear
- Developers who prefer file-based, version-controlled workflows
- Claude Code users seeking integrated project management

---

## 6. Strategic Insights

### Insight 1: Plugin Ecosystem Gap

**Finding:** Official Anthropic plugin directory has ZERO project management methodology plugins.

**Opportunity:** First-mover advantage in "AI-guided PM for solo developers" category.

**Risk:** Low. Even if competitors emerge, you have differentiated approach (file-based + role personas + methodology).

### Insight 2: AI Guidance Is the Differentiator

**User quote from research:**
> "You're not just distributing a framework template anymore, you're building **tools** (commands) that bring framework capabilities into Claude Code as first-class features."

**Realization:** Value isn't "file-based workflow" (Obsidian has that). Value is **AI embodying professional roles** (PM, Scrum Master, Senior Dev) to guide solo developers.

**Commands that differentiate:**
- `/roadmap` - AI as Strategic PM (theme identification, planning periods)
- `/session-history` - AI as Documentation Lead (structured session capture)
- `/backlog` - AI as Product Owner (prioritization, grooming)
- `/new` - AI as Scrum Master (work item creation, breakdown)

### Insight 3: Framework vs Plugin Positioning

**Question:** "Is the framework the PRO version?"

**Answer:** No. Reframe:

**Current Model:**
- Plugin = Gateway → Framework = Comprehensive

**Recommended Model:**
- Plugin = Primary Product → Framework = Reference Implementation

**Rationale:**
- Most users will use plugins (zero setup)
- Framework ZIP serves two purposes:
  1. Power users who want scripts for speed
  2. Existing codebases that need framework integration
- Both maintained together (plugins ARE framework commands, packaged differently)

### Insight 4: The Scripts vs AI Speed Trade-off

**Tension Identified:**
> "Users will lose interest and possibly uninstall the plugin if it's too slow."

**Performance Reality:**
- TECH-135 optimized move command: 38s → 16s (58% improvement)
- Architectural ceiling reached (AI interpretation overhead)
- Scripts would be instant, but require framework setup

**Strategic Response:**

**Option A: Accept Speed Trade-off**
- Position plugin value as "correctness + guidance" not "speed"
- Users tolerate 10-15s because AI enforces rules, uses git mv, validates policies
- Target: Learning phase, strategic planning, complex decisions

**Option B: Hybrid Model**
- Plugins for strategic work (roadmap, session-history, new work items)
- Framework scripts for repetitive work (rapid-fire moves, status checks)
- User journey: Plugin → Learn workflow → Graduate to scripts when volume increases

**Option C: Performance Improvements**
- Wait for faster Claude models (6-12 months)
- Optimize command instructions (already done in TECH-135)
- Accept current speed as "good enough"

**Recommendation:** Option B (Hybrid Model)
- Plugins are not the end state, they're the onboarding path
- Week 1-4: Learn workflow with plugin (slow is OK)
- Month 2+: Graduate to framework scripts for daily use
- Plugin remains valuable for strategic commands (roadmap, planning)

---

## 7. Market Validation Evidence

### Positive Indicators

**1. Related Plugin Success**
- Deep Trilogy: 71k installs (AI-guided planning)
- Commit Commands: 47k installs (workflow automation)
- Ralph Loop: 59k installs (iterative development)

**Interpretation:** Claude Code users install plugins that provide structure and professional practices.

**2. Solo Developer PM Tool Adoption**
> "The trend shows solo developers increasingly favoring file-based, version-control-friendly systems that keep project management within their editor workflows rather than external tools."

**Interpretation:** Your file-based approach aligns with market trend.

**3. AI Planning Tool Growth**
> "Organizations implementing AI-assisted agile tools report up to 40% faster release cycles and a 35% reduction in planning overhead."

**Interpretation:** AI guidance has proven value in enterprise. Opportunity to bring to solo developers.

**4. Internal Validation**
- SpearIT using framework across multiple projects
- Framework evolved through real project use (HPC Job Queue Prototype)
- 5 major versions over 2 months (Dec 2025 - Feb 2026) proves active use

**Interpretation:** Real problem being solved, not theoretical.

### Risk Factors

**1. Unvalidated External Demand**
- Zero external users currently
- Plugin is first public test of market
- Risk: Solo developers may not value professional structure

**Mitigation:** Low-risk test (plugin already built), internal use provides baseline value

**2. Plugin Speed Perception**
- 16s for move command may feel slow
- Users accustomed to instant CLI tools
- Risk: Poor reviews due to performance, not value

**Mitigation:** Clear positioning (guidance > speed), hybrid model (scripts available), wait for faster models

**3. Market Education Required**
- Solo developers may not understand value of PM practices
- "I don't need a Scrum Master, I'm just one person"
- Risk: Value proposition not immediately obvious

**Mitigation:** Strong documentation, clear examples, focus on outcomes (focused projects, less rework, better decisions)

---

## 8. Recommended Strategic Direction

### Primary Recommendation: Continue Plugin Development

**Rationale:**
1. ✅ Genuine gap exists (no direct competitors)
2. ✅ Market trends align (file-based, AI-guided, integrated workflows)
3. ✅ Internal validation (SpearIT actively using)
4. ✅ Low risk (already built, external users are bonus)
5. ✅ First-mover advantage (official directory has nothing similar)

### Positioning Refinement

**Old Positioning (FEAT-118):**
> "File-based workflow and AI collaboration partner for solo developers"

**New Positioning (Recommended):**
> "AI-guided professional project practices for solo developers. Get PM, Scrum Master, and Senior Dev expertise without hiring a team."

**Why Change:**
- "File-based workflow" is a feature, not a benefit
- Competitors have file-based (Obsidian, Imdone)
- **AI-guided professional practices** is the unique value
- Emphasizes outcome (professional structure) over mechanism (files)

### Product Strategy

**Light Plugin (v1.0 - Shipped)**
- **Purpose:** Onboarding and workflow discovery
- **Commands:** help, new, move (3 core)
- **Target:** Solo developers trying framework for first time
- **Positioning:** "Try professional workflow in 5 minutes"

**Full Plugin (v1.0 - In Progress, 75% Complete)**
- **Purpose:** Complete AI-guided project management
- **Commands:** help, new, move, session-history, roadmap (5 total)
- **Target:** Users who've adopted workflow, want strategic planning
- **Positioning:** "Complete project management suite for power users"

**Framework ZIP (v5.1.0 - Maintained)**
- **Purpose:** Power users + existing codebase integration
- **Includes:** All commands + PowerShell scripts + full documentation
- **Target:** Daily workflow workhorse (speed via scripts), teams wanting customization
- **Positioning:** "Full control + customization for professionals"

### Roadmap Theme Recommendation

**Current Themes (From Feb 4 ROADMAP.md):**
1. Distribution & Onboarding
2. Workflow
3. Project Guidance
4. Developer Guidance

**Plugin Work Fits Into Existing Themes:**
- **Distribution & Onboarding:** Plugin IS a distribution mechanism
- **Workflow:** Plugin commands (new, move) implement workflow
- **Project Guidance:** Plugin commands (roadmap, session-history) provide guidance

**No New Theme Required:** Plugins are HOW you deliver WHAT you build (themes describe what, not how).

---

## 9. Open Questions for Roadmap Creation

### Question 1: What Is the Framework's Future Role?

**Options:**
- **A)** Plugins are the future, framework is legacy (maintenance only)
- **B)** Framework is PRO version, plugins are freemium (both get investment)
- **C)** Framework and plugins serve different needs (both stay free, both maintained)
- **D)** Framework becomes reference implementation (plugins are primary product)

**Recommendation:** Option D
- Plugins are primary (most users, marketplace distribution)
- Framework serves power users (scripts for speed, customization for teams)
- Maintain ONE codebase, package TWO ways

### Question 2: How Does Small Team Growth Work?

**Identified Gap:**
> "Small teams or larger are most likely going to be using Jira, or similar. Not file based. The Pro version would have to have Jira (and other system) integrations before it would be considered as a viable product."

**Strategic Question:** What team size stops using file-based?
- 2 people: File-based works
- 3 people: File-based still works?
- 5 people: Need Jira integration?
- 10 people: Definitely need external tool

**Options:**
- **A)** Target only solo developers (1 person)
- **B)** Target solo + pairs (1-2 people)
- **C)** Target small teams (1-5 people, accept file-based limitation)
- **D)** Build Jira integration for larger teams (future)

**Recommendation:** Option C (1-5 people)
- Don't chase enterprise market (requires integrations, support overhead)
- Small teams (2-5 people) can use file-based with Git coordination
- Future: If demand emerges, consider Jira integration (separate work item)

### Question 3: Should Performance Drive Roadmap?

**Context:** Plugin commands are 10-15s. Scripts are instant.

**Strategic Question:** Prioritize performance improvements?

**Options:**
- **A)** Invest in performance optimizations (architectural changes, caching)
- **B)** Wait for faster Claude models (6-12 months)
- **C)** Accept current speed, position as "guidance > speed"
- **D)** Hybrid model (plugin for strategy, scripts for speed)

**Recommendation:** Option D (Hybrid)
- Plugin for learning + strategic work (tolerate 10-15s)
- Scripts for daily rapid work (instant moves, status checks)
- Don't invest in optimization (architectural ceiling reached per TECH-135)
- Reevaluate when Claude 5 ships (may be faster)

---

## 10. Conclusion

### Summary of Findings

**Market Gap:** ✅ Confirmed
- No Claude Code plugins for AI-guided project management methodology
- Solo developer tools focus on task tracking, not professional practices
- AI planning tools target teams (5+), not solo developers

**Competitive Advantage:** ✅ Strong
- File-based (version controlled, zero dependencies)
- AI role personas (PM, Scrum Master, Senior Dev guidance)
- Methodology + tooling (not just tasks, but HOW to organize)
- Integrated workflow (Claude Code native, not external tool)

**Value Proposition:** ✅ Validated
- Internal use at SpearIT (real problem being solved)
- Market trends align (file-based, AI-guided, integrated)
- Related plugins show demand (Deep Trilogy: 71k installs)

**Risk:** ✅ Low
- Primary customer is SpearIT (internal use)
- External adoption is bonus, not survival
- Plugin already built (light v1.0 shipped, full v1.0 at 75%)

### Go/No-Go Decision

**Recommendation: GO**

**Proceed with:**
1. Complete Full Plugin (FEAT-127.4 remaining)
2. Submit both plugins to Anthropic marketplace
3. Create roadmap positioning plugins as primary product
4. Maintain framework ZIP as power-user option
5. Validate market via plugin adoption metrics

**Do NOT:**
1. Chase enterprise market (Jira integrations, team collaboration)
2. Over-invest in performance (architectural ceiling reached)
3. Abandon framework (power users need scripts)
4. Pivot to external tool integrations (dilutes unique value)

### Success Metrics

**6-Month Goals (Aug 2026):**
- Light plugin: 500+ installs (validation of basic workflow)
- Full plugin: 100+ installs (validation of strategic features)
- 5+ external users providing feedback (community engagement)
- SpearIT continues internal use (internal value maintained)

**12-Month Goals (Feb 2027):**
- Light plugin: 2,000+ installs
- Full plugin: 500+ installs
- 20+ external users actively using
- Feature requests and GitHub issues validate market fit
- Decision point: Scale up or maintain as internal tool with community sharing

---

## 11. Related Documents

### Framework Internal Documents
- [FEAT-118: Light Plugin Work Item](../history/releases/plugin-light/v1.0.0/FEAT-118-claude-code-plugin.md)
- [FEAT-127: Full Plugin Epic](../work/doing/FEAT-127-full-framework-plugin.md)
- [TECH-135: Move Command Optimization](../work/archive/TECH-135-optimize-move-command-performance.md)
- [Project Status](../../framework/PROJECT-STATUS.md)
- [Current Roadmap](../../framework/docs/project/ROADMAP.md)

### Plugin Development Research
- [Plugin Anthropic Standards](./plugin-anthropic-standards.md)
- [Plugin Best Practices](./plugin-best-practices.md)
- [Plugin Testing Summary](./plugin-testing-summary.md)

### Session Histories
- [2026-02-03: Plugin Development](../history/sessions/2026-02-03-SESSION-HISTORY.md)
- [2026-02-04: Roadmap Creation](../history/sessions/2026-02-04-SESSION-HISTORY.md)
- [2026-02-08: Plugin Launch](../history/sessions/2026-02-08-SESSION-HISTORY.md)

---

## 12. External Sources

### Claude Code Plugin Research
- [Create plugins - Claude Code Docs](https://code.claude.com/docs/en/plugins)
- [GitHub - anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)
- [Plugins for Claude Code and Cowork | Anthropic](https://claude.com/plugins)
- [The Deep Trilogy: Claude Code Plugins for Writing Good Software, Fast](https://pierce-lamb.medium.com/the-deep-trilogy-claude-code-plugins-for-writing-good-software-fast-33b76f2a022d)
- [Product Management – Claude Plugin (Linear) | Anthropic](https://claude.com/plugins/product-management)
- [GitHub - shinpr/claude-code-workflows](https://github.com/shinpr/claude-code-workflows)

### Solo Developer PM Tools
- [Solo Developer Project Management Systems 2025 | Apatero Blog](https://apatero.com/blog/solo-developer-project-management-systems-2025)
- [Refining the Flow: Markdown/Git-Based Task Management](https://pankajpipada.com/posts/2024-08-13-taskmgmt-2/)
- [Imdone - Work Jira like code!](https://imdone.io/)
- [Markdown Projects](https://www.markdownprojects.com/)
- [Core Concept: Markdown-Driven Task Management (MDTM)](https://github.com/jezweb/roo-commander/wiki/02_Core_Concepts-03_MDTM_Explained)

### Kanban/Workflow Tools
- [Vibe Kanban - Orchestrate AI Coding Agents](https://www.vibekanban.com/)
- [GitHub - MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md)
- [GitHub - Claude-Workspace/claude-ws](https://github.com/Claude-Workspace/claude-ws)
- [GitHub - cruzyjapan/Claude-Code-Kanban-Automator](https://github.com/cruzyjapan/Claude-Code-Kanban-Automator)
- [GitHub - L1AD/claude-task-viewer](https://github.com/L1AD/claude-task-viewer)

### AI Project Management
- [The Best AI-Assisted Sprint Planning Tools for Agile Teams | Zenhub Blog](https://www.zenhub.com/blog-posts/the-7-best-ai-assisted-sprint-planning-tools-for-agile-teams-in-2025)
- [AI Sprint Planning Generator | Taskade](https://www.taskade.com/generate/project-management/sprint-planning)
- [Roadmapping for dev teams: The complete guide for 2026](https://monday.com/blog/rnd/roadmapping/)
- [AI Sprint Planning: Build Sprint Tables with Miro AI](https://miro.com/ai/ai-sprint-planning/)

---

**Research Complete:** 2026-02-16
**Decision:** Proceed with plugin development and roadmap creation
**Next Steps:** Create updated roadmap reflecting plugin-first strategy
