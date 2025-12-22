# FEAT-020: Content Migration Matrix

**Purpose:** Track what content from CLAUDE.md (654 lines) goes where in the restructured documentation.

**Goal:** Reduce CLAUDE.md to 400-500 lines while maintaining universal collaboration/ docs.

---

## Current CLAUDE.md Structure (654 lines)

| Section | Lines | Keep in CLAUDE.md | Move to collaboration/ | Notes |
|---------|-------|-------------------|------------------------|-------|
| **Overview** | 3-4 | Summary only | N/A | Keep brief intro |
| **Architecture** | 7-32 | Folder tree (keep) | N/A | Critical reference |
| **Command Center** | 34-35 | Keep placeholder | N/A | Empty section |
| **Code Style Guidelines** | 37-39 | Reference only | → code-quality-standards.md | Link to full doc |
| **Testing Instructions** | 41-44 | Summary (3 lines) | → testing-strategy.md | Extract details |
| **Error Handling** | 47-51 | Summary (3 lines) | → code-quality-standards.md | Extract examples |
| **Clean Code Guidelines** | 54-59 | Summary (5 lines) | → code-quality-standards.md | Extract rationale |
| **Security Guidelines** | 62-67 | Summary (5 lines) | → security-policy.md | Extract detailed rules |
| **Documentation Standards** | 70-210 | Keep core conventions | → workflow-guide.md | Session history, work items |
| **Working with Claude** | 212-258 | Keep brief summary | → workflow-guide.md | Collaboration practices |
| **Collaboration & Workflow** | 260-268 | Keep git basics | → workflow-guide.md | Git details, PR process |
| **Edge Case Considerations** | 271-278 | Keep checklist | → testing-strategy.md | Examples |
| **Project Classification** | 281-338 | Keep decision tree | N/A | Framework selection core |
| **Workflow & Planning** | 340-433 | Keep key principles | → workflow-guide.md | Detailed phases |
| **AI Workflow Checkpoint** | 435-561 | **KEEP VERBATIM** | N/A | Process-critical (ADR-001) |
| **ADRs** | 564-652 | Keep decision tree | → workflow-guide.md | Detailed ADR process |

---

## Target: collaboration/workflow-guide.md (NEW)

**Source Content From CLAUDE.md:**

**From "Documentation Standards" (lines 121-153):**
- Session History (detailed format)
- Work Item Documentation (template usage)
- Code Documentation Requirements (detailed)
- Project Retrospectives (detailed structure)

**From "Working with Claude" (lines 214-258):**
- Effective Collaboration (all subsections)
- Communication Best Practices (detailed)

**From "Collaboration & Workflow" (lines 260-268):**
- Git branch strategy (detailed)
- Commit message conventions (examples)
- Pull Request process (detailed)
- Code review process

**From "Workflow & Planning" (lines 340-433):**
- Development Workflow Phases (detailed for each)
- Research Phase Guidelines (all framework levels)
- Planning Guidelines (detailed)

**From "ADRs" (lines 569-652):**
- When to Create an ADR (detailed criteria)
- Template Selection (MAJOR vs MINOR detailed)
- Upgrading MINOR to MAJOR (full process)
- ADR Lifecycle (detailed)
- Examples

**Target Size:** ~300-400 lines

---

## Target: collaboration/code-quality-standards.md (NEW)

**Source Content From CLAUDE.md:**

**From "Code Style Guidelines" (line 37-39):**
- Reference to project-specific coding-standards.md
- Framework-level coding standards

**From "Testing Instructions" (lines 41-44):**
- TDD mindset details
- Coverage targets
- Test structure

**From "Error Handling" (lines 47-51):**
- Diagnose, Don't Guess (detailed approach)
- Graceful Handling (examples)
- Logging strategies
- No Silent Failures

**From "Clean Code Guidelines" (lines 54-59):**
- Function Size (rationale and examples)
- Single Responsibility (examples)
- Naming (detailed conventions)
- DRY Principle (examples)
- Comments (philosophy with examples)

**Target Size:** ~200-250 lines

---

## Target: collaboration/security-policy.md (NEW)

**Source Content From CLAUDE.md:**

**From "Security Guidelines" (lines 62-67):**
- Input Validation (detailed rules with examples)
- Authentication (detailed implementation: bcrypt, salt, lockout)
- Database Safety (parameterized queries, SQL injection prevention)
- XSS & CSRF (sanitization, libraries, CSRF tokens)
- Dependencies (eval dangers, vulnerability checking)

**Additional Content (expand with best practices):**
- OWASP Top 10 checklist
- Security testing requirements
- Secrets management
- API security
- Session management

**Target Size:** ~150-200 lines

---

## Target: collaboration/testing-strategy.md (NEW)

**Source Content From CLAUDE.md:**

**From "Testing Instructions" (lines 41-44):**
- TDD mindset (detailed workflow)
- Coverage targets (by component type)
- Test clarity and focus

**From "Edge Case Considerations" (lines 271-278):**
- Edge case categories with examples
- Fail-fast principle (detailed)

**Additional Content:**
- Test organization
- Test naming conventions
- Mocking strategies
- Integration vs unit tests
- Test data management

