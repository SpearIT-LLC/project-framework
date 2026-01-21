# Feature: Manual Setup Process Validation

**ID:** FEAT-025
**Type:** Feature
**Priority:** High
**Version Impact:** PATCH
**Created:** 2026-01-01

---

## Summary

Manually execute the framework setup process for **Standard level only** by creating a trivial "Greeter" sample project, validating NEW-PROJECT-CHECKLIST.md accuracy, and discovering setup issues before building automation (FEAT-005/006). Minimal/Light validation deferred to future work.

---

## Problem Statement

**What problem does this solve?**

We've built templates and documentation but never validated the end-to-end user journey: "download framework → setup project → working structure." Documentation references paths like `thoughts/framework/templates/` that may not exist after setup. NEW-PROJECT-CHECKLIST.md has never been tested. We don't know if the setup process actually works.

**Risk Level:** HIGH - This is the foundational user experience. If setup is broken, nothing else matters.

**Who is affected?**

- **New users** attempting to adopt the framework
- **Framework maintainers** (us) who will build automation (FEAT-005/006) on broken assumptions

**Current workaround (if any):**

None - we've been developing the framework templates but not validating the setup process.

---

## Requirements

### Functional Requirements

- [ ] Create `examples/greeter-standard/` using Standard framework setup
- [ ] Follow NEW-PROJECT-CHECKLIST.md Standard section exactly
- [ ] Document every deviation, missing step, or confusing instruction
- [ ] Implement trivial "Greeter" PowerShell application
- [ ] Create 2-3 sample work items showing framework workflow
- [ ] Create 1 sample ADR showing decision documentation
- [ ] Create sample session history
- [ ] Validate final directory structure matches expected paths
- [ ] Confirm `thoughts/framework/templates/` exists and is accessible
- [ ] Test copying templates from `thoughts/framework/templates/` to work items
- [ ] Confirm documentation path references are accurate

### Non-Functional Requirements

- [ ] Performance: Setup process should complete in documented time estimates
- [ ] Documentation: Update NEW-PROJECT-CHECKLIST.md with discovered issues
- [ ] Documentation: Fix path references in collaboration guides if incorrect
- [ ] Examples: Should be simple enough for beginners to understand

---

## Design

### Architecture Impact

**Files Modified:**
- `project-framework-template/standard/NEW-PROJECT-CHECKLIST.md` - Fix discovered setup issues
- `thoughts/project/collaboration/*.md` - Fix path references if needed
- `CLAUDE.md` - Fix template path references if needed

**Files Added:**
- `examples/greeter-standard/` - Complete Standard framework example
- Includes working Greeter app, sample work items, ADR, session history
- Demonstrates complete framework workflow

### Implementation Approach

**Phase 1: Setup Standard Framework Example**
1. Create `examples/greeter-standard/` directory
2. Copy `project-framework-template/standard/` contents to `examples/greeter-standard/`
3. Follow NEW-PROJECT-CHECKLIST.md Standard section exactly
4. Document every issue, confusing step, or missing instruction in FEAT-025 work item
5. Verify final directory structure

**Phase 2: Implement Greeter Application**
1. Create basic `src/Greet.ps1` (Hello World functionality)
2. Create `config.json` with greeting templates
3. Add README.md with project description
4. Add PROJECT-STATUS.md with current version
5. Initialize CHANGELOG.md

**Phase 3: Test Framework Workflow**
1. Create FEAT-001: "Add custom greetings" in backlog
2. Move through backlog → todo → doing → done (following kanban workflow)
3. Implement Add-Greeting.ps1 functionality
4. Create ADR-001: "JSON config format choice" in research/adr/
5. Create sample session history documenting development
6. **CRITICAL TEST:** Copy template from `thoughts/framework/templates/FEATURE-TEMPLATE.md` to work item
7. Verify all paths work as documented

**Phase 4: Validate & Fix Documentation**
1. Review all documentation path references
2. Update NEW-PROJECT-CHECKLIST.md with discovered issues
3. Fix path references in CLAUDE.md if incorrect
4. Fix path references in collaboration guides if incorrect
5. Document findings in FEAT-025 work item

**Key Validation Points:**

1. **Path accuracy:** Do paths in docs match reality after setup?
2. **Template accessibility:** Can users actually copy templates from documented locations?
3. **Setup completeness:** Are all necessary steps documented?
4. **Clarity:** Are instructions clear enough for first-time users?
5. **Structure validity:** Does final structure match framework design?

