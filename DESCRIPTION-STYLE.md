# Agent Description Style Guide

The frontmatter `description:` field of every agent spec is loaded into **every**
Claude Code session (via `scripts/sync-agents.sh` symlinks) and is the only signal
the router sees when deciding which agent to invoke. Descriptions are therefore
budgeted, structured, and linted. Everything else — philosophy, mission framing,
process detail — belongs in the agent **body**, which is only loaded when the agent
is actually invoked.

Run `scripts/lint-descriptions.sh` to check compliance; `--stats` prints per-agent
sizes and the estimated per-session token load.

## Format

- Single physical line: a YAML **double-quoted scalar** with `\n` escapes for line
  breaks and `\"` for inner quotes. Never `\\n` (double backslash).
- Frontmatter keys, in order: `name`, `description`, `model`, `color`.
  `name` must equal the filename minus `.md`.

## Template

Prose fields in this order, then examples:

```
<TRIGGER> <PARAMETERS?> <POSITION?> <DISTINCT-FROM?>\n\nExamples:\n\n- User: "..."\n  Assistant: "I'll use the <exact-name> agent to ..."
```

1. **Trigger** (required, 1–2 sentences). Exactly three sanctioned openers:
   - `Use this agent when <situation>.` — situational agents
   - `Use this agent to <task>.` — tool-shaped agents
   - `Use this agent after <upstream> to <task>.` — pipeline workers
2. **Parameters** (only for flag-bearing agents): one sentence listing flags with
   allowed values, e.g. `` Configurable by `register` (blog | tutorial | ...). ``
3. **Position** (pipeline agents only), terse and ordinal — see canonical
   numberings below.
4. **Distinct-from** (confusable agents only, last prose sentence):
   `` Distinct from `X` (X's scope) — this agent <boundary>. ``
   Boundary sentences must be **symmetric**: if A disambiguates from B, B must
   disambiguate from A.
5. **Examples**: **1 canonical example** by default. A **2nd example only if it
   demonstrates a boundary** — a near-miss phrasing routed to the sibling agent, or
   the flag that distinguishes siblings. A 2nd example that merely restates the
   first with different nouns gets deleted. Assistant lines must reference the
   **exact frontmatter name** (`the 01-research-framing-validator agent`, not
   `the research-framing-validator agent`).

## Budgets (raw scalar characters)

- ≤ 800 for non-confusable agents
- ≤ 1,100 for cluster agents carrying disambiguation + a boundary example (lint warns above this)
- 1,300 hard cap (lint error)

## Canonical pipeline numberings

- **Research phases**: `Phase NN of the 10-phase research workflow (after <NN-1>-…; before <NN+1>-…).`
- **Peer review**: Stage 1 `paper-compressor` → Stage 2 `literature-expansion` →
  Stage 3 `baseline-scout` ∥ `domain-historian` (+ conditional `math-review-router`
  when `theory_heavy: true`) → Stage 4 `claim-interrogator` → Stage 5 `ai-paper-reviewer`.
- **Proof dissection**: compress → cartography → optional adversarial → tutor.
- **Research shaping**: `research-divergence-cartographer` → `red-thread-selector`
  → optional Sculpt Mode → `06-argument-architect` handoff.
- **Math brainstorming cycle**: `reframer` → `perturber` / `math-constructor` →
  `obstructor` → `math-strategist` → `research-director` (one relational clause per agent).

Note: this file lives at the repo root deliberately — anything under `agents/`
gets symlinked into `~/.claude/agents/` and would be loaded as a pseudo-agent.
