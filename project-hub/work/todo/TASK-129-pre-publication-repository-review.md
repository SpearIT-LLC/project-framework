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

### 2. Verify Repository Branding

**Check consistency:**
- [ ] Organization name: "SpearIT, LLC" vs "SpearIT Solutions"
- [ ] GitHub org: `SpearIT-LLC`
- [ ] Email domain: `spearit.solutions`
- [ ] Plugin links reference: `spearit-solutions` (in FEAT-118 line 233)

**Action:** Document branding standard or fix inconsistencies

### 3. Add CONTRIBUTING.md

Create basic contributing guide even if not accepting contributions yet.

**Minimal content:**
- [ ] Plugin status: v1.0.0 available via Anthropic marketplace
- [ ] Framework status: v3.0.0 in development
- [ ] Contact: Issues and feedback welcome
- [ ] Future: Detailed contributing guidelines coming

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

### 6. Tag Release Version

Tag the plugin release for submission:
- [ ] Create annotated tag: `v1.0.0-plugin`
- [ ] Tag message: "Plugin v1.0.0 - Initial marketplace submission"
- [ ] Alternative: `plugin-light-v1.0.0` for clarity

**Note:** Wait until ready to push public

### 7. Document Publication Process

Create reusable checklist for future publications:
- [ ] Create `docs/PUBLICATION-CHECKLIST.md` in project-hub
- [ ] Document all steps taken
- [ ] Include verification steps
- [ ] Reference in CONTRIBUTING.md

### 8. Final Pre-Push Verification

Before making repository public:
- [ ] README updated and reviewed
- [ ] CONTRIBUTING.md added
- [ ] Tag created
- [ ] All tests passing
- [ ] No TODO/FIXME that indicate incomplete work (acceptable: future features)
- [ ] Link URLs work (or clearly marked as future)
- [ ] Contact email valid

---

## Acceptance Criteria

- [x] README.md includes plugin installation prominently ✅
- [ ] CONTRIBUTING.md exists (even if minimal)
- [ ] Repository branding consistent
- [ ] Tag created for v1.0.0 plugin release
- [ ] Publication checklist documented for future use
- [ ] No sensitive data in repository
- [ ] Professional presentation for external users

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
