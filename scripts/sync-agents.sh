#!/usr/bin/env bash
#
# sync-agents.sh — Symlink repo agent specs into ~/.claude/agents/
#
# Usage: ./scripts/sync-agents.sh
#
# - Finds all .md files under agents/ in the repo
# - Creates symlinks in ~/.claude/agents/ for each
# - Warns (does not overwrite) if a regular file already exists at the target
# - Removes stale symlinks pointing to this repo
# - Idempotent: safe to run repeatedly

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$REPO_ROOT/agents"
TARGET_DIR="$HOME/.claude/agents"

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

echo "Syncing agents from $AGENTS_DIR → $TARGET_DIR"
echo

# Phase 1: Remove stale symlinks (symlinks in target that point into this repo but no longer exist)
for link in "$TARGET_DIR"/*.md; do
    [ -e "$link" ] || [ -L "$link" ] || continue
    if [ -L "$link" ]; then
        link_target="$(readlink "$link")"
        # Check if this symlink points into our repo
        if [[ "$link_target" == "$REPO_ROOT"/* ]]; then
            if [ ! -e "$link_target" ]; then
                echo "  Removing stale symlink: $(basename "$link") → $link_target"
                rm "$link"
            fi
        fi
    fi
done

# Phase 2: Create/update symlinks for all agent specs in the repo
find "$AGENTS_DIR" -name "*.md" -type f | sort | while read -r src; do
    name="$(basename "$src")"
    dest="$TARGET_DIR/$name"

    if [ -L "$dest" ]; then
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo "  OK (exists): $name"
        else
            # Symlink exists but points elsewhere — update it
            rm "$dest"
            ln -s "$src" "$dest"
            echo "  Updated:     $name → $src"
        fi
    elif [ -e "$dest" ]; then
        echo "  WARNING:     $name — regular file exists, skipping (back up and remove to sync)"
    else
        ln -s "$src" "$dest"
        echo "  Created:     $name → $src"
    fi
done

echo
echo "Done. Verify with: ls -la $TARGET_DIR/"
