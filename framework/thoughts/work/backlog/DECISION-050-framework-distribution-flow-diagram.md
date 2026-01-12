# DECISION-050: Framework Distribution Flow Diagrams

**Supporting Document for:** DECISION-050-framework-distribution-model.md
**Created:** 2026-01-12
**Purpose:** Visual clarification of framework-as-dependency concept

---

## Diagram 1: Framework Lifecycle - Development vs. Dependency

```mermaid
graph TB
    subgraph "Framework Project (Development)"
        A[framework/] -->|Source of Truth| B[framework/templates/]
        A -->|Source of Truth| C[framework/process/]
        A -->|Source of Truth| D[framework/collaboration/]
        A -->|Has own| E[framework/thoughts/work/]

        E -->|Framework work items| F[FEAT-026, TECH-043, etc.]

        style A fill:#e1f5ff
        style E fill:#fff3cd
    end

    subgraph "User Project (Consumption)"
        G[my-project/] -->|Local Copy| H[my-project/framework/]
        H -->|Copied| I[templates/]
        H -->|Copied| J[process/]
        H -->|Copied| K[collaboration/]
        H -->|Version| L[.framework-version: v3.0.0]

        G -->|Has own| M[my-project/thoughts/work/]
        M -->|User work items| N[FEAT-001, BUGFIX-002, etc.]

        style G fill:#d4edda
        style H fill:#d1ecf1
        style M fill:#fff3cd
    end

    A -.->|Copy on setup| H
    A -.->|Update on request| H

    classDef source fill:#e1f5ff,stroke:#0066cc
    classDef copy fill:#d1ecf1,stroke:#0099cc
    classDef work fill:#fff3cd,stroke:#856404

    class A source
    class H copy
    class E,M work
```

**Key Insight:** Framework is BOTH:
- **A project** (when developing framework itself)
- **A dependency** (when copied into user projects)

---

## Diagram 2: Framework Setup Flow

```mermaid
sequenceDiagram
    participant User
    participant Template as project-templates/standard/
    participant Framework as framework/
    participant Project as my-project/

    Note over User,Project: Initial Setup
    User->>Template: 1. Copy template package
    Template->>Project: 2. Create project structure
    Template->>Project: 3. Copy framework/ folder
    Framework->>Project: 4. Framework becomes part of project
    Project->>Project: 5. Create .framework-version (v3.0.0)

    Note over Project: Project is now self-contained

    Note over User,Project: Customization
    User->>Project: 6. Customize framework/templates/FEATURE-TEMPLATE.md
    Project->>Project: 7. Add customization tag in file

    Note over Project: User owns customized files
```

---

## Diagram 3: Framework Update Flow

```mermaid
sequenceDiagram
    participant User
    participant Project as my-project/
    participant FrameworkRepo as framework-repo (upstream)
    participant UpdateScript as Update-Framework.ps1

    Note over User,UpdateScript: Check for Updates
    User->>UpdateScript: ./Update-Framework.ps1 -Check
    UpdateScript->>Project: Read .framework-version (v2.5.0)
    UpdateScript->>FrameworkRepo: Check latest version
    FrameworkRepo-->>UpdateScript: Latest is v3.0.0
    UpdateScript-->>User: "Update available: v3.0.0"

    Note over User,UpdateScript: Perform Update
    User->>UpdateScript: ./Update-Framework.ps1 -Version v3.0.0
    UpdateScript->>Project: Scan for customized files
    UpdateScript->>Project: Identify files with CUSTOMIZED tags

    alt No Customized Files
        UpdateScript->>FrameworkRepo: Download v3.0.0
        FrameworkRepo-->>UpdateScript: Framework files
        UpdateScript->>Project: Replace framework/ folder
        UpdateScript->>Project: Update .framework-version to v3.0.0
        UpdateScript-->>User: "✓ Updated to v3.0.0"
    else Has Customized Files
        UpdateScript-->>User: "⚠ Warning: 3 files customized"
        UpdateScript-->>User: "- framework/templates/FEATURE-TEMPLATE.md"
        UpdateScript-->>User: "Would you like to:"
        UpdateScript-->>User: "1. Skip (keep v2.5.0)"
        UpdateScript-->>User: "2. Update non-customized only"
        UpdateScript-->>User: "3. Backup and update all (manual merge needed)"
        User->>UpdateScript: Choice: 2
        UpdateScript->>Project: Update non-customized files
        UpdateScript->>Project: Keep customized files as-is
        UpdateScript->>Project: Update .framework-version to v3.0.0*
        UpdateScript-->>User: "✓ Partial update to v3.0.0"
        UpdateScript-->>User: "⚠ Review framework/CHANGELOG.md for customized file changes"
    end
```

---

## Diagram 4: Framework as Project vs. Dependency

