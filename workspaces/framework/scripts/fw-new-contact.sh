#!/usr/bin/env bash
# fw-new-contact.sh — the create gate for contact records (FEAT-194, BUG-207).
# Copies the plugin's templates/records/contact.md (minus its comment header)
# to workspaces/kb/company/contacts/<slug>.md, creating the registry folder
# (with its pointer README) on first use. The only sanctioned way to create a
# contact record; fw-contacts.sh turns the records into per-workspace views.
#
# Usage: fw-new-contact.sh [--root <dir>] <slug>
#   slug: lowercase name-slug, e.g. jane-doe or jane-doe-acme (collision rule
#   in the template). --root is TESTING ONLY.
set -euo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then ROOT="${2:?--root requires a directory}"; shift 2; fi
[ $# -eq 1 ] || { echo "Usage: fw-new-contact.sh <name-slug>" >&2; exit 1; }
SLUG="$1"
case "$SLUG" in
  *[!a-z0-9-]*|""|-*|*-) echo "Error: slug must be lowercase letters, digits and dashes (e.g. jane-doe), got '$SLUG'" >&2; exit 1 ;;
esac

[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel)"
DOMAIN="$ROOT/workspaces/kb/company"
if [ ! -d "$DOMAIN" ]; then
  echo "Error: no company domain in the knowledgebase — create it first: /fw-new-kb-domain company" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$ROOT/.claude/templates/records/contact.md"
[ -f "$TPL" ] || TPL="$SCRIPT_DIR/../templates/records/contact.md"
[ -f "$TPL" ] || { echo "Error: contact template not found" >&2; exit 1; }

REG="$DOMAIN/contacts"
if [ ! -d "$REG" ]; then
  mkdir -p "$REG"
  cat > "$REG/README.md" <<'EOF'
# Contacts — registry

One record per person (`<name-slug>.md`), created by `/fw-contacts <name>` — the one
authored home for that person's facts (ADR-008). Every workspace `CONTACTS.md` is a
generated view of the `Assigned:` lines here; never edit those views, never add a
person anywhere else.

Everyone the engagement touches lives here, whatever their organisation:
`Affiliation: <org> (customer | vendor | subcontractor | spearit)`.
EOF
  echo "Created: workspaces/kb/company/contacts/ (registry)"
fi

FILE="$REG/$SLUG.md"
if [ -e "$FILE" ]; then
  echo "Error: record already exists: workspaces/kb/company/contacts/$SLUG.md — update it instead of creating a second one" >&2
  exit 1
fi

# Strip the leading HTML comment header (template guidance, not record content).
awk 'BEGIN{skip=0} NR==1 && /^<!--/ {skip=1} { if (!skip) print; if (skip && /-->[[:space:]]*$/) skip=0 }' "$TPL" > "$FILE"
echo "Created: workspaces/kb/company/contacts/$SLUG.md"
echo "Next: fill the required fields (name, Affiliation, Role, Email or Phone, Assigned or Unassigned); leave unknown optionals blank; then run fw-contacts.sh."
