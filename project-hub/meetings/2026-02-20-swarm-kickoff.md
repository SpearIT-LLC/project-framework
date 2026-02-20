# Swarm Kick-off — 2026-02-20

**Participants:** Gary Elliott, Alex (Product Owner), Dan (Senior Developer), Sam (Architect)

---

## Problem / Idea

The SpearIT Project Framework is a maturing product. As it has grown — from Framework ZIP to Plugin Light (shipped) to Plugin Full (in pre-release) — the project has lacked a formal project brief. The user (Gary Elliott, SpearIT) wanted to establish one as part of the process of dogfooding the framework's own tooling, including this `/swarm` command running for the first time in anger.

The stated goal: build an AI consultant for consultants — giving solo developers and embedded ICs the expert-team scrutiny that well-resourced organizations take for granted.

---

## Team Discussion

**Alex (Product Owner)** opened by clarifying the target user and success framing. Key clarifications from the user:

- IC = Individual Contributor (not Internal Consultant)
- PI = Planning Increment (not Plugin)
- The product has three delivery tiers: Plugin Light (Kanban only), Plugin Full (Light + Project Guidance), Framework ZIP (Full + local scripting)
- Both solo developers and embedded consultants are valid primary users — not mutually exclusive
- The project is well underway; the brief is being formalized as part of mature process, not as a starting point

**Dan (Senior Developer)** noted that the Project Guidance design document (`project-hub/planning/design/project-guidance.md`) is well-scoped and the MVP line is clear. Flagged that the "should we build this at all?" question in Phase 1 is the right differentiator — no other tool in the Claude Code ecosystem does this.

**Sam (Architect)** argued for framing this as one product with three distribution tiers, not three separate products. The progressive adoption path (Light → Full → Framework ZIP) is the platform play. Named the framework's role as a foundation for future SpearIT projects — the brief should reflect this, not just describe the current feature set.

---

## Decisions

- **One product, three tiers** — Plugin Light, Plugin Full, and Framework ZIP are delivery tiers of a single product, not separate products. One brief covers all three.
- **Primary user is solo developer / IC** — consultants embedded in larger organizations are a specific, named persona within that audience, not a separate segment.
- **Brief scoped to current PI** — the brief captures where the project is now and where PI MVP is headed; future PIs (Developer Intelligence, Growth & Feedback) are named in the outline but not over-specified.
- **Inline definitions for IC and PI** — first use in brief and outline uses full form ("Individual Contributor (IC)", "Planning Increment (PI)"). Both terms also added to the framework glossary.

---

## Open Questions & Risks

1. **Marketplace submission process** — timeline and requirements not fully known; could gate both plugin launches independent of code readiness.
2. **Dogfooding gap** — Plugin Full has not yet been used on a real project end-to-end. `/swarm` output quality at scale is unvalidated. This session is the first real run.
3. **Brief → roadmap handoff** — `/fw-roadmap` does not currently read the project outline as input. Known limitation; deferred to a future PI.

---

*AI-generated meeting record via /spearit-framework:swarm*
