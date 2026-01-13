# Framework Template Selection Guide

**Version:** 1.0.0
**Last Updated:** 2025-12-19

---

## Quick Start

Not sure which framework level you need? Answer three simple questions to find the right template for your project.

---

## The Three Questions

### 1. How Complex Is Your Project?

| Answer | Framework Level |
|--------|-----------------|
| Single script, one file | → **Minimal** |
| Small tool, 2-10 files | → **Light** or **Standard** |
| Application, 10-50 files | → **Standard** |
| Large system, 50+ files | → **Standard** |

### 2. How Long Will You Maintain It?

| Answer | Framework Level |
|--------|-----------------|
| Throwaway, one-time use | → **Minimal** |
| Few weeks to months | → **Light** |
| Ongoing, multi-year | → **Standard** |
| Critical production system | → **Standard** |

### 3. Who Will Work On It?

| Answer | Framework Level |
|--------|-----------------|
| Just me, no handoff | → **Minimal** or **Light** |
| Me + future-me or colleague | → **Light** or **Standard** |
| Small team (2-5 people) | → **Standard** |
| Large team (6+ people) | → **Standard** (not recommended for large teams use your descression) |

---

## Framework Selection Matrix

Combine your answers using this matrix:

| Scope | Lifespan | Team | Recommended Level |
|-------|----------|------|-------------------|
| Script | Throwaway | Solo/Personal | **Minimal** |
| Script/Tool | Maintained | Solo/Professional | **Light** |
| Tool/App | Maintained | Solo/Small Team | **Standard** |
| App/System | Critical | Any size | **Standard** (Full) |

---

## Framework Levels Explained

### Minimal Framework

**Best for:** Single scripts, automation tasks, personal tools

**What you get:**
- README.md with "Why This Exists" section
- Optional .gitignore
- Optional CHANGELOG.md

**What you DON'T get:**
- No PROJECT-STATUS.md
- No thoughts/ folder structure
- No formal planning or kanban
- No templates

**When to use:**
- ✅ Single Python/PowerShell/Bash script
- ✅ Personal automation
- ✅ One-time data conversion
- ✅ Quick utility for yourself

**When NOT to use:**
- ❌ Multiple files
- ❌ Team collaboration
- ❌ Handoff expected
- ❌ Long-term maintenance

**See:** [minimal/](minimal/) folder for templates

---

### Light Framework

**Best for:** Small tools, utilities expected to be maintained

**What you get:**
- README.md (detailed)
- PROJECT-STATUS.md (version tracking)
- CHANGELOG.md (history)
- Optional CLAUDE.md (1-page guide)
- Basic thoughts/project/history/ structure
- Simple research justification

**What you DON'T get:**
- No kanban workflow (todo/doing/done)
- No full planning structure
- No complete template library
- No ADRs

**When to use:**
- ✅ CLI utilities
- ✅ Small web services
- ✅ Tools with 2-10 files
- ✅ Maintained for months
- ✅ Possible handoff to colleague

**When NOT to use:**
- ❌ Complex applications
- ❌ Team collaboration needed
- ❌ Multiple work items to track
- ❌ Formal planning required

**Upgrade path:** Can upgrade to Standard when project grows

**See:** [light/](light/) folder for templates

---

### Standard Framework

**Best for:** Applications, ongoing projects, team collaboration

**What you get:**
- Complete documentation suite (README, STATUS, CHANGELOG, INDEX, CLAUDE.md)
- Full thoughts/ framework structure
- Kanban workflow (todo/doing/done)
- Planning and roadmap capability
- Complete research templates (5 templates)
- Work item templates (FEATURE, BUGFIX, BLOCKER, SPIKE)
- ADR templates (MAJOR, MINOR)
- Framework patterns library
- Wrapper templates

**What you DON'T get:**
- No compliance documentation
- No multi-team coordination

**When to use:**
- ✅ Applications (10+ files)
- ✅ Ongoing maintenance
- ✅ Team of 2-5 developers
- ✅ Formal releases needed
- ✅ Architecture decisions to document
- ✅ Multiple work items to track

**When NOT to use:**
- ❌ Simple scripts
- ❌ Throwaway projects
- ❌ Solo personal tools
- ❌ No planning needed

**Also called:** "Full Framework" when using comprehensive ADRs and governance

**See:** [standard/](standard/) folder for templates

---

## Decision Tree

```
START
  |
  ├─ Single file script?
  │    ├─ Yes → Throwaway?
  │    │        ├─ Yes → MINIMAL
  │    │        └─ No → LIGHT
  │    │
  │    └─ No → 10+ files?
  │             ├─ No (2-10 files) → Team or handoff?
  │             │                    ├─ No → LIGHT
  │             │                    └─ Yes → STANDARD
  │             │
  │             └─ Yes → Team project?
  │                      ├─ Yes (2-5 people) → STANDARD
  │                      └─ No → STANDARD
```

