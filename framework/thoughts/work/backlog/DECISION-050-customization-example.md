# DECISION-050: Customization Tagging Example

**Supporting Document for:** DECISION-050-framework-distribution-model.md
**Created:** 2026-01-12
**Purpose:** Show how users tag customizations for future merging

---

## Scenario

Alice needs to add regulatory tracking to work items. She customizes `framework/templates/work-items/FEATURE-TEMPLATE.md` in her project.

---

## BEFORE: Framework Default (v3.0.0)

```markdown
# Feature: [Feature Name]

**ID:** NNN
**Type:** Feature
**Status:** [Backlog | Todo | Doing | Done]
**Created:** [YYYY-MM-DD]

---

## Summary
[Description]

---

## Requirements

### Functional Requirements
- [ ] Requirement 1
- [ ] Requirement 2

---

## Security Considerations
- [ ] Input validation implemented
- [ ] No credential exposure in logs
- [ ] Path traversal prevention

---
[Rest of template...]
```

---

## AFTER: Alice's Customized Version

```markdown
<!-- CUSTOMIZED: Modified from framework v3.0.0 on 2026-01-12 -->
<!-- CHANGES: Added regulatory compliance section, added IEC field, enhanced security -->

# Feature: [Feature Name]

**ID:** NNN
**Type:** Feature
**Status:** [Backlog | Todo | Doing | Done]
**Created:** [YYYY-MM-DD]

<!-- CUSTOM FIELD -->
**IEC 62304 Class:** [A | B | C]
<!-- END CUSTOM -->

---

## Summary
[Description]

---

## Requirements

### Functional Requirements
- [ ] Requirement 1
- [ ] Requirement 2

---

<!-- CUSTOM SECTION: Added 2026-01-12 -->
## Regulatory Compliance

- [ ] FDA 510(k) requirements reviewed
- [ ] IEC 62304 lifecycle phase documented
- [ ] Risk analysis completed (ISO 14971)

**References:**
- Risk file: `docs/risk/FEAT-NNN-risk.md`
<!-- END CUSTOM SECTION -->

---

## Security Considerations

<!-- MODIFIED SECTION: Added medical device requirements -->
**Standard:**
- [ ] Input validation implemented
- [ ] No credential exposure in logs
- [ ] Path traversal prevention

**Medical Device (FDA):**
- [ ] Patient data HIPAA compliant
- [ ] Audit logging enabled
- [ ] SBOM updated
<!-- END MODIFIED SECTION -->

---
[Rest of template...]
```

---

## What Changed?

1. **Header tag** - Tracks base version and what was modified
2. **Custom field** - IEC 62304 classification added
3. **New section** - Regulatory compliance checklist
4. **Modified section** - Security enhanced with medical requirements

---

## When Framework Updates to v3.1.0

Framework adds "Performance Testing" section. Alice manually:
1. Checks framework CHANGELOG
2. Adds new sections to her template
3. Updates header: `<!-- CUSTOMIZED: Modified from framework v3.1.0 on 2026-01-15 -->`
4. Keeps her custom sections (Regulatory, IEC field)

---

## Tagging Options

### Option 1: Minimal Comments (Simplest)
```markdown
<!-- CUSTOMIZED from framework v3.0.0 on 2026-01-12 -->
<!-- CHANGES: Added regulatory section, IEC field -->

# Feature: [Feature Name]
...

<!-- CUSTOM SECTION -->
## Regulatory Compliance
[content]
<!-- END CUSTOM -->
```

**Pros:** Simple, low overhead
**Cons:** Less detail, harder to parse programmatically

---

### Option 2: Structured Comments (Recommended)
```markdown
<!-- CUSTOMIZED: Modified from framework v3.0.0 on 2026-01-12 -->
<!-- CHANGES: Added regulatory compliance section, added IEC field, enhanced security -->

# Feature: [Feature Name]
...

<!-- CUSTOM SECTION: Added 2026-01-12 -->
## Regulatory Compliance
[content]
<!-- END CUSTOM SECTION -->

<!-- MODIFIED SECTION: Added medical device requirements -->
## Security Considerations
[content]
<!-- END MODIFIED SECTION -->
```

**Pros:** Clear structure, easy to identify sections, datestamp per section
**Cons:** More verbose

---

