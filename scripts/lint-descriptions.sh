#!/usr/bin/env bash
# Lint agent frontmatter descriptions against DESCRIPTION-STYLE.md.
#
# Usage:
#   scripts/lint-descriptions.sh           # lint the whole corpus; exit 1 on any error
#   scripts/lint-descriptions.sh --stats   # per-agent size table + totals, no exit code
#   scripts/lint-descriptions.sh FILE...   # lint only these specs (used by the edit hook)
#
# In FILE mode, paths outside agents/ are skipped silently rather than reported,
# so a hook can hand over whatever file was just edited without pre-filtering.
#
# Checks:
#   1. frontmatter parses (first --- block only; ignores pseudo-frontmatter in bodies)
#   2. keys name/description/model/color present; name == filename
#   3. description is one double-quoted line
#   4. raw length: error > 1300, warn > 1100
#   5. at most 2 examples (`- User:` occurrences)
#   6. opener matches: Use this agent (when|to|after)
#   7. no double-backslash escapes (\\n renders as literal text, not a newline)
#   8. backticked kebab-case tokens and "the X agent" phrases resolve to real agents
#   9. model is a family alias from MODEL_TIERS, never a pinned/dated model id
#  10. trigger is not a bare inventory: warn above TRIGGER_COMMA_WARN commas
#  11. boundary symmetry: if A's description disambiguates from B, B's must
#      disambiguate from A, or the pair must be declared in
#      scripts/boundary-exceptions.txt with a reason (stale entries also flagged)
#
# Deliberately NOT checked: em-dash density. The boundary clause in
# DESCRIPTION-STYLE.md mandates an em-dash, so a density rule would flag the
# schema it is meant to enforce; the measured spread here is 0-4 per description,
# which is not the tell. Judgment about register stays with the author.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$REPO_DIR/agents"
STATS=0
FILE_MODE=0
case "${1:-}" in
  --stats) STATS=1 ;;
  "")      ;;
  -*)      echo "usage: $(basename "$0") [--stats | FILE...]" >&2; exit 64 ;;
  *)       FILE_MODE=1 ;;
esac

