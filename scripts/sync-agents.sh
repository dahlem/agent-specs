#!/usr/bin/env bash
#
# sync-agents.sh — Symlink repo agent specs and skills into ~/.claude/
#
# Usage: ./scripts/sync-agents.sh
#
# - Finds all .md files under agents/ and symlinks them into ~/.claude/agents/
# - Finds all skills/<name>/ directories and symlinks them into ~/.claude/skills/
# - Warns (does not overwrite) if a regular file or directory already exists
# - Removes stale symlinks pointing to this repo
# - Idempotent: safe to run repeatedly
#
# Skills carry the doctrine several agents share — registers, claim tiers, the
# verdict protocol. They are symlinked rather than copied so an agent spec and
# the doctrine it cites can never be at different versions.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$REPO_ROOT/agents"
SKILLS_DIR="$REPO_ROOT/skills"
TARGET_DIR="$HOME/.claude/agents"
SKILLS_TARGET="$HOME/.claude/skills"

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Track which symlinks we expect to exist
declare -A expected_links

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

# Phase 3: Symlink skill directories
if [ -d "$SKILLS_DIR" ]; then
    echo
    echo "Syncing skills from $SKILLS_DIR → $SKILLS_TARGET"
    echo
    mkdir -p "$SKILLS_TARGET"

    # Remove stale skill symlinks pointing into this repo
    for link in "$SKILLS_TARGET"/*; do
        [ -L "$link" ] || continue
        link_target="$(readlink "$link")"
        if [[ "$link_target" == "$REPO_ROOT"/* ]] && [ ! -e "$link_target" ]; then
            echo "  Removing stale symlink: $(basename "$link") → $link_target"
            rm "$link"
        fi
    done

    for src in "$SKILLS_DIR"/*/; do
        [ -d "$src" ] || continue
        src="${src%/}"
        name="$(basename "$src")"
        dest="$SKILLS_TARGET/$name"

        if [ ! -f "$src/SKILL.md" ]; then
            echo "  WARNING:     $name — no SKILL.md, skipping"
            continue
        fi

        if [ -L "$dest" ]; then
            if [ "$(readlink "$dest")" = "$src" ]; then
                echo "  OK (exists): $name"
            else
                rm "$dest"
                ln -s "$src" "$dest"
                echo "  Updated:     $name → $src"
            fi
        elif [ -e "$dest" ]; then
            echo "  WARNING:     $name — real directory exists, skipping (back up and remove to sync)"
        else
            ln -s "$src" "$dest"
            echo "  Created:     $name → $src"
        fi
    done
fi

echo
echo "Done. Verify with: ls -la $TARGET_DIR/ $SKILLS_TARGET/"