### Alternative Approaches Considered

**Option 1: Build automation first (FEAT-005/006), then validate**
- Pros: Faster to automation
- Cons: Might build automation for broken process
- Decision: Rejected - validate manually first (current approach)

**Option 2: Skip manual validation, rely on HPC project experience**
- Pros: No additional work
- Cons: HPC was retrofitted, not fresh setup
- Decision: Rejected - need fresh setup validation

**Option 3: Validate Standard only, skip Minimal/Light**
- Pros: Less work
- Cons: Minimal/Light have different setup processes
- Decision: Rejected - need to validate all levels

---

## Dependencies

**Requires:**
- Current template structure in `project-framework-template/{minimal,light,standard}/`
- NEW-PROJECT-CHECKLIST.md

**Blocks:**
- FEAT-005 (ZIP distribution package) - Should wait until Standard setup is validated
- FEAT-006 (Interactive setup script) - Should wait until manual process works
- FEAT-026 (Minimal/Light examples) - Future work to add Minimal/Light validation

**Related:**
- FEAT-011 (Comprehensive sample project) - FEAT-025 is the focused validation version

---

## Testing Plan

### Validation Checklist

**Standard Framework Setup:**
- [ ] Create examples/greeter-standard/ directory
- [ ] Copy project-framework-template/standard/ contents
- [ ] Follow NEW-PROJECT-CHECKLIST.md Standard section step-by-step
- [ ] Document every issue, missing step, or unclear instruction
- [ ] Verify complete directory structure created

**Greeter Application Implementation:**
- [ ] Implement basic Greet.ps1 (Hello World)
- [ ] Create config.json with greeting templates
- [ ] Write README.md, PROJECT-STATUS.md, CHANGELOG.md
- [ ] Verify application works: `.\src\Greet.ps1 -Name "Alice"`

**Framework Workflow Testing:**
- [ ] **CRITICAL:** Verify `thoughts/framework/templates/` directory exists
- [ ] **CRITICAL:** Test template copy: `cp thoughts/framework/templates/FEATURE-TEMPLATE.md thoughts/project/planning/backlog/FEAT-001-custom-greetings.md`
- [ ] Create FEAT-001 work item in backlog/
- [ ] Move FEAT-001: backlog/ → todo/ → doing/ → done/
- [ ] Implement Add-Greeting.ps1 feature
- [ ] Create ADR-001 in research/adr/
- [ ] Create session history in history/
- [ ] Verify kanban workflow functions correctly

