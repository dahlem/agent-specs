#!/usr/bin/env bash
# Agent-spec lint hook (PostToolUse on Write|Edit).
#
# Every `description:` in this repository is loaded into every Claude Code
# session, so a spec that drifts past its budget or breaks the template costs
# tokens in sessions that have nothing to do with it. That cost is invisible at
# the moment of editing, which is exactly when it is cheapest to fix — hence a
# hook rather than a checklist.
#
# Reads the PostToolUse payload on stdin, lints only the file that was edited,
# and returns the linter's complaints as turn context. Silent when clean, and
# silent for any file outside agents/, so it costs one process per edit.
#
# Wired in .claude/settings.json. Nothing to install; it is repo-local.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

file="$(python3 -c '
import json,sys
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
ti = d.get("tool_input") or {}
tr = d.get("tool_response") or {}
print(ti.get("file_path") or tr.get("filePath") or "")
' 2>/dev/null)"

[[ -z "$file" ]] && exit 0
case "$file" in
  "$REPO_DIR"/agents/*.md) ;;
  *) exit 0 ;;
esac

out="$("$REPO_DIR/scripts/lint-descriptions.sh" "$file" 2>&1)"
[[ -z "$out" ]] && exit 0
grep -q '^0 error(s), 0 warning(s)$' <<<"$out" && exit 0

msg="Agent-spec lint on ${file#"$REPO_DIR"/}:

$out

Fix this before the turn ends. Budgets and the description template are in
DESCRIPTION-STYLE.md; an ERROR is a hard cap or a broken contract, a WARN is a
judgment call you should make explicitly rather than inherit."

printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":%s}}\n' \
  "$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
