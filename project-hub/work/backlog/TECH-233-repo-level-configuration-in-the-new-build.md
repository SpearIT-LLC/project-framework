# Tech: Repo-Level Configuration in the New Build

**ID:** TECH-233
**Type:** Tech
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-09-11
**Workspace:** framework
**Completed:** <!-- Set automatically by /fw-move on → done/. Leave blank at creation. -->

---

## Summary

The old build's `framework.yaml` is the repo's index and configuration — `roles.default`,
`policies.onTransition`, and a `sources:` block mapping topic → source-of-truth. **The new build
has no equivalent and no way to produce one**, because ADR-009 D3 removed the archive that seeded
it.

Decide what repo-level configuration the new build needs, where it comes from, and — the real
question — **how much of it should exist in a consuming repo at all.**

## Why It Exists

Surfaced 2026-09-11 while scoping TECH-232 (`workspace.yaml`). Gary: *"Where is framework.yaml
going to come from in the new framework? We won't have an archive file to start from."*

**The old model:** the archive ships `framework.yaml`, it lands in the consuming repo at setup,
the AI reads it to find everything.

**The new model has no archive.** The framework *is* the plugin; commands build the structure
(ADR-009 D3). So a repo-level file can only come from a command that writes it, or not exist.

## The Argument Against Copying It Forward

**Most of `framework.yaml` is framework-internal knowledge.** Its `sources:` block maps topics to
paths inside the framework itself:

```yaml
workflow-process: framework/docs/collaboration/workflow-guide.md#development-workflow-phases
code-quality: framework/docs/collaboration/code-quality-standards.md
ai-roles: framework/docs/ref/framework-roles.yaml
```

**In the new model that is plugin knowledge, not repo knowledge.** A consuming repo does not need
to be told where the framework's own docs live — the plugin knows. Templating a copy into every
repo means every repo carries a map of the plugin's internals, and **every copy goes stale the
moment the plugin reorganizes**. That is precisely the hand-synced duplication ADR-008 exists to
kill, reintroduced by way of a template.

## Proposed Shape (to confirm, not yet decided)

Three tiers, each holding only what its level actually knows:

| Tier | Holds | Where it lives | Created by |
|---|---|---|---|
| **Plugin defaults** | conventions, the source index, policy | ships with the plugin | n/a — never copied into a repo |
| **Repo overrides** | only what *this repo* decides and the plugin cannot know: default role, policy deviations, a non-standard board location | repo root, **only if the repo deviates** | on demand, not scaffolded |
| **Workspace declaration** | type, what a card serves here, where those live | per workspace | `fw-new-workspace` (TECH-232) |

**The repo-override file is probably empty for most repos**, which is the argument for creating it
on demand rather than templating it. A scaffolded empty config is noise — the same reasoning
FEAT-198 applies to roadmaps (*"a scaffolded empty roadmap is noise for workspaces that never need
one"*).

## Open Questions

- [ ] **Does a repo-level file need to exist at all**, or can everything be plugin defaults plus
      per-workspace declarations? The bootstrap in the root `CLAUDE.md` reads `framework.yaml`
      today — what replaces that instruction in the new build?
- [ ] **What is genuinely repo-level** rather than plugin- or workspace-level? Candidates:
      `roles.default`, `policies.onTransition`, board location. Each needs justifying or cutting.
- [ ] **How does a repo override a plugin default** — a file, an env var, a settings entry? The
      mechanism matters more than the format.
- [ ] **What replaces the `sources:` index for the AI?** Its job was "consult this instead of
      asking where a topic is documented." If that becomes plugin-side, how does a cold session
      reach it?
- [ ] **Does the old `framework.yaml` survive the cutover** in this repo, or is it retired with
      the rest of the old build?

## Acceptance Criteria

- [ ] The three tiers are settled, each with a written justification for what it holds
- [ ] No framework-internal path is copied into a consuming repo
- [ ] A cold session can find what it needs without a repo-level index, **or** the index exists
      and its creation path is defined
- [ ] A repo that deviates from a default has a mechanism to say so
- [ ] Validated: **AI** — a fresh repo with the plugin installed and no config behaves correctly;
      **Human** — a newcomer can answer "where is X configured?" from the repo plus the plugin

## Related

- **TECH-232** — `workspace.yaml`, the per-workspace tier. Deliberately scoped to *just* that, so
  it does not grow into this decision. **This card is the repo tier and is independent.**
- **ADR-009 D3** — the framework is the plugin; commands build the structure. The decision that
  removed the archive and created this gap.
- **ADR-008** — why the source index should not be copied into consuming repos.
- **Root `CLAUDE.md`** — its bootstrap instructs reading `framework.yaml`. Whatever replaces that
  is this card's output.
- **DECISION-171** — the `fw-` namespace rule the new build follows but never wrote down; the
  same class of "convention that needs a home."
