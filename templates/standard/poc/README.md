# Proof of Concept

This folder contains proof-of-concept and experimental work.

## Purpose

Use this folder for:
- Quick experiments to test ideas
- Prototypes before committing to full implementation
- Spike implementations (code artifacts from spike work items)
- "Throwaway" code that explores a solution

## Guidelines

1. **Not production code:** POC code is exploratory, not polished
2. **Document findings:** Note what you learned, even if the POC is discarded
3. **Link to work items:** Reference the spike or feature that spawned the POC
4. **Clean up:** Archive or delete POCs that are no longer relevant

## Naming Convention

```
poc/
├── SPIKE-NNN-description/    # POC tied to a spike work item
├── experiment-name/          # Standalone experiment
└── prototype-feature-name/   # Feature prototype
```

## When to Move to src/

If a POC proves successful:
1. Create a feature work item
2. Refactor POC code to production quality
3. Move to `src/` with proper structure
4. Archive or delete the POC

---

**Note:** This folder is for experimentation. Don't worry about code quality here - focus on learning and validation.
