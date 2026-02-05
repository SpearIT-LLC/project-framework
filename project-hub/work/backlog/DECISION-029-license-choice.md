# DECISION-029: License Choice for Framework

**ID:** DECISION-029
**Type:** Decision
**Priority:** High
**Version Impact:** None
**Created:** 2026-01-08

---

## Summary

Decide which open source license to use for the Standard Project Framework before public release.

---

## Problem Statement

**Issue identified during:** FEAT-026 implementation (external-readiness review)

The framework currently lacks a LICENSE file, which is required before public release:
- No license means "all rights reserved" by default (not open source)
- Potential users need to know usage terms and restrictions
- Blocks public repository release
- Affects contribution guidelines and community building

**Who is affected?**
- Framework users (need to know usage rights)
- Contributors (need to know their rights and obligations)
- Organization (legal and strategic implications)

**Current workaround:**
- None - this is a blocking decision for public release

---

## Decision Required

Choose one of the following licenses (or another if justified):

### Option 1: MIT License
**Characteristics:**
- Very permissive
- Allows commercial use, modification, distribution
- Requires copyright notice and license text
- No warranty or liability

**Pros:**
- Simple and widely understood
- Maximum adoption potential
- No restrictions on commercial use
- Compatible with most other licenses

**Cons:**
- Provides no patent grant
- No copyleft protection (derivatives can be closed)

**Best for:** Maximizing adoption and flexibility

---

### Option 2: Apache 2.0
**Characteristics:**
- Permissive with patent grant
- Allows commercial use, modification, distribution
- Requires notices and copyright
- Explicit patent grant from contributors

**Pros:**
- Includes patent protection
- Still very permissive
- Well-respected in enterprise
- Good for projects with potential patent concerns

**Cons:**
- More complex than MIT
- Requires more attribution
- Slightly less compatible with some licenses (GPL2)

**Best for:** Projects needing patent protection

---

### Option 3: GPL v3
**Characteristics:**
- Strong copyleft license
- Requires derivative works to be open source
- Includes patent grant
- Anti-Tivoization provisions

**Pros:**
- Ensures derivatives remain open
- Strong community protection
- Patent protection included

**Cons:**
- Can limit commercial adoption
- Incompatible with some projects
- More restrictive for users
- May reduce adoption

**Best for:** Ensuring all derivatives remain open source

---

## Evaluation Criteria

Consider the following factors:

1. **Adoption goals:** Do we want maximum adoption or ensure derivatives stay open?
2. **Commercial use:** Do we want to encourage commercial use without restrictions?
3. **Patent concerns:** Are there patent considerations?
4. **Community:** What license will attract contributors?
5. **Business strategy:** What aligns with organizational goals?

---

## Recommendation

*To be determined based on stakeholder input*

Suggested approach:
1. Define framework's strategic goals (adoption vs. protection)
2. Assess business requirements and constraints
3. Consider target user base and use cases
4. Select license that best aligns with goals

---

## Implementation

Once license is chosen:

- [ ] Add LICENSE file to repository root
- [ ] Add license badge to README.md
- [ ] Add copyright headers to files (if required by license)
- [ ] Update CONTRIBUTING.md with license-related info
- [ ] Verify compatibility with any dependencies
- [ ] Document license choice reasoning (ADR or in this file)

---

## Timeline

**Priority:** High - blocking public release
**Must be decided before:** Making repository public

---

## References

- Source: project-hub/research/backlog-ideas-from-feat-026.md (Item #6)
- Origin: FEAT-026-followup.md line 26
- Related: FEAT-026 (external-readiness work)
- License comparison: https://choosealicense.com/
- OSI approved licenses: https://opensource.org/licenses

---

## Notes

**Questions to resolve:**
- What are the organization's open source strategy goals?
- Are there existing organizational license preferences?
- What licenses do similar frameworks use?
- Are there any patent concerns to address?

**Similar projects:**
- Research what licenses similar project management frameworks use
- Consider industry standards for documentation frameworks

---

**Last Updated:** 2026-01-08
