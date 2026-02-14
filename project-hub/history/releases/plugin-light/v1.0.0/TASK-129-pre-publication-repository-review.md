# TASK-129: Pre-Publication Repository Review

**Type:** TASK
**Status:** Todo
**Created:** 2026-02-13
**Updated:** 2026-02-13
**Related:** FEAT-118 (Plugin marketplace submission)
**Priority:** High

---

## Objective

Prepare the repository for public visibility by updating documentation, reviewing content, and ensuring professional presentation for external users discovering the project via the plugin marketplace.

## Context

The repository was originally created for framework development and contains internal work tracking (`project-hub/`). Before making it public for plugin submission, we need to:
1. Update README to explain both plugin AND framework
2. Ensure professional presentation for external users
3. Document the publication process for future reference

**Current state:**
- Repository: `SpearIT-LLC/project-framework` (currently private)
- Remote configured: `https://github.com/SpearIT-LLC/project-framework.git`
- Plugin ready: `spearit-framework-light` v1.0.0 (51.3 KB)
- Framework status: v3.0.0 (in development)

## Scope

### 1. Update README.md ✅ COMPLETE

Add plugin section to make it the primary entry point for new users.

**Required changes:**
- [x] Add "Quick Install (Plugin)" section at top
- [x] Explain plugin vs framework relationship
- [x] Update "What's Included" to mention plugin
- [x] Add plugin installation instructions
- [x] Clarify version strategy (plugin v1.0, framework v3.0)
- [x] Add note about `project-hub/` being development tracking

**Key message:** Plugin = easy entry point, Framework = comprehensive solution

### 2. Verify Repository Branding ✅ COMPLETE

**Branding standard documented:**
- [x] Official name: "SpearIT, LLC"
- [x] Also acceptable: "SpearIT Solutions" (informal usage)
- [x] GitHub org: `SpearIT-LLC` ✅
- [x] Email domain: `spearit.solutions` ✅
- [x] All repository URLs corrected: `https://github.com/SpearIT-LLC/project-framework`

**URLs updated:**
- [x] FEAT-118 line 237 (marketplace description)
- [x] FEAT-118 line 157 (homepage field)
- [x] Plugin CHANGELOG.md
- [x] Plugin README.md
- [x] Framework CHANGELOG.md

### 3. Add CONTRIBUTING.md ✅ COMPLETE

Created minimal contributing guide using "Model 1" approach.

**Content included:**
- [x] Project status (Plugin v1.0.0, Framework v5.1.0)
- [x] Feedback welcome (bugs, features, questions, docs)
- [x] Code contributions policy (not actively soliciting, discuss first)
- [x] Contact information (maintainer, email, repo links)
- [x] License reference (MIT)

**Approach:** Conservative "feedback welcome, code by discussion" model
- Sets clear expectations (not actively soliciting contributions)
- Professional and honest
- Easy to expand later if community grows

### 4. Review .gitignore

Verify sensitive data is excluded:
- [x] `.env` files excluded ✅
- [x] Credentials excluded ✅
- [x] Cloud configs excluded ✅
- [x] Build artifacts handled correctly ✅
- [x] Secrets directories excluded ✅

**Status:** Already comprehensive

### 5. Review Commit History

Check for any sensitive or inappropriate commits:
- [x] Recent 20 commits reviewed ✅
- [x] All professional and descriptive ✅
- [x] No sensitive data in messages ✅

**Status:** Clean

### 6. Tag Release Version ✅ COMPLETE

Tagged the plugin release for submission:
- [x] Created annotated tag: `plugin-light-v1.0.0`
- [x] Tag message includes features, package size, marketplace ready status
- [x] Format chosen: `plugin-light-v1.0.0` (reserves `plugin-vX.X.X` for future full framework plugin)

**Tag created, ready to push with repository publication**

### 7. Document Publication Process ✅ COMPLETE

Created reusable checklist for future publications:
- [x] Created `project-hub/docs/PUBLICATION-CHECKLIST.md`
- [x] Documented all review steps (7 major sections)
- [x] Included verification steps and security checks
- [x] Added rollback plan for issues
- [x] Captured lessons learned from this publication
- [x] Included post-publication monitoring steps

