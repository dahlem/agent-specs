#!/usr/bin/env bash
# Manuscript writing-gate hook.
#
# Exposition decays on every edit, so the gate must fire on change rather than
# once. Agent specs describe what the gate checks; this makes Claude Code
# actually notice the manuscript moved.
#
# INSTALL ONCE, GLOBALLY. These hooks live in ~/.claude/settings.json and apply
# to every session in every directory:
#
#   scripts/install-writing-gate.sh --global
#
# They are inert everywhere except in directories marked as papers, so a global
# install costs nothing in code repositories. Mark each paper once:
#
#   scripts/install-writing-gate.sh init <paper-repo>
#
# which writes .manuscript-gate.json — the marker AND the per-paper config.
# No marker, no gate: both subcommands exit immediately. That check comes first,
# before any filesystem scan, so the cost in a non-paper repo is one stat call.
#
# Subcommands:
#   notify — PostToolUse: if an edited file is manuscript source, name it and
#            put the gate on the table for this turn.
#   check  — Stop: compare the manuscript against writing_ledger.md's manifest;
#            if the ledger is missing or stale, block the turn and say why.
#
# .manuscript-gate.json (all keys optional):
#   { "globs": ["*.tex"], "ledger": "writing_ledger.md", "register": "theoretical-paper" }
#
# Env overrides (mostly for testing): MANUSCRIPT_ROOT, MANUSCRIPT_GLOBS,
# WRITING_LEDGER, MANUSCRIPT_ARTIFACTS.

set -uo pipefail

MARKER_NAME=".manuscript-gate.json"

# --- Locate the paper root: nearest ancestor holding the marker. -------------
find_paper_root() {
  if [[ -n "${MANUSCRIPT_ROOT:-}" ]]; then
    [[ -f "$MANUSCRIPT_ROOT/$MARKER_NAME" ]] && { printf '%s\n' "$MANUSCRIPT_ROOT"; return 0; }
    return 1
  fi
  local d; d="$(pwd -P)"
  while [[ "$d" != "/" ]]; do
    [[ -f "$d/$MARKER_NAME" ]] && { printf '%s\n' "$d"; return 0; }
    d="$(dirname "$d")"
  done
  return 1
}

ROOT="$(find_paper_root)" || exit 0        # not a paper directory: do nothing
MARKER="$ROOT/$MARKER_NAME"

cfg() {  # cfg <key> <default>
  python3 -c '
import json,sys
try: d = json.load(open(sys.argv[1]))
except Exception: d = {}
v = d.get(sys.argv[2], sys.argv[3])
print(" ".join(v) if isinstance(v, list) else v)
' "$MARKER" "$1" "$2" 2>/dev/null || printf '%s' "$2"
}

GLOBS="${MANUSCRIPT_GLOBS:-$(cfg globs '*.tex')}"
LEDGER="${WRITING_LEDGER:-$(cfg ledger 'writing_ledger.md')}"
ARTIFACTS="${MANUSCRIPT_ARTIFACTS:-writing_ledger.md notation_ledger.md claim_ledger.md reconciliation.md shadow_register.md}"

json_escape() { python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'; }

is_manuscript() {
  local f="${1##*/}"
  for g in $GLOBS; do
    # shellcheck disable=SC2053
    [[ "$f" == $g ]] && return 0
  done
  return 1
}

# Generated artifacts match the globs but are not source. The ledger in
# particular can never hash-match itself, since it records the hashes.
is_artifact() {
  local f="${1##*/}"
  [[ "$f" == "${LEDGER##*/}" ]] && return 0
  for a in $ARTIFACTS; do [[ "$f" == "$a" ]] && return 0; done
  return 1
}

manuscript_files() {
  local args=()
  for g in $GLOBS; do args+=(-name "$g" -o); done
  unset 'args[${#args[@]}-1]'
  find "$ROOT" \
    \( -path '*/.git' -o -path '*/node_modules' -o -path '*/_build' -o -path '*/build' \
       -o -path '*/hypothesis-register' -o -path '*/research-memory' \) -prune -o \
    -type f \( "${args[@]}" \) -print 2>/dev/null \
  | while IFS= read -r f; do is_artifact "$f" || printf '%s\n' "$f"; done | LC_ALL=C sort
}

manifest_now() {
  while IFS= read -r f; do
    printf '%s  %s\n' "$(shasum -a 256 "$f" 2>/dev/null | cut -d' ' -f1)" "${f#"$ROOT"/}"
  done < <(manuscript_files)
}

case "${1:-}" in
  notify)
    payload="$(cat)"
    file="$(printf '%s' "$payload" | python3 -c '
import json,sys
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
ti = d.get("tool_input") or {}
tr = d.get("tool_response") or {}
print(ti.get("file_path") or tr.get("filePath") or "")
' 2>/dev/null)"
    [[ -z "$file" ]] && exit 0
    is_manuscript "$file" || exit 0
    is_artifact "$file" && exit 0
    # Resolve before stripping: on macOS /tmp is a symlink, and ROOT comes from
    # `pwd -P`, so an unresolved path would never match the prefix.
    file="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$file" 2>/dev/null || printf '%s' "$file")"
    msg="Manuscript source changed: ${file#"$ROOT"/}

Exposition does not survive editing the way correctness does. Before this turn ends, run the manuscript-update-gate agent (mode: delta) over the diff — it re-checks the so-what distribution contract, the notation ledger, placement, and cross-section seams, and routes depth to the writing auditors."
    printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":%s}}\n' "$(printf '%s' "$msg" | json_escape)"
    exit 0
    ;;

  check)
    cat >/dev/null 2>&1 || true
    ledger="$ROOT/$LEDGER"
    changed=""

    if [[ ! -f "$ledger" ]]; then
      [[ -z "$(manuscript_files)" ]] && exit 0
      changed="  (no $LEDGER in this paper yet)"$'\n'
    else
      while IFS= read -r line; do
        h="${line%% *}"; f="${line##*  }"
        grep -qF "$h" "$ledger" 2>/dev/null || changed+="  - $f"$'\n'
      done < <(manifest_now)
    fi

    [[ -z "$changed" ]] && exit 0

    reason="The writing gate has not run against the current manuscript ($(basename "$ROOT")).

Unreconciled:
$changed
Run the manuscript-update-gate agent (mode: delta, or full if there is no prior ledger) and let it write $LEDGER with a fresh manifest. It owns the so-what distribution contract, the notation ledger, spine/appendix/cut placement, and cross-section continuity."
    printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | json_escape)"
    exit 0
    ;;

  *)
    echo "usage: manuscript-gate.sh {notify|check}" >&2
    exit 64
    ;;
esac
