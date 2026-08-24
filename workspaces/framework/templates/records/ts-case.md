<!-- Troubleshooting case template (plugin: templates/records/ts-case.md).
     A case is a FOLDER: workspaces/kb/<domain>/research/<symptom-slug>/ with
     this file as its README.md, plus evidence/ and scripts/ only if used.
     The slug is SYMPTOM-FIRST (licenses-drop-after-vpn-reconnect) — future
     searches are by symptom, never by case number. The fw-troubleshoot skill
     walks the method and keeps this file current DURING the investigation —
     capture as you go, never end-of-case archaeology.

     Required: the # symptom heading, Status, Environment. Delete optional
     fields that don't apply rather than leaving placeholders. -->
# __SYMPTOM_AS_ONE_SENTENCE__

**Status:** __investigating | resolved | refuted__
**Environment:** __product(s) + exact versions this is proven on — conclusions are valid ONLY for these__
**Opened:** __YYYY-MM-DD__  **Resolved:** __YYYY-MM-DD or blank__
**Ops record:** __INC-nnn, or none__
**Customer ref:** __external ticket id(s), or none__
**Contacts:** __[Name](../../../company/contacts/slug.md) links, or none__

## Symptom

__What is observed, verbatim where possible — error text, frequency, trigger.__

## Hypotheses and Evidence

| # | Hypothesis | Test | Evidence | Verdict |
|---|-----------|------|----------|---------|
| 1 | __ | __ | __evidence/<file> or inline__ | __confirmed / refuted / open__ |

## Conclusion

__What was proven, and the mechanism. Valid for the Environment above; if a
later version refutes this, revise and note the refutation here.__

## Fix

__The repeatable recipe lives in cookbook/ (symptom-first title) and LINKS this
case as its proof — put only the link here. A one-off fix is written out here
in full. "Nothing durable" is a legitimate conclusion — say so explicitly.__

## Artifacts

- `evidence/` — **curated and scrubbed only**: what discriminated between
  hypotheses. Raw customer logs (PII, credentials) stay in git-ignored scratch;
  keep pointers, not copies.
- `scripts/` — one-shot diagnostic proofs. **Promotion test:** a script you
  will run again is product material (its own product workspace or toolbox) —
  promote it and link it here; the case keeps only the frozen proof.