**Checklist covers:**
1. Documentation updates (README, CONTRIBUTING, LICENSE)
2. Repository hygiene (branding, .gitignore, commits)
3. Security & privacy (sensitive data scan)
4. Content review (accuracy, WIP, internal notes)
5. Release tagging (version tags, naming conventions)
6. GitHub settings (issues, discussions, branch protection)
7. Final verification (fresh clone, external review)

### 8. Final Pre-Push Verification

Before making repository public:
- [x] README updated and reviewed ✅
- [x] CONTRIBUTING.md added ✅
- [x] Tag created (plugin-light-v1.0.0) ✅
- [x] Plugin package tested (all 3 commands working) ✅
- [x] No TODO/FIXME indicating incomplete work ✅
- [x] GitHub URLs corrected (SpearIT-LLC) ✅
- [x] Contact email valid (gary.elliott@spearit.solutions) ✅

**Status:** All verification complete, ready for repository publication

---

## Acceptance Criteria

- [x] README.md includes plugin installation prominently ✅
- [x] CONTRIBUTING.md exists (even if minimal) ✅
- [x] Repository branding consistent ✅
- [x] Tag created for plugin-light-v1.0.0 release ✅
- [x] Publication checklist documented for future use ✅
- [x] No sensitive data in repository ✅
- [x] Professional presentation for external users ✅

**ALL ACCEPTANCE CRITERIA MET - Ready for final verification and publication**

---

## README Changes - Draft

### New Section (Insert after "What Is This?")

```markdown
## Quick Start

### For Plugin Users (Recommended)

**Want to try the workflow right now?** Install the plugin:

```bash
# Coming soon - Anthropic Marketplace
# For now, see plugin README: plugins/spearit-framework-light/
```

The **SpearIT Framework Plugin** (Lightweight Edition) gives you:
- ✅ File-based Kanban workflow (backlog → todo → doing → done)
- ✅ AI-assisted work item creation
- ✅ Workflow management with planning support
- ✅ Works in any project, no restructuring required

**Perfect for:** Quick start, existing projects, trying before committing to full framework

### For Framework Users

**Want the complete project scaffolding?** Use the full framework:

```bash
tools/Build-FrameworkArchive.ps1
# Follow setup in templates/NEW-PROJECT-CHECKLIST.md
```

The **SpearIT Framework** (Comprehensive Edition) gives you:
- ✅ Complete project templates and structure
- ✅ Documentation suite (ADRs, patterns, guides)
- ✅ All commands and workflow automation
- ✅ Research phase support
- ✅ PowerShell scripts and wrappers

**Perfect for:** New projects, comprehensive structure, team collaboration
```

### Update "What's Included" Section

```markdown
## Repository Contents

This repository contains two complementary products:

### 1. Plugin (Lightweight Edition)
- **Location:** `plugins/spearit-framework-light/`
- **Distribution:** Claude Code plugin marketplace
- **Use case:** Add workflow to existing projects
- **Entry barrier:** Very low (just install)

### 2. Framework (Comprehensive Edition)
- **Location:** `framework/`, `templates/`
- **Distribution:** Git clone or ZIP archive
- **Use case:** New projects with full scaffolding
- **Entry barrier:** Higher (project setup required)

### Development Tracking
- **Location:** `project-hub/`
- **Purpose:** Dogfooding - framework managing itself
- **Note:** Shows framework in action (feel free to explore!)
```

---

## Decision Record

**Why update README now?**
- Plugin will drive traffic to repository
- Need to explain plugin vs framework clearly
- First impression matters for marketplace success

**Why not just plugin docs?**
- Repository is source of truth
- Plugin README focuses on installation/usage
- Repo README provides context and options

**Why add CONTRIBUTING.md?**
- Shows professionalism
- Sets expectations (even if "not accepting contributions yet")
- Provides contact info for feedback

---

## Next Steps After Completion

1. Make repository public
2. Submit plugin to Anthropic marketplace (FEAT-118 Milestone 9)
3. Monitor for first external feedback
4. Iterate based on user response

---

## Notes

**About project-hub/ visibility:**
- Shows authentic dogfooding
- Demonstrates framework in action
- Transparent development process
- Separate review conversation planned

**About versioning:**
- Plugin: v1.0.0 (new product)
- Framework: v3.0.0 (mature product)
- Independent semantic versioning
- Both documented in respective PROJECT-STATUS files

---

**Created:** 2026-02-13
**Purpose:** Final repository polish before public visibility
**Timeline:** Complete before FEAT-118 Milestone 9 (marketplace submission)
