# Package Ecosystem Terminology and Structure Patterns

**Date:** 2026-01-13
**Purpose:** Document industry-standard terminology and structure patterns from npm, pip, and bundler to inform framework distribution decisions
**Related:** DECISION-050 (Framework distribution model)

---

## Summary

Research into how npm (Node.js), pip (Python), and bundler (Ruby) organize package source repositories to establish industry-standard terminology for the SpearIT framework distribution model.

**Key Finding:** The framework-as-dependency model aligns with standard "bundled dependency" patterns used across all major package ecosystems.

---

## NPM (Node.js) Package Structure

**Repository structure:**
```
awesome-package/
├── src/              # Source code (development)
├── dist/             # Built/distributed code (excluded from git, included in package)
├── lib/              # Transpiled code (included in npm package)
├── examples/         # Example usage/demonstration projects
├── package.json      # Package metadata and dependencies
├── README.md
└── tests/
```

**Key terminology:**
- **Package source repository** - Repository containing package development code
- **Source** (`src/`) - Development version of code
- **Distribution** (`dist/` or `lib/`) - What gets published/installed
- **Examples** - Demonstration projects showing package usage

**Common patterns:**
- Source code in `src/` subdirectory
- Build step transpiles to `lib/` or `dist/`
- `dist/` excluded from version control, but included in npm package
- `examples/` for demonstration projects
- `package.json` tracks version and dependencies