### Option 3: YAML Frontmatter (Most Structured)
```yaml
---
framework_customization:
  base_version: 3.0.0
  customized_date: 2026-01-12
  customized_by: Alice Thompson
  modifications:
    - type: added_section
      name: Regulatory Compliance
      reason: FDA 510(k) tracking
    - type: added_field
      name: IEC 62304 Class
      reason: Software classification tracking
    - type: modified_section
      name: Security Considerations
      reason: Medical device cybersecurity requirements
---

# Feature: [Feature Name]
...
```

**Pros:** Machine-parseable, detailed tracking, structured data
**Cons:** More complex, not standard markdown, tooling needed to parse

---

### Option 4: Git-style Attribution
```markdown
# Feature: [Feature Name]
# CUSTOMIZED: v3.0.0 -> local (2026-01-12)
# @author Alice Thompson
# @changes regulatory-compliance, iec-field, security-enhancements

...

## Regulatory Compliance
# @custom-section 2026-01-12
# @reason FDA 510(k) tracking requirements
[content]
```

**Pros:** Familiar to developers, inline attribution
**Cons:** Uses `#` which isn't markdown comments, less clean

---

### Option 5: Emoji Tags (Visual)
```markdown
<!-- 🔧 CUSTOMIZED from framework v3.0.0 on 2026-01-12 -->

# Feature: [Feature Name]
...

<!-- ➕ CUSTOM SECTION -->
## Regulatory Compliance
[content]
<!-- /➕ -->

<!-- ✏️ MODIFIED SECTION -->
## Security Considerations
[content]
<!-- /✏️ -->
```

**Pros:** Visually distinctive, quick to scan
**Cons:** Emoji in source files (some teams avoid), accessibility concerns

---

### Option 6: Markdown Extensions (Future)
```markdown
:::custom-section base-version="3.0.0" date="2026-01-12"
## Regulatory Compliance
[content]
:::

:::modified-section original-version="3.0.0"
## Security Considerations
[enhanced content]
:::
```

**Pros:** Clean syntax, extensible, standard emerging pattern
**Cons:** Requires markdown processor that supports directives

---

### Option 7: Sidecar File (Separate Metadata)
```markdown
# Feature: [Feature Name]
<!-- See .framework-customizations.yaml for modification details -->
...
```

**Separate file: `.framework-customizations.yaml`**
```yaml
customizations:
  - file: framework/templates/work-items/FEATURE-TEMPLATE.md
    base_version: 3.0.0
    date: 2026-01-12
    sections:
      - type: added
        name: Regulatory Compliance
        line_start: 83
      - type: modified
        name: Security Considerations
        line_start: 96
```

**Pros:** Keeps template clean, machine-parseable, detailed tracking
**Cons:** Additional file to maintain, sync issues

---

### Option 8: Minimal Inline Only (No Header)
```markdown
# Feature: [Feature Name]
...

<!-- CUSTOM: Regulatory section (v3.0.0 base, added 2026-01-12) -->
## Regulatory Compliance
[content]
<!-- /CUSTOM -->

<!-- MODIFIED: Security section (v3.0.0 base, enhanced 2026-01-12) -->
## Security Considerations
[content]
<!-- /MODIFIED -->
```

**Pros:** No header clutter, context right where it matters
**Cons:** No file-level overview, harder to see what's customized at a glance

---

## Comparison Matrix

| Option | Simplicity | Parseability | Visibility | Future-proof |
|--------|------------|--------------|------------|--------------|
| 1. Minimal Comments | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 2. Structured Comments | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 3. YAML Frontmatter | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 4. Git-style | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| 5. Emoji Tags | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| 6. Markdown Extensions | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 7. Sidecar File | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 8. Inline Only | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

---

## Simplified Approaches (Recommended)

### Option 9: Section-Level Tags (Simplest Effective)

**Concept:** Tag the section header, everything below it is customized until next section.

```markdown
<!-- CUSTOMIZED: Modified from framework v3.0.0 on 2026-01-12 -->

# Feature: [Feature Name]
...

## Hamburger Condiment Policy
<!-- CUSTOMIZED: v3.0.0, 2026-01-12 -->
- Ketchup
- Mustard
- BBQ Sauce

## Security Considerations
<!-- MODIFIED: v3.0.0, 2026-01-12 -->
- [ ] Input validation implemented
- [ ] Patient data HIPAA compliant
- [ ] Audit logging enabled
```

**Pros:**
- ✅ Minimal overhead (one comment per section)
- ✅ Section scope is implicit (ends at next `##`)
- ✅ No closing tags needed
- ✅ Standard markdown comments

