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

## Model selection

The `model:` key sets which model tier an agent runs on. Two rules keep this from
rotting as the model lineup changes.

**Always a family alias, never a pinned id.** `opus`, `sonnet`, `haiku`, `fable` —
an alias resolves to the current model in that family, so a new release is picked
up with no edit to this repository. `claude-opus-5` or a dated id pins an agent to
a model that will age out. `scripts/lint-descriptions.sh` rejects anything
containing a digit, and anything outside the tier list.

**Assign by capability demand, not by reputation.** State what the agent's hardest
step actually requires, so the choice can be re-evaluated against a model that does
not exist yet:

| Demand the agent's hardest step makes | Tier |
|---|---|
| **Scientific judgment**: adversarial search for counterexamples, verdicts a competent reviewer would contest, deciding whether a hedge is honest, distinguishing a refutation from an abandonment, constructing the object that separates two readings | `fable` |
| **Cross-artifact synthesis** where the finding is a property of the *set* — shape diagnostics, spine-to-contribution ratios, orphan sweeps in both directions, totality over a claim surface | `fable` |
| **Substantial reasoning along a specified path**: structured extraction with tiering judgment, dependency maps, protocol and format conformance, orchestration and routing between other agents | `opus` |
| **Mechanical passes** with a decision procedure that fits in the prompt — indexing, retrieval, formatting | `sonnet` |

The distribution is deliberately top-heavy (30 / 15 / 1): this repository is almost
entirely science work, and science work is the first two rows. The mid tier is for
agents that *serve* the judgment — compressors, cartographers, orchestrators, and
provenance tracers — whose hard part is coverage and fidelity rather than verdict.

**Re-tier by re-reading the table, never by shifting everything one notch.** A
blanket promotion preserves whatever misalignment the old split had; it is the
relative ordering that needs re-deriving. When this repository moved to three tiers,
four agents went from the *bottom* tier straight to the top — `03`, `05`, `06`, and
`09` had all grown adversarial passes since they were first assigned — while fifteen
`opus` agents stayed put and became the mid tier. Neither group moved by one step.

**When a new model ships**, do not rename tiers across the repository. Add it to
`MODEL_TIERS`, write down which row of the table it satisfies and on what evidence,
then move individual agents deliberately. An agent whose spec has grown — new
adversarial passes, new cross-artifact synthesis — may have outgrown its tier
regardless of what shipped; that is a re-read of the table, not an upgrade.

## Canonical pipeline numberings

- **Research phases**: `Phase NN of the 10-phase research workflow (after <NN-1>-…; before <NN+1>-…).`
- **Peer review**: Stage 1 `paper-compressor` → Stage 2 `literature-expansion` →
  Stage 3 `baseline-scout` ∥ `domain-historian` (+ conditional `math-review-router`
  when `theory_heavy: true`, + optional `hypothesis-register-keeper` with
  `op: reconstruct`) → Stage 4 `claim-interrogator` → Stage 5 `ai-paper-reviewer`.
- **Proof dissection**: compress → cartography → optional adversarial → tutor.
- **Research shaping**: `research-divergence-cartographer` → `red-thread-selector`
  → optional Sculpt Mode → `06-argument-architect` handoff.
- **Math brainstorming cycle**: `reframer` → `perturber` / `math-constructor` →
  `obstructor` → `math-strategist` → `research-director` (one relational clause per agent).

Two agents are deliberately *not* pipeline-positioned, and their descriptions say
when they fire rather than what they follow: `manuscript-update-gate` (on every
manuscript change) and `hypothesis-register-keeper` (before every execution).

Note: this file lives at the repo root deliberately — anything under `agents/`
gets symlinked into `~/.claude/agents/` and would be loaded as a pseudo-agent.
