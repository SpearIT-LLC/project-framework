# SpearIT Project Framework - Template Package

**Version:** 3.0.0
**Last Updated:** 2026-01-26

---

## What Is This?

This folder contains the **starter template** for creating new projects using the SpearIT Project Framework.

**Quick Start:**
1. Use the distribution archive (recommended) - see [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md)
2. Or manually copy from [starter/](starter/)

---

## Contents

### Template
- [starter/](starter/) - Complete project scaffolding with framework included

### Setup Guides
- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Setup instructions (start here)

### Reference (may be outdated)
- [STRUCTURE.md](STRUCTURE.md) - Template structure reference

---

## How It Works

The framework uses a **framework-as-dependency** model (see DECISION-050):

1. **Each project gets its own `framework/` copy** - Self-contained, portable
2. **Use the starter template** - Provides complete project scaffolding
3. **Customize as needed** - You own your copy, modify freely

```
your-project/
├── framework/              # Your copy of the framework
│   ├── docs/
│   ├── templates/
│   └── tools/
├── project-hub/            # Your work items and history
├── src/                    # Your code
├── CLAUDE.md
├── README.md
└── ...
```

---

## Distribution Methods

### Method 1: Framework Archive (Recommended)

```powershell
# Build the archive
.\tools\Build-FrameworkArchive.ps1

# Setup new project from archive
.\templates\starter\Setup-Project.ps1 -ArchivePath ".\distrib\spearit-framework-v3.7.0.zip"
```

### Method 2: Manual Copy

```powershell
# Copy starter template
Copy-Item -Recurse templates/starter/* path/to/your-project/

# Copy framework docs and templates
Copy-Item -Recurse framework/docs path/to/your-project/framework/
Copy-Item -Recurse framework/templates path/to/your-project/framework/
Copy-Item -Recurse framework/tools path/to/your-project/framework/
```

---

## Future: Task-Based Project Templates

The framework will evolve to include **task-based project templates** that guide appropriate rigor based on what you're building (not project size). See [misc-thoughts-and-planning.md](../framework/project-hub/research/misc-thoughts-and-planning.md#Project-Templates) for the concept.

---

## Related Documents

- [NEW-PROJECT-CHECKLIST.md](NEW-PROJECT-CHECKLIST.md) - Setup instructions
- [../framework/CLAUDE.md](../framework/CLAUDE.md) - Framework context
- [../QUICK-START.md](../QUICK-START.md) - Framework quick reference

---

**Maintainer:** Gary Elliott (gary.elliott@spearit.solutions)