---

## Quick Comparison Table

| Feature | Minimal | Light | Standard |
|---------|---------|-------|----------|
| **README** | ✓ Basic | ✓ Detailed | ✓ Complete |
| **PROJECT-STATUS** | ✗ | ✓ | ✓ |
| **CHANGELOG** | Optional | ✓ | ✓ |
| **CLAUDE.md** | ✗ | Optional | ✓ Full |
| **INDEX.md** | ✗ | ✗ | ✓ |
| **Research Templates** | ✗ | Simple | Complete |
| **Kanban Workflow** | ✗ | ✗ | ✓ |
| **Planning/Roadmap** | ✗ | ✗ | ✓ |
| **Work Item Templates** | ✗ | ✗ | ✓ |
| **ADR Templates** | ✗ | ✗ | ✓ |
| **Pattern Library** | ✗ | ✗ | ✓ |
| **Compliance Docs** | ✗ | ✗ | ✗ |
| **Overhead** | Minimal | Low | Medium |

---

## Common Scenarios

### Scenario 1: "I just need to automate a task"

**Answer:** Start with **Minimal** framework
- Single script with README explaining why it exists
- Can upgrade later if it becomes more complex

### Scenario 2: "Building a CLI tool I'll maintain"

**Answer:** Start with **Light** framework
- Provides version tracking and change history
- Room to document decisions as they come up
- Can upgrade to Standard if tool grows

### Scenario 3: "Starting a new web application"

**Answer:** Start with **Standard** framework
- Full planning and tracking from day one
- Supports team collaboration
- Scales as project grows

### Scenario 4: "Large team, critical system"

**Answer:** Start with **Standard**, extend as needed
- Standard provides solid foundation
- Add new requirements incrementally if needed
- Customize governance for your organization

### Scenario 5: "Not sure how big this will get"

**Answer:** Start **one level down**, upgrade when needed
- Better to start simple and upgrade than to start heavy
- Upgrading is straightforward (see [UPGRADE-PATH.md](UPGRADE-PATH.md))
- Framework should serve project, not constrain it

---

## How to Use This Repository

### For New Projects

1. **Determine framework level** (use questions above)
2. **Copy appropriate template folder** to your project location
3. **Follow setup checklist** in [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)
4. **Customize** templates with your project details
5. **Begin development**

### For Existing Projects

1. **Assess current state** (files, team, complexity)
2. **Determine appropriate level** for current state
3. **Follow integration section** in [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)
4. **Migrate content** from existing docs
5. **Adopt workflow** incrementally

---

## Upgrading Between Levels

Projects evolve. What starts as a script can become a critical tool. See [UPGRADE-PATH.md](UPGRADE-PATH.md) for:

- **Minimal → Light:** When script gains multiple versions
- **Light → Standard:** When tool needs team collaboration or a formal workflow

**Key principle:** Upgrade when current level becomes constraining, not before.

---

## Still Not Sure?

### Ask Yourself:

1. **"Will someone else use this?"**
   - No → Minimal or Light
   - Yes → Light or Standard

2. **"Will I work on this next year?"**
   - No → Minimal
   - Maybe → Light
   - Yes → Standard

3. **"Will this have releases?"**
   - No → Minimal
   - Informal → Light
   - Formal → Standard

4. **"Do I need to track work items?"**
   - No → Minimal or Light
   - Yes → Standard

### When in Doubt

**Start with Light Framework**
- Middle ground between Minimal and Standard
- Provides enough structure for most projects
- Easy to upgrade or simplify later
- Low overhead, high value

---

## Related Documents

- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Setup instructions for each level
- [UPGRADE-PATH.md](UPGRADE-PATH.md) - How to upgrade between levels
- [CLAUDE.md](../CLAUDE.md) - Generic framework guidelines
- [Framework Changelog](../HPCJobQueuePrototype/thoughts/framework/FRAMEWORK-CHANGELOG.md) - Framework evolution

---

## Questions?

**How do I know if I picked the right level?**
- If framework feels burdensome → you're over-framed, consider downgrading
- If you're inventing structure → you're under-framed, consider upgrading
- If it feels right → you picked well

**Can I mix levels?**
- Generally no - pick one for consistency
- Exception: Can use parts of higher level (like ADRs) without full upgrade
- Document deviations in your CLAUDE.md

**What if my project changes?**
- Reassess at retrospectives (after major milestones)
- Upgrade when constraints felt
- See UPGRADE-PATH.md for migration guides

---

**Version:** 1.0.0
**Last Updated:** 2025-12-19
**Maintained by:** [Framework Maintainer Name]
