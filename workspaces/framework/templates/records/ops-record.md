<!-- Operations record template (plugin: templates/records/ops-record.md).
     Created ONLY by fw-new-ops-record.sh, into the root operations/open/ as
     INC-nnn-<slug>.md (incident) or REQ-nnn-<slug>.md (request). One shared
     sequence per operations queue; the PREFIX carries the kind, the FOLDER
     carries the status (open -> onhold -> closed). Never create or move by hand.

     Customer ticket ids (Jira, ServiceNow, ...) go in Customer ref - a
     cross-reference, never our key (0..n of them). Working material (raw logs,
     drafts) lives in a sibling folder named for the id (INC-nnn/) that the move
     engine carries with the record. Closed: and Resolution: are stamped by the
     move engine on -> closed; leave them blank. Delete empty optional fields
     (Due, Customer ref, Contacts) rather than leaving placeholders. -->
# __TITLE__

**ID:** __ID__
**Kind:** __KIND__
**Opened:** __OPENED__
**Due:** __YYYY-MM-DD, or delete__
**Customer ref:** __external ticket id(s), or delete__
**Contacts:** __[Name](../../workspaces/kb/company/contacts/slug.md) links, or delete__
**Closed:**
**Resolution:**

## What happened / What is requested

__Observed symptom and impact (incident), or the requested outcome (request) -
verbatim where possible.__

## Actions

- __YYYY-MM-DD - what was done, by whom__

## Outcome

__How it ended. If an incident produced durable knowledge, link the kb research
case or cookbook recipe here (fw-troubleshoot close gate); otherwise say
"nothing durable" explicitly.__