# Emit the set of specs to lint: the whole corpus, or just the arguments that
# resolve to a .md under agents/.
spec_list() {
  if [[ $FILE_MODE -eq 0 ]]; then
    find "$AGENTS_DIR" -name '*.md' | sort
    return
  fi
  local f abs
  for f in "$@"; do
    abs="$(cd "$(dirname "$f")" 2>/dev/null && pwd -P)/$(basename "$f")" || continue
    [[ "$abs" == "$AGENTS_DIR"/*.md ]] && [[ -f "$abs" ]] && printf '%s\n' "$abs"
  done
}

# Model tiers an agent may declare. These are FAMILY ALIASES on purpose: an alias
# resolves to the current model in that family, so a new release is picked up with
# no edit here. A dated or fully-qualified id (claude-opus-5, claude-haiku-4-5-2025…)
# pins an agent to a model that will age out, so it is rejected. Adding a tier is a
# deliberate act: extend this list, and record in DESCRIPTION-STYLE.md what capability
# demand it serves.
MODEL_TIERS="opus sonnet haiku fable"

# A trigger sentence carrying this many commas is enumerating rather than saying
# what the agent is for — see "Close on a consequence, not an inventory" in
# DESCRIPTION-STYLE.md. Warn, never error: a long enumeration that lands on a
# claim is fine, and only a reader can tell the difference. Measured spread when
# this was introduced: median 6, max 13.
TRIGGER_COMMA_WARN=8

# Kebab-case tokens that are legitimately not agent names.
ALLOWLIST="math-brainstorming proof-building peer-review research-shaping proof-dissection
load-bearing best-paper test-of-time distill-pub cs-lg first-principles top-tier
definition-of-done claim-evidence prior-art cutoff-bounded"

AGENT_NAMES="$(find "$AGENTS_DIR" -name '*.md' -exec basename {} .md \; | sort)"

is_known() {
  local tok="$1"
  grep -qxF "$tok" <<<"$AGENT_NAMES" && return 0
  grep -qwF "$tok" <<<"$ALLOWLIST" && return 0
  return 1
}

errors=0
warnings=0
total_chars=0
total_examples=0
total_agents=0

err()  { echo "ERROR $1: $2"; errors=$((errors + 1)); }
warn() { echo "WARN  $1: $2"; warnings=$((warnings + 1)); }

[[ $STATS -eq 1 ]] && printf '%-38s %6s %9s %8s\n' "agent" "chars" "examples" "~tokens"

while IFS= read -r file; do
  base="$(basename "$file" .md)"
  rel="${file#"$REPO_DIR"/}"

  fm="$(awk 'NR==1 { if ($0 != "---") exit 1; next } /^---$/ { exit } { print }' "$file")"
  if [[ -z "$fm" ]]; then
    err "$rel" "no frontmatter block"
    continue
  fi

  for key in name description model color; do
    n="$(grep -c "^$key: " <<<"$fm")"
    [[ "$n" -eq 1 ]] || err "$rel" "key '$key' appears $n times (want 1)"
  done

  name_val="$(sed -n 's/^name: //p' <<<"$fm" | head -1)"
  [[ "$name_val" == "$base" ]] || err "$rel" "name '$name_val' != filename '$base'"

  model_val="$(sed -n 's/^model: //p' <<<"$fm" | head -1)"
  if [[ "$model_val" =~ [0-9] ]]; then
    err "$rel" "model '$model_val' pins a version; use a family alias ($MODEL_TIERS) so new releases are picked up"
  elif ! grep -qw -- "$model_val" <<<"$MODEL_TIERS"; then
    err "$rel" "model '$model_val' is not a known tier ($MODEL_TIERS)"
  fi

  desc_line="$(grep -m1 '^description: ' <<<"$fm")"
  if [[ ! "$desc_line" =~ ^description:\ \".*\"$ ]]; then
    err "$rel" "description is not a single double-quoted line"
    continue
  fi
  desc="${desc_line#description: \"}"
  desc="${desc%\"}"

  len=${#desc}
  n_ex="$(grep -c -- '- User:' <<<"${desc//\\n/$'\n'}" || true)"
  total_agents=$((total_agents + 1))
  total_chars=$((total_chars + len))
  total_examples=$((total_examples + n_ex))

  if [[ $STATS -eq 1 ]]; then
    printf '%-38s %6d %9d %8d\n' "$base" "$len" "$n_ex" "$((len / 4))"
    continue
  fi

  if [[ $len -gt 1300 ]]; then
    err "$rel" "description $len chars > 1300 hard cap"
  elif [[ $len -gt 1100 ]]; then
    warn "$rel" "description $len chars > 1100 budget"
  fi

  [[ $n_ex -le 2 ]] || err "$rel" "$n_ex examples (max 2)"
  [[ $n_ex -ge 1 ]] || warn "$rel" "no examples"

  [[ "$desc" =~ ^Use\ this\ agent\ (when|to|after)\  ]] \
    || err "$rel" "opener must be 'Use this agent (when|to|after) ...'"

  grep -qF '\\n' <<<"$desc_line" \
    && err "$rel" "double-backslash escape (\\\\n) — use \\n"

  # Trigger = everything before the examples block.
  trigger="${desc%%\\n\\nExample*}"
  n_commas="$(tr -cd ',' <<<"$trigger" | wc -c | tr -d ' ')"
  if [[ $n_commas -ge $TRIGGER_COMMA_WARN ]]; then
    warn "$rel" "trigger carries $n_commas commas — check it closes on a consequence, not an inventory"
  fi

  refs="$( { grep -oE '`[a-z0-9]+(-[a-z0-9]+)+`' <<<"$desc" | tr -d '\`'
             grep -oE 'the [a-z0-9]+(-[a-z0-9]+)+ agent([^a-z]|$)' <<<"$desc" \
               | sed -E 's/^the ([a-z0-9-]+) agent.*/\1/'; } | sort -u)"
  while IFS= read -r tok; do
    [[ -z "$tok" ]] && continue
    is_known "$tok" || err "$rel" "reference '$tok' is not an existing agent (add to allowlist if intentional)"
  done <<<"$refs"

done < <(spec_list "$@")

if [[ $STATS -eq 1 ]]; then
  printf '%-38s %6d %9d %8d\n' "TOTAL ($total_agents agents)" "$total_chars" "$total_examples" "$((total_chars / 4))"
  exit 0
fi

# --- Check 11: boundary symmetry --------------------------------------------
# Needs the whole corpus in memory to answer "does B name A", so it runs as one
# pass after the per-file loop rather than inside it. In file mode it reports a
# pair when either side is among the files under lint, because the asymmetry can
# be introduced from either end.
sym_out="$(python3 "$REPO_DIR/scripts/check-boundaries.py" "$AGENTS_DIR" \
             "$REPO_DIR/scripts/boundary-exceptions.txt" $(spec_list "$@") 2>&1)"
if [[ -n "$sym_out" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    case "$line" in
      WARN*) warn "boundaries" "${line#WARN }" ;;
      *)     err  "boundaries" "$line" ;;
    esac
  done <<<"$sym_out"
fi

# In file mode a silent run means clean; the hook only wants to speak up when
# there is something to say.
if [[ $FILE_MODE -eq 1 && $total_agents -eq 0 && -z "$sym_out" ]]; then
  exit 0
fi

echo "----"
echo "$errors error(s), $warnings warning(s)"
[[ $errors -eq 0 ]]
