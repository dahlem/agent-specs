#!/usr/bin/env bash
# Lint agent frontmatter descriptions against DESCRIPTION-STYLE.md.
#
# Usage:
#   scripts/lint-descriptions.sh           # lint; exit 1 on any error
#   scripts/lint-descriptions.sh --stats   # per-agent size table + totals, no exit code
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

set -uo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$REPO_DIR/agents"
STATS=0
[[ "${1:-}" == "--stats" ]] && STATS=1

# Model tiers an agent may declare. These are FAMILY ALIASES on purpose: an alias
# resolves to the current model in that family, so a new release is picked up with
# no edit here. A dated or fully-qualified id (claude-opus-5, claude-haiku-4-5-2025…)
# pins an agent to a model that will age out, so it is rejected. Adding a tier is a
# deliberate act: extend this list, and record in DESCRIPTION-STYLE.md what capability
# demand it serves.
MODEL_TIERS="opus sonnet haiku fable"

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

  refs="$( { grep -oE '`[a-z0-9]+(-[a-z0-9]+)+`' <<<"$desc" | tr -d '\`'
             grep -oE 'the [a-z0-9]+(-[a-z0-9]+)+ agent([^a-z]|$)' <<<"$desc" \
               | sed -E 's/^the ([a-z0-9-]+) agent.*/\1/'; } | sort -u)"
  while IFS= read -r tok; do
    [[ -z "$tok" ]] && continue
    is_known "$tok" || err "$rel" "reference '$tok' is not an existing agent (add to allowlist if intentional)"
  done <<<"$refs"

done < <(find "$AGENTS_DIR" -name '*.md' | sort)

if [[ $STATS -eq 1 ]]; then
  printf '%-38s %6d %9d %8d\n' "TOTAL (43 agents)" "$total_chars" "$total_examples" "$((total_chars / 4))"
  exit 0
fi

echo "----"
echo "$errors error(s), $warnings warning(s)"
[[ $errors -eq 0 ]]
