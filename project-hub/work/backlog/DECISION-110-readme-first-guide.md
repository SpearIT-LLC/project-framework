# Decision: README-FIRST.txt Quick Start Guide

**ID:** DECISION-110
**Type:** Decision
**Priority:** Low
**Version Impact:** PATCH
**Created:** 2026-02-05
**Theme:** Distribution & Onboarding
**Planning Period:** Sprint D&O 4 (Polish)

---

## Summary

Decide whether to include a README-FIRST.txt quick start guide in the framework distribution package, or if existing documentation is sufficient.

---

## Context

**What triggered this decision?**

FEAT-005 (ZIP Distribution Package) originally specified including README-FIRST.txt in distribution packages. During Sprint D&O 1 review, we discovered that:
- Build-FrameworkArchive.ps1 already exists and works
- DECISION-050 changed the distribution model to single comprehensive package
- Most FEAT-005 requirements are already complete
- Only missing piece is the README-FIRST.txt file

**What are the constraints?**

- Current distribution already includes README.md from starter template
- Setup-Project.ps1 has -Help parameter for guidance
- Build script outputs usage instructions to console
- Must maintain documentation without duplication

---

## Current User Experience

1. User downloads `spearit_framework_vX.Y.Z.zip`
2. User extracts to a location
3. User sees folder contents:
   - `framework/` (documentation and templates)
   - `project-hub/` (project structure)
   - `Setup-Project.ps1` (setup script)
   - `README.md`, `CLAUDE.md`, etc. (project files)
4. User runs `Setup-Project.ps1 -Destination "C:\Projects\MyApp"`
5. Setup script guides user through project creation

---

## Options Considered

### Option A: Add README-FIRST.txt

**Description:** Create a dedicated README-FIRST.txt file in the archive root with quick start instructions.

**Pros:**
- Immediately visible after extraction (sorted first alphabetically)
- Clear entry point for new users
- Can explain framework-as-dependency model
- Provides offline quick reference
- Original FEAT-005 requirement

**Cons:**
- Another file to maintain
- Potential duplication with README.md
- May be redundant with Setup-Project.ps1 -Help
- Adds to file count in archive

**Content would include:**
```
SpearIT Project Framework
Version: vX.Y.Z

QUICK START:
1. Extract this archive to a convenient location
2. Run: .\Setup-Project.ps1 -Destination "C:\Projects\YourApp"
3. Follow the interactive prompts

WHAT'S INCLUDED:
- framework/     - Documentation, templates, and tools
- Setup script   - Creates new projects from this distribution

NEXT STEPS:
- See README.md for framework overview
- See CLAUDE.md for AI assistant context
- Visit [repository URL] for documentation

Questions? [contact info]
```

### Option B: Enhance README.md Header

**Description:** Add a prominent "GETTING STARTED" section at the top of README.md in starter template.

**Pros:**
- No new file to maintain
- Leverages existing documentation
- README.md is standard and expected
- Can include richer formatting (markdown)

**Cons:**
- Not as immediately obvious as README-FIRST.txt
- README.md may contain project-specific content
- Less clear for quick extraction and go

### Option C: No Additional Documentation

**Description:** Keep current state - Setup-Project.ps1 with -Help, existing README.md, build script output.

**Pros:**
- Simplest option (no work needed)
- Existing documentation already adequate
- Setup script is self-documenting
- Avoids documentation proliferation

**Cons:**
- User must discover Setup-Project.ps1
- Less hand-holding for first-time users
- No immediate "what do I do now" guide

### Option D: Interactive Quick Start in Setup-Project.ps1

**Description:** Enhance Setup-Project.ps1 to display quick start info when run without parameters.

**Pros:**
- Self-documenting script
- Single source of truth
- Always up-to-date
- Encourages running the script

**Cons:**
- Requires running script to see instructions
- User must know to run PowerShell script
- Not visible immediately after extraction

---

## Decision

**Chosen Option:** [To Be Decided]

**Rationale:** [To be completed after evaluation]

**Trade-offs Accepted:** [To be completed after evaluation]

---

## Evaluation Questions

When making this decision, consider:

1. **User testing:** Have we observed users struggling with current distribution?
2. **Support burden:** Do we get questions about "what do I do after extraction"?
3. **Target audience:** How technical is our primary user base?
4. **Distribution context:** Will packages be downloaded from GitHub Releases with description text?
5. **Comparison:** How do similar frameworks handle this? (cookiecutter, yeoman, etc.)

---

## Consequences

**If Option A chosen (README-FIRST.txt):**
- Update Build-FrameworkArchive.ps1 to include README-FIRST.txt
- Create README-FIRST.txt template
- Add to documentation maintenance burden

**If Option B chosen (Enhanced README.md):**
- Update starter template README.md
- Ensure setup instructions are prominent

**If Option C chosen (No change):**
- Document current distribution flow
- Monitor for user confusion

**If Option D chosen (Interactive script):**
- Enhance Setup-Project.ps1
- Add usage display

---

## Implementation Checklist

- [ ] Evaluate current user experience
- [ ] Check similar frameworks for patterns
- [ ] Make decision and document rationale
- [ ] Implement chosen option (if not Option C)
- [ ] Update FEAT-005 status based on decision

---

## Related

- FEAT-005: ZIP Distribution Package (mostly complete, this is the remaining question)
- DECISION-050: Framework-as-Dependency Model (established current distribution model)
- Build-FrameworkArchive.ps1: Current distribution builder
- Setup-Project.ps1: Current setup script

---

**Last Updated:** 2026-02-05
