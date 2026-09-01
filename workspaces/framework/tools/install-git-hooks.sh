#!/usr/bin/env bash
# install-git-hooks.sh — install the framework's git hooks into this repo.
# Git hooks are not version-controlled, so each clone runs this once.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$ROOT/.git/hooks/pre-commit"

if [ -e "$DEST" ] && ! grep -q "fw-contacts" "$DEST" 2>/dev/null; then
  echo "Error: $DEST already exists and is not ours — merge by hand." >&2
  exit 1
fi

cp "$HERE/pre-commit" "$DEST"
chmod +x "$DEST"
# Record where the plugin lives so the hook works without CLAUDE_PLUGIN_ROOT.
printf '%s\n' "$(cd "$HERE/.." && pwd)/scripts/fw-contacts.sh" > "$ROOT/.git/fw-contacts-path"

echo "Installed: .git/hooks/pre-commit (CONTACTS.md staleness check)"
