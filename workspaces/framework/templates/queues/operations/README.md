# Operations

The root operations queue (ADR-009 D2 as amended by TASK-213) — a card store, not a
workspace. Records are `INC-nnn` incidents and `REQ-nnn` requests, created only by
`/fw-new-ops-record`; the folder carries the status (`open/` → `onhold/` → `closed/`),
moved only by `/fw-move`. Prior-year closed records are swept into `closed/YYYY/`
buckets. Working material lives in a sibling folder named for the id (`INC-nnn/`) that
moves with its record.