**Target Size:** ~150-200 lines

---

## Target: collaboration/architecture-guide.md (NEW)

**Source Content:**

**From current project understanding:**
- Project Framework architecture overview
- Multi-level framework design (Minimal/Light/Standard/Enterprise)
- thoughts/ folder structure rationale
- File-based kanban design decisions
- Template system architecture
- Why framework decisions were made

**Target Size:** ~150-200 lines

---

## Target: collaboration/troubleshooting-guide.md (NEW)

**Source Content From CLAUDE.md:**

**From "Emergency Troubleshooting" (lines 186-210):**
- Emergency Reference structure
- System Not Working checklist
- Quick Diagnostics template

**Additional Content (project-specific):**
- Common issues with framework setup
- WIP limit violations
- Git workflow issues
- Template usage errors
- Version sync issues

**Target Size:** ~100-150 lines

---

## Target: collaboration/README.md (NEW)

**Content:**
- Index of all collaboration docs
- Quick navigation (humans and AI)
- For AI: Reference to CLAUDE.md Reading Protocol
- For Humans: Standard project documentation

**Target Size:** ~50 lines

---

## Restructured CLAUDE.md (Target: 400-500 lines)

**New Structure:**

### 1. Quick Start (50 lines)
- Read this first
- Critical rules summary
- Link to CLAUDE-QUICK-REFERENCE.md
- Link to collaboration/ docs

### 2. Project Overview (50 lines)
- What this project is
- Folder structure (keep verbatim from lines 7-32)
- Architecture at high level
- **Deep Dive:** Link to collaboration/architecture-guide.md

### 3. AI Workflow Checkpoint Policy (130 lines) ⭐ KEEP VERBATIM
- Lines 435-561 (AI Workflow Checkpoint Policy)
- Process-critical per ADR-001
- NO changes to this section

### 4. Project Classification (60 lines) ⭐ KEEP
- Lines 281-338 (Framework Selection)
- Core framework feature
- Decision tree essential

### 5. Core Standards Summary (100 lines)
- Code Quality (summary with link to collaboration/code-quality-standards.md)
- Security (summary with link to collaboration/security-policy.md)
- Testing (summary with link to collaboration/testing-strategy.md)
- Documentation (core conventions only)
- Workflow (git basics with link to collaboration/workflow-guide.md)

### 6. AI Reading Protocol (50 lines) ⭐ NEW
- When to read collaboration/ docs
- Decision tree: "Need X? Read Y"
- Proactive reading patterns
- Examples

### 7. ADR Quick Reference (30 lines)
- When to create ADR (simple decision tree)
- MAJOR vs MINOR (quick guide)
- **Full Details:** Link to collaboration/workflow-guide.md

### 8. Emergency Reference (30 lines)
- Top 5 common issues
- Quick diagnostics
- **Full Guide:** Link to collaboration/troubleshooting-guide.md

**Total: ~500 lines**

---

## CLAUDE-QUICK-REFERENCE.md (Target: <200 lines)

**Content:**

1. **AI Workflow Checkpoint Policy** (exact copy of 9 steps)
2. **Critical Rules**
   - NEVER list
   - ALWAYS list
3. **Quick Decision Trees**
   - Creating ADR?
   - Release ready?
   - Need approval?
4. **Emergency Fixes** (top 5 common issues)

**Total: ~150 lines**

---

## Content Extraction Validation

**Must Preserve:**
- ✅ AI Workflow Checkpoint Policy (lines 435-561) - verbatim in CLAUDE.md
- ✅ Project Classification (lines 281-338) - verbatim in CLAUDE.md
- ✅ Folder structure (lines 7-32) - verbatim in CLAUDE.md
- ✅ Single source of truth principle - no duplication

**Must Extract:**
- ✅ Detailed workflow phases → collaboration/workflow-guide.md
- ✅ Clean code details → collaboration/code-quality-standards.md
- ✅ Security details → collaboration/security-policy.md
- ✅ Testing details → collaboration/testing-strategy.md
- ✅ ADR detailed process → collaboration/workflow-guide.md
- ✅ Git workflow details → collaboration/workflow-guide.md

**Must Create:**
- ✅ AI Reading Protocol section in CLAUDE.md
- ✅ collaboration/README.md navigation
- ✅ collaboration/architecture-guide.md
- ✅ CLAUDE-QUICK-REFERENCE.md

---

## Implementation Order

1. ✅ Create this migration matrix (DONE)
2. Create collaboration/ folder
3. Extract to collaboration/workflow-guide.md
4. Extract to collaboration/code-quality-standards.md
5. Extract to collaboration/security-policy.md
6. Extract to collaboration/testing-strategy.md
7. Create collaboration/architecture-guide.md
8. Create collaboration/troubleshooting-guide.md
9. Create collaboration/README.md
10. Create CLAUDE-QUICK-REFERENCE.md
11. Restructure CLAUDE.md (keeping critical sections, adding Reading Protocol)
12. Update INDEX.md and STRUCTURE.md
13. Test AI navigation

---

**Last Updated:** 2025-12-22
**Status:** Migration matrix complete, ready for extraction
