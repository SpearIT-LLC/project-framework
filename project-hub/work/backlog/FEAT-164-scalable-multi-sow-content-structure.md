# Feature: Scalable Multi-SOW Content Folder Structure

**ID:** FEAT-164
**Type:** Feature
**Priority:** Medium
**Version Impact:** MINOR
**Created:** 2026-07-02
**Theme:** Project Guidance
**Planning Period:** [Optional]

---

## Summary

Define a documented, repeatable content folder structure for the multi-SOW
single-customer model (ADR-005): where shared customer context lives, where each
SOW's deliverables and docs live, and how a new SOW is stood up — so that setup is
a checklist, not an improvisation.

## Motivation

ADR-005 adopts an **`engagement`**-type customer repo (new project type, see
FEAT-165) with **streams** as folders. The cited precedent (HPC `customers/honda/*`)
grew by accretion, not design. To avoid repeating that, the framework should ship a
reference layout and a "start a new stream" procedure so future-Gary (or a
contractor granted repo access) can set one up in minutes.

**Terminology (per ADR-005):** the container is a **stream** — a bounded body of
work whose granularity the customer chooses (an SOW, a deliverable, or a phase). The
term is deliberately generic because in Gary's new project a stream ≈ an SOW, while
in HPC/Honda a stream ≈ a deliverable (several under one SOW). Each stream folder may
contain a `deliverables/` subfolder for shippable output alongside internal
`notes/` / `research/`.

## Scope

**In:**
- A reference layout for the customer repo (`customer/`, `streams/<slug>/` with an
  optional `deliverables/` subfolder, root spine files) — the diagram agreed in
  ADR-005, formalized.
- A **"start a new stream" procedure**: create the folder, set the stream
  convention on work items, wire deliverables/history location.
- Guidance on the `customer/` shared-context folder: contacts, systems, standing
  decisions — and the **secrets-never-in-repo / vault-pointer** rule plus a strict
  root `.gitignore` recommendation.
- A pattern doc (or addition to an existing guide) capturing the end-to-end model.

**Out (this item):**
- Theme reporting/history commands (see FEAT-163).
- Any automated scaffolding tool (could be a later item; document manual steps first).

## Acceptance Criteria

- [ ] Reference layout documented (matches ADR-005 diagram).
- [ ] Step-by-step "add a new SOW" procedure exists.
- [ ] Shared-context folder conventions documented, including secrets handling.
- [ ] A contractor with repo access could follow the doc without tribal knowledge.

## Notes

- Consider whether this warrants a `templates/` scaffold (copy-paste customer repo
  skeleton) in a follow-up, or whether documentation is sufficient for now.
- Keep it solo-contractor-appropriate: low ceremony, no fleet management.

## Related

- ADR-005 (multi-SOW / engagement customer repo model)
- FEAT-163 (stream-aware reporting and history)
- FEAT-165 (introduce the `engagement` project type)
