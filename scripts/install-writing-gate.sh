#!/usr/bin/env bash
# Install the manuscript writing gate.
#
#   scripts/install-writing-gate.sh --global          # once per machine
#   scripts/install-writing-gate.sh init <paper-repo> # once per paper
#   scripts/install-writing-gate.sh --repo <dir>      # team-wide, committed
#
# The hooks are inert outside marked paper directories, so --global is the
# normal path: install once, and every session in every directory has the gate
# without further setup. Each paper opts in with `init`, which writes the
# .manuscript-gate.json marker and its per-paper config.
#
# --repo exists for papers whose hooks should be shared with co-authors through
# the repository's own .claude/settings.json; it is redundant with --global for
# your own machine. Add --local to write settings.local.json (gitignored).

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$REPO_DIR/scripts/hooks/manuscript-gate.sh"
[[ -x "$HOOK" ]] || { echo "hook not executable: $HOOK" >&2; exit 70; }

wire() {  # wire <settings-file>
  local settings="$1"
  mkdir -p "$(dirname "$settings")"
  [[ -f "$settings" ]] || echo '{}' > "$settings"
  python3 - "$settings" "$HOOK" <<'PY'
import json, sys, pathlib

path, hook = pathlib.Path(sys.argv[1]), sys.argv[2]
try:
    cfg = json.loads(path.read_text() or "{}")
except json.JSONDecodeError:
    sys.exit(f"refusing to write: {path} is not valid JSON (fix it first — a broken "
             "settings file silently disables every setting in it)")
hooks = cfg.setdefault("hooks", {})

def ensure(event, matcher, command, status):
    for entry in hooks.setdefault(event, []):
        if entry.get("matcher") == matcher:
            for h in entry.get("hooks", []):
                if h.get("type") == "command" and "manuscript-gate.sh" in h.get("command", ""):
                    h["command"] = command       # refresh an existing install
                    return "refreshed"
            entry.setdefault("hooks", []).append(
                {"type": "command", "command": command, "statusMessage": status, "timeout": 30})
            return "added"
    new = {"hooks": [{"type": "command", "command": command, "statusMessage": status, "timeout": 30}]}
    if matcher is not None:
        new["matcher"] = matcher
    hooks[event].append(new)
    return "added"

r1 = ensure("PostToolUse", "Write|Edit|MultiEdit", f'"{hook}" notify', "Checking manuscript…")
r2 = ensure("Stop", None, f'"{hook}" check', "Verifying writing gate…")
path.write_text(json.dumps(cfg, indent=2) + "\n")
print(f"  PostToolUse {r1}, Stop {r2} -> {path}")
PY
}

case "${1:-}" in
  --global)
    echo "Installing writing-gate hooks for all sessions:"
    wire "$HOME/.claude/settings.json"
    echo
    echo "Done. Every new session now carries the gate, and it is inert outside"
    echo "directories marked with .manuscript-gate.json. Mark a paper with:"
    echo "  $0 init <paper-repo>"
    echo "Open /hooks once (or restart Claude Code) to load them into this session."
    ;;

  init)
    TARGET="${2:-}"
    [[ -d "$TARGET" ]] || { echo "usage: $0 init <paper-repo>" >&2; exit 64; }
    MARKER="$TARGET/.manuscript-gate.json"
    if [[ -f "$MARKER" ]]; then
      echo "already marked: $MARKER"
    else
      cat > "$MARKER" <<'JSON'
{
  "globs": ["*.tex"],
  "ledger": "writing_ledger.md",
  "register": "theoretical-paper"
}
JSON
      echo "marked as a paper: $MARKER"
      echo "  globs    — manuscript source patterns; add \"*.md\" for a markdown paper"
      echo "  register — passed to the writing auditors (empirical-paper | theoretical-paper | nature-letter | tech-report)"
    fi
    # The marker is per-paper config and belongs in the paper's history, as does
    # writing_ledger.md — it is the gate's record, not a build artifact.
    ;;

  --repo)
    TARGET="${2:-}"
    [[ -d "$TARGET" ]] || { echo "usage: $0 --repo <dir> [--local]" >&2; exit 64; }
    FILE="settings.json"; [[ "${3:-}" == "--local" ]] && FILE="settings.local.json"
    echo "Installing writing-gate hooks into $TARGET:"
    wire "$TARGET/.claude/$FILE"
    if [[ "$FILE" == "settings.local.json" ]]; then
      GI="$TARGET/.gitignore"
      grep -qxF '.claude/settings.local.json' "$GI" 2>/dev/null || echo '.claude/settings.local.json' >> "$GI"
    fi
    echo "Remember to mark the paper too: $0 init $TARGET"
    ;;

  *)
    sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
    exit 64
    ;;
esac