**Path Validation:**
- [ ] Compare documented paths in CLAUDE.md with actual paths in greeter-standard/
- [ ] Compare documented paths in collaboration/*.md with actual paths
- [ ] Test all path references in documentation
- [ ] Create list of path corrections needed

**Documentation Updates:**
- [ ] Update NEW-PROJECT-CHECKLIST.md with discovered issues
- [ ] Fix path references in CLAUDE.md (if needed)
- [ ] Fix path references in collaboration guides (if needed)
- [ ] Document all findings in FEAT-025 work item

---

## Success Metrics

**How do we know this validation is successful?**

1. **All three example projects created and working**
2. **NEW-PROJECT-CHECKLIST.md validated** - All steps accurate or corrected
3. **Path accuracy confirmed** - Docs match reality or are fixed
4. **Issues documented** - Clear list of problems found and solutions
5. **Ready for automation** - Manual process works, can now build FEAT-005/006 confidently

**Failure Criteria:**
- Setup process doesn't work as documented
- Critical paths in documentation are wrong
- Missing steps discovered in setup process

---

## Implementation Checklist

- [ ] Create examples/ directory structure
- [ ] Phase 1: Minimal framework validation complete
- [ ] Phase 2: Light framework validation complete
- [ ] Phase 3: Standard framework validation complete
- [ ] Validation notes documented
- [ ] NEW-PROJECT-CHECKLIST.md updated with fixes
- [ ] Path references in docs updated
- [ ] Examples committed to repository
- [ ] CHANGELOG.md updated

---

## CHANGELOG Notes

**For CHANGELOG.md (copy to CHANGELOG at release):**

```markdown
### Added
- **FEAT-025: Manual Setup Process Validation**
  - Created working examples for all three framework levels
  - Validated NEW-PROJECT-CHECKLIST.md accuracy through real usage
  - Fixed path references in documentation to match post-setup reality
  - De-risks automation (FEAT-005/006) by proving manual process works

### Fixed
- NEW-PROJECT-CHECKLIST.md - Corrected [list discovered issues]
- Documentation path references - Updated [list files] to match actual structure
```

---

## Open Questions

**CRITICAL: These must be answered at Step 7.5 (Pre-Implementation Review) before proceeding.**

### Q1: File Structure - Where do examples live?

**Options:**

**Option A: Top-level `examples/` directory**
```
project-framework/
├── examples/
│   ├── task-timer-minimal/
│   ├── task-timer-light/
│   └── task-timer-standard/
├── project-framework-template/
├── thoughts/
└── ...
```
- Pros: Clean separation, easy to find, matches common practice
- Cons: Another top-level directory

**Option B: Inside `project-framework-template/examples/`**
```
project-framework/
├── project-framework-template/
│   ├── examples/
│   │   ├── task-timer-minimal/
│   │   ├── task-timer-light/
│   │   └── task-timer-standard/
│   ├── minimal/
│   ├── light/
│   └── standard/
└── ...
```
- Pros: Keeps template-related content together
- Cons: Examples aren't templates, they're working projects

**Option C: `thoughts/project/reference/examples/`**
```
project-framework/
├── thoughts/
│   └── project/
│       └── reference/
│           └── examples/
│               ├── task-timer-minimal/
│               ├── task-timer-light/
│               └── task-timer-standard/
└── ...
```
- Pros: Part of project documentation/reference
- Cons: Deeply nested, harder to discover

**Question:** Which structure best serves users looking for examples?

### Q2: Archive Strategy - What gets saved after validation?

**The examples themselves:**
- Keep permanently as reference examples? OR
- Delete after validation complete (documentation is what matters)? OR
- Move to `thoughts/project/reference/examples/` for archival?

**The validation notes:**
- Create `FEAT-025-VALIDATION-NOTES.md` alongside work item?
- Include directly in FEAT-025 work item?
- Separate file in `thoughts/project/reference/`?

**Test results:**
- Create `FEAT-025-TEST-RESULTS.md` (like FEAT-020)?
- Include in work item?
- Create checklist in work item that gets checked off?

**Question:** What artifacts persist after this work item is done?

### Q3: Testing This Work Item - What's the validation process?

**Two-level testing:**

**Level 1: Setup Process Validation**
- Test: Can we follow NEW-PROJECT-CHECKLIST.md successfully?
- Pass: All three framework levels set up without errors
- Fail: Missing steps, unclear instructions, broken references

**Level 2: Framework Usage Validation**
- Test: Can we use the framework workflow in the examples?
- Pass: Can create work items, move through kanban, make decisions
- Fail: Missing templates, inaccessible paths, broken workflow

**Question:** What constitutes "done" for this work item?
- Examples exist and work?
- NEW-PROJECT-CHECKLIST.md validated?
- Documentation paths corrected?
- All of the above?

### Q4: What Should We Test - Scope boundaries?

**Minimal testing:**
- Just test setup process (copy templates, verify structure)
- No actual application implementation
- Pros: Fast, focused on setup validation
- Cons: Doesn't test full workflow

**Standard testing (proposed in work item):**
- Test setup process
- Implement trivial task timer app
- Create sample work items/ADRs in Standard example
- Test template copying workflow
- Pros: Validates complete user experience
- Cons: More time, might get distracted by app implementation

**Comprehensive testing:**
- Everything in Standard plus:
- Test upgrade path (Minimal → Light → Standard)
- Test all templates in Standard example
- Create complete project history
- Pros: Thorough validation
- Cons: Might be overkill for validation goal

**Question:** What's the minimum viable validation that de-risks FEAT-005/006?

### Q5: How do we document issues found?

**Option A: In-line in FEAT-025 work item**
```markdown
## Validation Results

### Issues Found
1. NEW-PROJECT-CHECKLIST.md step 3 unclear - [fix applied]
2. Path reference in CLAUDE.md incorrect - [fix applied]
```

**Option B: Separate validation notes file**
- `FEAT-025-VALIDATION-NOTES.md` with detailed findings
- Work item references it
- Archived together with work item

**Option C: Create bugfix work items for each issue**
- BUGFIX-007: Fix NEW-PROJECT-CHECKLIST.md step 3
- BUGFIX-008: Fix CLAUDE.md path references
- Pros: Proper tracking
- Cons: Might be overkill for documentation fixes

**Question:** How do we track and fix issues discovered during validation?

### Q6: Task Timer Scope - How complex?

**Minimal example:**
```powershell
# Simple timer that logs to CSV
Start-Timer.ps1
Stop-Timer.ps1
Report.ps1
tasks.csv
```

**Light example:**
```
src/
  Start-Timer.ps1
  Stop-Timer.ps1
  Report.ps1
config.json
data/tasks.csv
README.md
```

**Standard example:**
- Full CLI with multiple commands
- Testing plan
- Work items showing development
- ADRs for technical decisions
- Session history

**Question:** How much actual code should we implement vs. focus on framework structure?

### Q7: Dummy Application Definition - Keep it trivial?

**Proposed: "Greeter" PowerShell Application**

**Rationale:** Simpler than Task Timer, focuses on framework validation not app complexity.

**Minimal example (`greeter-minimal`):**
```powershell
# greet.ps1
param([string]$Name = "World")
Write-Host "Hello, $Name!"
```

**Light example (`greeter-light`):**
```
greeter-light/
├── README.md
├── PROJECT-STATUS.md
├── CHANGELOG.md
├── src/
│   ├── Greet.ps1         # Main greeting logic
│   └── Get-Greeting.ps1  # Helper function
├── config.json           # Greeting messages
└── thoughts/
    └── project/
        └── history/      # Decision log
```

**Standard example (`greeter-standard`):**
```
greeter-standard/
├── [Full framework structure]
├── src/
│   ├── Greet.ps1
│   ├── Add-Greeting.ps1     # Add custom greetings
│   └── Get-GreetingList.ps1 # List available greetings
├── config.json
└── thoughts/
    └── project/
        ├── work/
        │   ├── todo/
        │   ├── doing/
        │   └── done/
        │       ├── FEAT-001-add-custom-greetings.md
        │       └── FEAT-002-list-greetings.md
        └── research/
            └── adr/
                └── 001-json-config-format.md
```

**Application features by level:**

**Minimal:**
- Single command: `.\greet.ps1 -Name "Alice"`
- Output: "Hello, Alice!"
- That's it - validates basic structure

**Light:**
- Multiple greetings: Hello, Goodbye, Welcome
- Config file: `config.json` with greeting templates
- Validates: Multi-file structure, configuration management

**Standard:**
- All Light features plus:
- Add custom greetings
- List available greetings
- Work items showing feature development
- ADR documenting config format choice
- Session history showing development process
- Validates: Complete framework workflow

**Why "Greeter" over "Task Timer"?**
- Simpler: No time tracking, no persistence complexity
- Expandable: Easy to add greetings = easy to create work items
- Clear features: Each greeting type = one feature
- Framework focus: Won't get distracted implementing timer logic

**Example workflow in Standard:**
1. Setup framework structure
2. Create FEAT-001: "Add custom greetings"
3. Move through backlog → todo → doing → done
4. Create ADR-001: "Use JSON for config format" (vs XML, CSV)
5. Implement feature
6. Create session history documenting work
7. Validates: Template copying, kanban workflow, decision documentation

**Question:** Is "Greeter" simple enough to keep focus on framework validation?

---

## Notes

**Why this is critical:**

This is the highest-risk item in the backlog because:
1. Every user will go through setup process
2. Bad setup = bad first impression = framework abandonment
3. Automation (FEAT-005/006) built on broken process = wasted work
4. We've been developing framework WITHOUT validating user experience

**Discovery during planning:**

User identified that documentation references `thoughts/framework/templates/` but that path may not exist after setup. This work item validates whether:
- Path exists after setup
- Documentation is accurate
- Templates are accessible as documented
- Setup process actually works

**Approach:**

Manual validation first, automation second. Prove the concept works before building tooling around it.

---

## References

- FEAT-005: ZIP Distribution Package (blocked by this)
- FEAT-006: Interactive Setup Script (blocked by this)
- FEAT-011: Comprehensive Sample Project (this is minimal version)
- NEW-PROJECT-CHECKLIST.md (being validated)

---

**Last Updated:** 2026-01-01
