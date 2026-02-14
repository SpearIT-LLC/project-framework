# Feature: Trivial Sample Project

**ID:** FEAT-011
**Type:** Feature
**Priority:** Low
**Version Impact:** MINOR
**Created:** 2025-12-19
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 1

---

## Summary

Create a simple, complete example project demonstrating framework usage and validating basic functionality works end-to-end.

---

## Problem Statement

Users learn best from examples. Current documentation explains framework but doesn't show it in action on a trivial project.

**Current state:** HPC project is only real-world example (too complex for beginners).

---

## Requirements

- [x] Create trivial application (e.g., "Task Timer CLI" or "File Organizer")
- [x] Set up project with framework structure (project-hub/)
- [x] Create sample work items and move them through workflow (backlog → todo → doing → done)
- [x] Include at least one sample ADR in project-hub/research/adr/
- [x] Create a release (v1.0.0) and verify archival process works
- [x] Verify basic framework functionality end-to-end

---

## Implementation Notes

**Actual Project Created:** "Hello Father" CLI - PowerShell greeting application

**Location:** `C:\Temp\hello-father\`

**What Was Built:**
- PowerShell CLI module with greeting functionality
- FEAT-001: Core greeting ("Hello Father")
- FEAT-002: Timestamp in greeting output
- ADR-0001: PowerShell CLI Architecture
- Complete project-hub structure
- Release v0.2.0 with proper archival
- Full session history documenting the process

**Validation Results:** ✅ **Success**

All core framework functionality validated:
- ✅ Framework template setup works
- ✅ Work item workflow (backlog → todo → doing → done → releases)
- ✅ ADR documentation process
- ✅ Release and archival process
- ✅ Git integration
- ✅ Session history generation

---

## Issues Discovered

### 1. **Framework Tour Too Verbose**
**Severity:** Minor UX issue
**Description:** Initial framework tour was thorough but overwhelming for new users
**Impact:** Users may get information overload on first interaction
**Recommendation:** Create shorter "quick start tour" option

### 2. **Work Items Not Auto-Committed on Creation**
**Severity:** Moderate workflow issue
**Description:** When creating new work items, they are not automatically committed to git
**Impact:** Users must manually commit, risk of losing work if forgotten
**Current Behavior:** Work item created but sits as unstaged change
**Expected Behavior:** Work item should be committed when added to backlog
**Root Cause:** Claude Code system prompt says "NEVER commit unless explicitly asked"
**Recommendation:** Framework checklist should explicitly require commit after backlog creation

### 3. **/fw-move Command Performance**
**Severity:** Moderate performance issue
**Description:** /fw-move command execution is very slow
**Impact:** User experience degradation, workflow friction
**Recommendation:** Profile and optimize /fw-move skill implementation

### 4. **/fw-move to done/ Missing Auto-Actions**
**Severity:** Moderate workflow issue
**Description:** When moving work item to done/, the checklist says to auto-commit and generate session history, but this didn't happen automatically
**Impact:** User must manually run /fw-session-history and commit
**Current Behavior:** Move completes but no commit or history generation
**Expected Behavior (per checklist):**
  - Update session history using /fw-session-history
  - Commit changes automatically
**Root Cause:** Conflict between Claude Code "never auto-commit" policy and framework checklist expectations
**Note:** Session history was created manually after user feedback

### 5. **Branch Name Handling**
**Severity:** Minor compatibility issue
**Description:** Framework assumes "main" branch, but user repos may have "master"
**Resolution:** Manually renamed master → main during validation
**Decision:** Framework will REQUIRE "main" branch (documented in FEAT-107)
**Rationale:**
  - Supporting arbitrary branch names creates perpetual tension (docs, scripts, examples)
  - One-time migration cost (30 sec) vs ongoing complexity/overhead
  - Aligns with modern git standard (GitHub/GitLab/Bitbucket default)
**Implementation:**
  - Setup-Framework.ps1 detects branch name and offers automated migration
  - Document as hard requirement in system requirements (FEAT-107)
  - Clear error if user declines migration
**Related:** FEAT-107 (System Requirements Documentation)

---

**Last Updated:** 2026-02-06
**Completed:** 2026-02-06
**Status:** Complete - Ready for done/