```mermaid
graph LR
    subgraph "Monorepo Structure"
        A[project-framework/]

        subgraph "Framework Project"
            B[framework/]
            B1[framework/templates/]
            B2[framework/process/]
            B3[framework/thoughts/work/]
            B --> B1
            B --> B2
            B --> B3
        end

        subgraph "Hello World Project"
            C[project-hello-world/]
            C1[project-hello-world/framework/<br/>COPY of framework]
            C2[project-hello-world/src/]
            C3[project-hello-world/thoughts/work/]
            C --> C1
            C --> C2
            C --> C3
        end

        subgraph "Template Packages"
            D[project-templates/]
            D1[standard/<br/>includes framework/ copy]
            D --> D1
        end

        A --> B
        A --> C
        A --> D
    end

    B -.->|Sync on update| C1
    B -.->|Included in template| D1

    style B fill:#e1f5ff,stroke:#0066cc,stroke-width:3px
    style C1 fill:#d1ecf1,stroke:#0099cc,stroke-dasharray: 5 5
    style B3 fill:#fff3cd
    style C3 fill:#fff3cd

    Note1[Framework is SOURCE]
    Note2[project-hello-world<br/>has COPY as dependency]
    Note3[Each tracks own work items]
```

**Key Points:**
1. `framework/` = Source project (develops framework itself)
2. `project-hello-world/framework/` = Dependency copy (uses framework)
3. Each maintains separate `thoughts/work/` for their own work items
4. `framework/` work items = framework improvements (FEAT-026, TECH-043)
5. `project-hello-world/` work items = hello-world features (FEAT-001, etc.)

---

## Diagram 5: Work Item Context Separation

```mermaid
graph TB
    subgraph "Framework Development Context"
        FW[framework/]
        FW_WORK[framework/thoughts/work/]
        FW_FEAT[FEAT-026: Session History]
        FW_TECH[TECH-043: DRY Principles]
        FW_DEC[DECISION-050: Distribution Model]

        FW --> FW_WORK
        FW_WORK --> FW_FEAT
        FW_WORK --> FW_TECH
        FW_WORK --> FW_DEC

        style FW fill:#e1f5ff
        style FW_WORK fill:#fff3cd
    end

    subgraph "User Project Context"
        PROJ[project-hello-world/]
        PROJ_FW[project-hello-world/framework/<br/>dependency copy]
        PROJ_WORK[project-hello-world/thoughts/work/]
        PROJ_FEAT[FEAT-001: Add greeting feature]
        PROJ_BUG[BUGFIX-002: Fix config parsing]

        PROJ --> PROJ_FW
        PROJ --> PROJ_WORK
        PROJ_WORK --> PROJ_FEAT
        PROJ_WORK --> PROJ_BUG

        style PROJ fill:#d4edda
        style PROJ_FW fill:#d1ecf1,stroke-dasharray: 5 5
        style PROJ_WORK fill:#fff3cd
    end

    FW -.->|Sync framework files| PROJ_FW
    FW_WORK -.->|NO SYNC| PROJ_WORK

    Note1[Framework work items<br/>stay in framework/]
    Note2[Project work items<br/>stay in project/]
    Note3[Framework files<br/>sync as dependency]
```

---

## Summary: Key Concepts

### Framework Has Dual Identity

1. **As a Project (framework/):**
   - Has its own development workflow
   - Has `thoughts/work/` for framework improvements
   - Tracks FEAT-026, TECH-043, DECISION-050, etc.
   - Source of truth for templates, process, collaboration guides

2. **As a Dependency (my-project/framework/):**
   - Copied into user projects during setup
   - Versioned (`.framework-version`)
   - Can be customized by user (user owns changes)
   - Can be updated from source when user chooses

### Separation of Concerns

- **Framework work items** = Improving the framework itself
  - Location: `framework/thoughts/work/`
  - Examples: FEAT-026, TECH-043, DECISION-050

- **Project work items** = User's project features
  - Location: `my-project/thoughts/work/`
  - Examples: FEAT-001 (add feature), BUGFIX-002 (fix bug)

### Update Model

- User controls when to update framework
- Can customize framework files (user owns them)
- Update script helps identify conflicts
- Version tracking enables informed decisions

---

## Open Questions / Discussion Points

1. **Update Script Complexity:**
   - MVP: Manual instructions ("copy framework/ from latest release")
   - v2: `Update-Framework.ps1` with conflict detection
   - v3: Smart merge tool

   **When to build?** Start with MVP (documentation), build tooling if validated by usage?

2. **Framework Exclusions:**
   - Should user projects copy `framework/thoughts/`?
   - **Recommendation:** NO - framework's work items are not relevant to users
   - Only copy: templates, process, collaboration, patterns, docs

3. **Customization Tagging:**
   - Standard format for marking customizations?
   ```markdown
   <!-- CUSTOMIZED: Modified from framework v2.5.0 on 2026-01-12 -->
   <!-- REASON: Added project-specific validation fields -->
   ```

4. **Integration with FEAT-037 (Project Config):**
   - Should `project-config.yaml` track framework version and customizations?
   ```yaml
   framework:
     version: "3.0.0"
     customizedFiles:
       - framework/templates/FEATURE-TEMPLATE.md
   ```

---

**Last Updated:** 2026-01-12