**Sources:**
- [Anatomy of a Package](https://survivejs.com/books/maintenance/packaging/anatomy/)
- [Learn How to Develop and Publish an NPM Package](https://auth0.com/blog/developing-npm-packages/)
- [nodejs-reference-architecture npm-package-development](https://github.com/nodeshift/nodejs-reference-architecture/blob/main/docs/development/npm-package-development.md)

---

## Pip (Python) Package Structure

**Repository structure (src layout - recommended):**
```
packaging_tutorial/
├── LICENSE
├── pyproject.toml    # Build configuration
├── setup.cfg         # Package metadata
├── README.md
├── src/              # Source code (recommended modern approach)
│   └── example_package/
│       ├── __init__.py
│       └── example.py
├── tests/
└── examples/         # Example usage
```

**Alternative (flat layout):**
```
packaging_tutorial/
├── pyproject.toml
├── README.md
├── example_package/  # Source code directly in root
│   ├── __init__.py
│   └── example.py
└── tests/
```

**Key terminology:**
- **Package source** - Development repository
- **Distribution** - Built wheel or sdist (source distribution)
- **Src layout** - Recommended modern structure with `src/` subdirectory
- **Flat layout** - Legacy structure with package in root

**Important distinction:**
- Python uses "package" for both the import name (underscores) and distribution name (dashes)
- `pyproject.toml` is the modern configuration standard (replaces `setup.py`)

**Sources:**
- [Packaging Python Projects — Python Packaging User Guide](https://packaging.python.org/tutorials/packaging-projects/)
- [4. Package structure and distribution — Python Packages](https://py-pkgs.org/04-package-structure.html)
- [pip documentation - Repository anatomy & directory structure](https://pip.pypa.io/en/stable/development/architecture/anatomy/)

---

## Bundler (Ruby Gems) Package Structure

**Repository structure:**
```
my-gem/
├── lib/              # Source code (Ruby convention)
│   └── my_gem/
│       ├── version.rb
│       └── main.rb
├── bin/              # Executable scripts
│   ├── console       # Interactive console for development
│   └── setup
├── spec/ or test/    # Tests
├── examples/         # Example usage
├── Gemfile           # Development dependencies
├── my-gem.gemspec    # Gem metadata and runtime dependencies
├── Rakefile          # Build tasks
└── README.md
```

**Key terminology:**
- **Gem source repository** - Repository where gem is developed
- **Gem** - The packaged distribution
- **lib/** - Ruby convention for source code (not `src/`)
- **Gemfile** - Development dependencies only
- **.gemspec** - Gem metadata and runtime dependencies

**Common patterns:**
- `bundle gem my-gem` generates standard structure
- `.gemspec` file is source of truth for metadata
- `Gemfile` includes `.gemspec` via `gemspec` directive
- `lib/` is Ruby's convention (not `src/`)

**Sources:**
- [Bundler: How to create a Ruby gem with Bundler](https://bundler.io/guides/creating_gem.html)
- [Ruby Gems, Gemfile & Bundler (The Ultimate Guide)](https://www.rubyguides.com/2018/09/ruby-gems-gemfiles-bundler/)

---

## Cross-Ecosystem Patterns

### Common Structure Elements

| Element | npm | pip | bundler | Purpose |
|---------|-----|-----|---------|---------|
| Source code | `src/` | `src/` | `lib/` | Development code |
| Built/dist | `dist/` or `lib/` | `dist/` | (gems are built) | What gets installed |
| Examples | `examples/` | `examples/` | `examples/` | Usage demonstrations |
| Tests | `tests/` or `test/` | `tests/` | `spec/` or `test/` | Test suites |
| Metadata | `package.json` | `pyproject.toml` | `.gemspec` | Package configuration |
| README | `README.md` | `README.md` | `README.md` | Documentation |

### Terminology Patterns

**Source vs Distribution:**
- **Source** = Canonical development version in repository
- **Distribution** = Built/packaged version that gets installed
- **Installed dependency** = Copy in consumer project

**Repository Types:**
- **Package source repository** = Where package is developed
- **Consumer project** = Project that uses the package

**Dependency Models:**
- **External dependency** - Fetched from registry (npm install, pip install, bundle install)
- **Bundled dependency** - Included directly in project (vendor/, node_modules committed, etc.)

---

## Naming Conventions Research

### Repository Naming

**Industry standards:**
- Use lowercase for repository names
- Use hyphens (slug-case) for word separation: `my-project-api`
- Avoid underscores and mixed case

**Common patterns:**
- Package name = repository name (simple)
- Organization prefix: `@myorg/package-name` (npm scoping)
- Project structure: `<team>-<technology>-<maturity>-<locator>` (enterprise)

**Sources:**
- [Repository Naming Conventions](https://medium.com/@nur26691/repository-naming-conventions-1065467de776)
- [Folder Structure Conventions](https://github.com/kriasoft/Folder-Structure-Conventions)
- [PEP 423 – Naming conventions and recipes related to packaging](https://peps.python.org/pep-0423/)

---

## Application to SpearIT Framework

### Current Structure
```
project-framework/              # Current name
├── framework/                  # Canonical framework source
├── project-hello-world/        # Example project
│   └── [references ../framework/]
└── project-templates/          # Template packages
```

### Recommended Structure (Based on Industry Patterns)

```
spear-framework/                # "Framework source repository"
├── framework/                  # "Source" or "canonical source"
├── examples/                   # Industry standard directory name
│   └── hello-world/           # "Example project" (not "project-hello-world")
│       └── framework/          # "Installed framework" or "local copy"
└── templates/                  # "Package templates" or "starter templates"
    ├── minimal/
    │   └── framework/          # "Bundled dependency"
    ├── light/
    │   └── framework/
    └── standard/
        └── framework/
```

### Recommended Terminology Mapping

| Current Term | Industry Standard | Context |
|--------------|------------------|---------|
| "monorepo" | "framework source repository" | Repository type |
| Top-level `framework/` | "framework source" or "canonical source" | Development version |
| Copied `framework/` | "installed framework" or "local framework copy" | Dependency in projects |
| `project-hello-world/` | `examples/hello-world/` | Demonstration project |
| "framework-as-dependency" | "bundled dependency model" | Distribution pattern |
| Template packages | "starter templates" or "project templates" | Bootstrap packages |

---

## Key Insights

### 1. Examples Directory is Universal
All three ecosystems use `examples/` for demonstration projects. This is a strong signal to adopt this convention.

### 2. Source vs Distribution Separation
- npm: `src/` → `dist/` or `lib/`
- Python: `src/` → wheel/sdist
- Ruby: `lib/` → gem

**For framework:** Top-level `framework/` is source, template-bundled `framework/` is distribution.

### 3. Bundled Dependency Pattern
While most packages are fetched from registries, bundling dependencies is recognized:
- npm: `node_modules/` (sometimes committed for specific reasons)
- Python: vendor/ directories
- Ruby: `bundle install --deployment` bundles gems

**Framework-as-dependency mirrors this pattern** - each project gets its own copy.

### 4. Version Tracking is Standard
- npm: `package.json` tracks version + dependencies
- Python: `pyproject.toml` or `setup.cfg`
- Ruby: `.gemspec`

**Framework should adopt:** `.framework-version` or integrate with `project-config.yaml`

### 5. Metadata Files are Expected
- npm: `package.json`
- Python: `pyproject.toml`
- Ruby: `.gemspec`

**Framework equivalent:** `project-config.yaml` (FEAT-037) serves this role

---

## Structural Recommendations

### 1. Rename `project-hello-world/` → `examples/hello-world/`
**Rationale:** Universal convention across npm, pip, bundler
**Impact:** Low - primarily documentation updates
**Benefit:** Instantly recognizable to developers from any ecosystem

### 2. Consider top-level `src/` for framework source
**Current:** `framework/` at root
**Alternative:**
```
spear-framework/
├── src/                    # Framework source code
│   └── framework/
├── examples/
└── templates/
```
**Rationale:** Aligns with npm/pip patterns
**Trade-off:** Adds directory depth, less clear that framework is primary artifact

**Recommendation:** Keep `framework/` at root - it's the primary artifact, not typical "source code"

### 3. Use `templates/` (not `project-templates/`)
**Rationale:** Shorter, clearer, follows convention of descriptive directory names
**Impact:** Low - rename directory
**Benefit:** Cleaner, more professional naming

### 4. Add `dist/` or `releases/` for packaged templates
**Pattern from npm:** Separate source from distribution
```
spear-framework/
├── framework/
├── examples/
├── templates/              # Template source
└── dist/                  # Built/packaged templates (like .zip files)
```
**Rationale:** Separates template source from packaged distributions
**Benefit:** Clearer what is source vs what users download

### 5. Framework metadata file (already planned)
**Align with:** FEAT-037 (project-config.yaml)
**Include:**
- Framework version
- Project metadata
- Customized files tracking (future)

---

## Recommendations Summary

### High Priority (Strong Industry Alignment)
1. ✅ **Rename** `project-hello-world/` → `examples/hello-world/`
2. ✅ **Rename** `project-templates/` → `templates/`
3. ✅ **Terminology:** Use "framework source repository" instead of "monorepo"
4. ✅ **Terminology:** Use "examples" and "starter templates"

### Medium Priority (Valuable but Optional)
5. ⚠️ **Consider** `dist/` or `releases/` for packaged template distributions
6. ⚠️ **Evaluate** whether `framework/` should move to `src/framework/` (probably NOT - framework is the artifact)

### Low Priority (Future Enhancement)
7. 📋 **Track** customized files in metadata (similar to package-lock.json)
8. 📋 **Update script** similar to `npm update` or `bundle update`

---

## Conclusion

**Key takeaway:** The framework-as-dependency model is well-established in industry as "bundled dependency" pattern. By adopting standard terminology and structure conventions from npm, pip, and bundler, the framework becomes immediately recognizable and understandable to developers from any ecosystem.

**Immediate action:** Update DECISION-050 to reference this research and adopt recommended terminology.

---

**Last Updated:** 2026-01-13
**Related Work Items:**
- DECISION-050: Framework distribution model
- FEAT-037: Project config file
