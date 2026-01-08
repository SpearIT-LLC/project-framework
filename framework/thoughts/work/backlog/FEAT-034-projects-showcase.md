# FEAT-034: Projects Showcase Documentation

**ID:** FEAT-034
**Type:** Feature (Documentation)
**Priority:** Low
**Status:** Backlog
**Created:** 2026-01-08
**Related:** FEAT-026, DECISION-029

---

## Summary

Add mechanism for showcasing projects that use the Standard Project Framework, demonstrating real-world adoption and providing examples for potential users.

---

## Problem Statement

**Issue identified during:** FEAT-026 external-readiness discussions

Currently, there's no way for users to:
- See examples of projects using the framework
- Understand how others have adapted the framework
- Learn from real-world implementations
- Demonstrate framework adoption

**Who is affected?**
- Potential framework users (want to see real examples)
- Framework contributors (want to show their projects)
- Framework maintainers (want to demonstrate value)

**Current workaround:**
- None - no showcase currently exists

**Note:** This is low priority and can wait until after public release and initial adoption.

---

## Requirements

### Functional Requirements

- [ ] Provide place to list projects using the framework
- [ ] Include basic project information (name, description, link)
- [ ] Easy contribution process for adding projects
- [ ] Maintain quality standards (not a link dump)
- [ ] Optional: Categorize by project size/type

### Non-Functional Requirements

- [ ] Simple to maintain (low overhead)
- [ ] Quality control (verify projects actually use framework)
- [ ] Professional presentation
- [ ] Easy for users to contribute their projects

---

## Design Options

### Option 1: Section in README.md

**Approach:** Add "Projects Using This Framework" section to main README

**Example:**
```markdown
## Projects Using This Framework

- **[Project Name](https://github.com/user/project)** - Brief description of the project
- **[Another Project](https://github.com/user/project2)** - What this project does

Want to add your project? See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
```

**Pros:**
- ✅ Highly visible (in main README)
- ✅ Simple to implement
- ✅ No additional files needed

**Cons:**
- ❌ Could clutter README if list grows
- ❌ Less space for detailed descriptions

---

### Option 2: Separate PROJECTS.md File

**Approach:** Create dedicated PROJECTS.md in repository root

**Structure:**
```markdown
# Projects Using the Standard Project Framework

This page showcases projects built with or using the Standard Project Framework.

## Featured Projects

### [Project Name](https://github.com/user/project)
**Type:** Web Application | Tool | Library
**Description:** Detailed description of what the project does
**Framework Level:** Standard | Light | Minimal

### [Another Project](https://github.com/user/project2)
...

## Add Your Project

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding your project.

**Requirements:**
- Project must actively use the Standard Project Framework
- Include thoughts/work/ structure
- Public repository or accessible demo
```

**Pros:**
- ✅ Dedicated space for detailed information
- ✅ Keeps README focused
- ✅ Can grow without cluttering
- ✅ Better organization potential

**Cons:**
- ❌ Less visible than README
- ❌ Additional file to maintain

---

### Option 3: Link to GitHub Topics

**Approach:** Encourage users to tag repos with `standard-project-framework` topic

**Then reference in README:**
```markdown
## Projects Using This Framework

Browse projects using this framework:
[View on GitHub](https://github.com/topics/standard-project-framework)

To add your project, add the `standard-project-framework` topic to your repository.
```

**Pros:**
- ✅ No maintenance burden
- ✅ Self-service for users
- ✅ GitHub provides search/discovery

**Cons:**
- ❌ No quality control
- ❌ Less curated experience
- ❌ Depends on GitHub

---

### Option 4: Hybrid Approach

**Approach:** Brief list in README + link to PROJECTS.md for full list

**README.md:**
```markdown
## Projects Using This Framework

Featured projects using the Standard Project Framework:
- **[Project 1](link)** - Brief description
- **[Project 2](link)** - Brief description

[View all projects →](PROJECTS.md)
```

**PROJECTS.md:** Full detailed listings

**Pros:**
- ✅ Visibility in README
- ✅ Detailed info in dedicated file
- ✅ Scalable (featured vs. full list)

**Cons:**
- ❌ Must maintain both locations
- ❌ Deciding what's "featured"

---

## Recommendation

**Recommended:** Option 2 (PROJECTS.md) + GitHub topic

**Reasoning:**
- Start with dedicated PROJECTS.md for curated list
- Also encourage GitHub topic tagging for discovery
- Keeps README focused on framework itself
- Room to grow as adoption increases

**Phase 1:** Create PROJECTS.md structure
**Phase 2:** Add to README if list grows and is valuable
**Always:** Encourage GitHub topic tagging

---

## Implementation

### Phase 1: Create Structure

- [ ] Create PROJECTS.md file
- [ ] Define project entry template
- [ ] Add quality guidelines
- [ ] Document contribution process

### Phase 2: Add Initial Content

- [ ] Add project-hello-world as example
- [ ] Add any other known projects
- [ ] Optional: Add categories

### Phase 3: Enable Contributions

- [ ] Update CONTRIBUTING.md with showcase guidelines
- [ ] Define quality standards
- [ ] Document approval process

---

## Project Entry Template

```markdown
### [Project Name](https://github.com/user/repo)

**Type:** Web App | CLI Tool | Library | Mobile App | Other
**Framework Template:** Standard | Light | Minimal | Custom
**Language/Stack:** JavaScript, PowerShell, Python, etc.
**Status:** Active | In Development | Archived

**Description:**
2-3 sentences about what the project does and how it uses the framework.

**Highlights:**
- Notable customization or adaptation of framework
- Interesting use case or pattern
- Scale or complexity (optional)
```

---

## Quality Guidelines

**To be included in showcase:**
- ✅ Active use of Standard Project Framework structure
- ✅ Includes thoughts/work/ or equivalent
- ✅ Public repository or accessible documentation
- ✅ Demonstrates framework value

**Not required but nice:**
- Documentation following framework patterns
- Good example of framework adaptation
- Interesting use case

---

## Completion Criteria

- [ ] PROJECTS.md file created (or README section)
- [ ] Project entry template defined
- [ ] Quality guidelines established
- [ ] Contribution process documented in CONTRIBUTING.md
- [ ] At least one example project added (project-hello-world)
- [ ] GitHub topic tagged on this repository

---

## Dependencies

**Should be done after:**
- DECISION-029 (license choice) - Need clear license before public showcase
- Public release - Makes more sense once framework is public

**Related:**
- FEAT-026 (external-readiness) - Part of going public
- feature-012-contributing-guide - Contribution process

---

## References

- Source: framework/thoughts/research/backlog-ideas-from-feat-026.md (Item #7)
- Origin: FEAT-026-followup.md line 24
- Related: FEAT-026, DECISION-029

---

## Notes

**Timing:**
- Low priority - can wait until after public release
- Need some adoption before showcase is valuable
- Start simple, expand as needed

**Examples to learn from:**
- How other frameworks showcase projects
- GitHub topic pages
- Awesome lists format

**Future enhancements:**
- Statistics (project count by type)
- Case studies or detailed examples
- Community highlights

---

**Last Updated:** 2026-01-08
