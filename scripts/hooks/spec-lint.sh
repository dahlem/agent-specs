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
# and returns the complaints as turn context. Silent when clean.
#
# Two checks, on different file sets, because they catch different drift:
#
#   agents/*.md                       the description linter, on that one file
#   the two apparatus-vocabulary      check-glossary.py, which is repo-wide
#   files (skill + leakage sweep)     because the pair spans two files
#
# narrative-clarity-auditor.md is in both sets and can report both. Anything in
# neither exits immediately, so an ordinary edit costs one process.
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

rel="${file#"$REPO_DIR"/}"
msg=""

# The apparatus glossary and the leakage sweep are one list in two files, so
# either edit can break the pair. CI catches it; catching it in the turn that
# caused it is cheaper, and the fix is obvious only while the edit is fresh.
case "$rel" in
  skills/handoff-protocol/SKILL.md|agents/writing/narrative-clarity-auditor.md)
    if gout="$("$REPO_DIR/scripts/check-glossary.py" 2>&1)"; then :; else
      msg="Glossary check on $rel:

$gout

The handoff-protocol glossary and narrative-clarity-auditor's apparatus-leakage
sweep are one list read in two directions. Add the term to the other side, or
drop it from this one."
    fi
    ;;
esac

case "$file" in
  "$REPO_DIR"/agents/*.md) ;;
  *)
    [[ -n "$msg" ]] && printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":%s}}\n' \
      "$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
    exit 0
    ;;
esac

out="$("$REPO_DIR/scripts/lint-descriptions.sh" "$file" 2>&1)"
if [[ -n "$out" ]] && ! grep -q '^0 error(s), 0 warning(s)$' <<<"$out"; then
  msg="${msg:+$msg

}Agent-spec lint on $rel:

$out

Fix this before the turn ends. Budgets and the description template are in
DESCRIPTION-STYLE.md; an ERROR is a hard cap or a broken contract, a WARN is a
judgment call you should make explicitly rather than inherit."
fi

[[ -z "$msg" ]] && exit 0

printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":%s}}\n' \
  "$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