**Cons:**
- ❌ Less precise (can't tag specific lines within section)
- ❌ Must remember section ends at next header

---

### Option 10: Encapsulated Changes (Most Precise)

**Concept:** Opening/closing tags wrap exactly what changed (like HTML/XML).

```markdown
<!-- CUSTOMIZED: v3.0.0, 2026-01-12 -->

# Feature: [Feature Name]
...

## Hamburger Condiment Policy
- Ketchup
- Mustard
<!-- CUSTOM -->
- BBQ Sauce
<!-- /CUSTOM -->

## Security Considerations
- [ ] Input validation implemented
- [ ] No credential exposure in logs
<!-- CUSTOM -->
- [ ] Patient data HIPAA compliant
- [ ] Audit logging enabled
<!-- /CUSTOM -->
```

**Pros:**
- ✅ Surgical precision (only tag what actually changed)
- ✅ Clear boundaries
- ✅ Easy to see exactly what's custom
- ✅ Minimal when small changes

**Cons:**
- ❌ More tags if many changes
- ❌ Closing tags can be forgotten

---

### Option 6 Revisited: Markdown Extensions (Clean & Future-Proof)

**Concept:** Use emerging markdown directive syntax.

```markdown
---
framework_version: 3.0.0
customized_date: 2026-01-12
---

# Feature: [Feature Name]
...

:::custom base="3.0.0"
## Regulatory Compliance

- [ ] FDA 510(k) requirements reviewed
- [ ] IEC 62304 lifecycle phase documented
- [ ] Risk analysis completed (ISO 14971)
:::

## Security Considerations

- [ ] Input validation implemented
- [ ] No credential exposure in logs

:::modified base="3.0.0"
- [ ] Patient data HIPAA compliant
- [ ] Audit logging enabled
- [ ] SBOM updated
:::
```

**Pros:**
- ✅ Clean syntax
- ✅ Section-level OR inline
- ✅ Attributes in opening tag
- ✅ Emerging standard (CommonMark extensions)
- ✅ Can render nicely with supporting tools

**Cons:**
- ❌ Not all markdown processors support it yet
- ❌ Fallback rendering may show `:::` to user

---

### Option 7 Revisited: Sidecar File (Pristine Templates)

**Main file stays clean:**
```markdown
# Feature: [Feature Name]

**ID:** NNN
**Type:** Feature

## Hamburger Condiment Policy
- Ketchup
- Mustard
- BBQ Sauce

## Security Considerations
- [ ] Input validation implemented
- [ ] No credential exposure in logs
- [ ] Patient data HIPAA compliant
- [ ] Audit logging enabled
```

**Sidecar: `FEATURE-TEMPLATE.framework.yaml`**
```yaml
customization:
  base_version: 3.0.0
  customized_date: 2026-01-12

sections:
  - name: Hamburger Condiment Policy
    type: modified
    changes:
      - "Added BBQ Sauce to condiment list"

  - name: Security Considerations
    type: modified
    changes:
      - "Added medical device requirements"
```

**Pros:**
- ✅ Template stays completely clean
- ✅ All metadata centralized
- ✅ Easy to track all customizations at once
- ✅ Machine-parseable

**Cons:**
- ❌ Two files to maintain
- ❌ Can get out of sync
- ❌ Less obvious when reading template

---

## Comparison: Simplified Options

| Option | Cleanliness | Precision | Parseability | Learning Curve |
|--------|-------------|-----------|--------------|----------------|
| 9. Section-Level Tags | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 10. Encapsulated | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 6. Markdown Extensions | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 7. Sidecar File | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |

---

## Final Recommendation

**For Framework v3.0.0 MVP:**

**Primary: Option 6 (Markdown Extensions)** + **Fallback: Option 9 (Section-Level)**

### Why Markdown Extensions?
1. Clean, modern syntax
2. Works well for both sections and inline changes
3. Growing support in markdown ecosystem
4. Future-proof (CommonMark direction)
5. Can add attributes without verbose comments

### Fallback Plan
If markdown extensions feel too risky (processor compatibility), use **Option 9 (Section-Level Tags)**:
- Simple comments
- Minimal overhead
- Works everywhere
- Easy to upgrade to extensions later

### Implementation
```markdown
<!-- File header -->
---
framework_version: 3.0.0
customized_date: 2026-01-12
---

<!-- Use markdown extensions when available -->
:::custom base="3.0.0"
## New Section
[content]
:::

<!-- OR use section-level comments as fallback -->
## Modified Section
<!-- MODIFIED: v3.0.0, 2026-01-12 -->
[content]
```

---

**Last Updated:** 2026-01-12
