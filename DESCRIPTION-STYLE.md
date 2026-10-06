# Agent Description Style Guide

The frontmatter `description:` field of every agent spec is loaded into **every**
Claude Code session (via `scripts/sync-agents.sh` symlinks) and is the only signal
the router sees when deciding which agent to invoke. Descriptions are therefore
budgeted, structured, and linted. Everything else — philosophy, mission framing,
process detail — belongs in the agent **body**, which is only loaded when the agent
is actually invoked.

Run `scripts/lint-descriptions.sh` to check compliance; `--stats` prints per-agent
sizes and the estimated per-session token load. You should rarely need to run it
by hand — see [Enforcement](#enforcement).

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

   **Close on a consequence, not an inventory.** The trigger's last clause must
   say what the agent is *for* — the failure it prevents, the decision it
   settles, the thing the reader gets. A trigger that ends by listing its own
   subsections tells the router what the agent contains and not when to reach for
   it, and forty-six descriptions built that way read as one voice.

   Compare, from this repository:

   > …a Tier-1/2/3 claim inventory with verbatim quotes, method, evidence,
   > datasets, baselines, assumptions, and the cutoff date bounding its
   > prior-art context.

   > …re-derive the task, datasets, and baselines a paper *should* have used and
   > compare them against what it reports — the answer to the most common
   > top-venue rejection trigger: "they did not compare against the right
   > baselines."

   Both enumerate. The second earns the enumeration by landing somewhere. The
   strongest descriptions here (`baseline-scout`, `proof-chain-cartographer`,
   `reframer`, `lean-library-design-auditor`, `manuscript-update-gate`) all do
   this, and all of them break the comma-list habit the same way.

   An enumeration is not the problem; an enumeration that *is* the sentence is.
   Cut items until the ones left are the ones a router needs, then spend the
   budget you reclaimed on the closing clause.

2. **Parameters** (only for flag-bearing agents): one sentence listing flags with
   allowed values, e.g. `` Configurable by `register` (blog | tutorial | ...). ``
   Values go in the description only when the router needs them to pick between
   siblings. Where a parameter's vocabulary is owned by a doctrine skill, the
   *body* cites the skill and declares any subset; the description carries at
   most the values a user would actually type.
3. **Position** (pipeline agents only), terse and ordinal — see canonical
   numberings below.
4. **Distinct-from** (confusable agents only, last prose sentence):
   `` Distinct from `X` (X's scope) — this agent <boundary>. ``

   Boundary sentences should be **symmetric**: if A disambiguates from B, B
   should disambiguate from A, because the router may be looking at either one.
   Literal symmetry in a cluster of four costs twelve boundary sentences, which
   is more budget than the router gets back — so a one-way boundary is allowed
   when the asymmetry is *declared*, in `scripts/boundary-exceptions.txt`, with
   the reason. Undeclared asymmetry is a lint error; a declaration that no
   longer describes one is a warning, so the file cannot quietly rot.

   The repair that usually beats naming A is a **positive scope statement**: all
   seven current exceptions exist because B's closing clause already says what B
   is for in terms that exclude A — `narrative-clarity-auditor` closes on
   "audits prose clarity only", which rules out theorem rhythm without ever
   mentioning `theorem-presentation-auditor`. If you cannot write that reason,
   write the boundary sentence instead.
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

## Doctrine skills

Four vocabularies are shared by enough agents that a copy in each one drifts.
They live in `skills/` and are symlinked into `~/.claude/skills/` by
`scripts/sync-agents.sh`, which makes them addressable by name from any working
directory — unlike a repo-relative path, which stops resolving the moment a spec
is symlinked into `~/.claude/agents/` and run somewhere else.

| Skill | Owns | Cited by |
|---|---|---|
| `writing-registers` | the eight registers, the knob matrix, the subset rule | the writing auditors, `manuscript-update-gate`, `07`, `proof-tutor` |
| `claim-tiers` | Tier-1/2/3, the authoring vs. describing cardinalities, the significance-tier collision | `scientific-narrative-architect`, `paper-compressor`, `06`, `domain-historian` |
| `verdict-protocol` | the `VERDICT:` line and its four levels | the ten verdict-emitting agents, and `check-evidence-chain.py` |
| `handoff-protocol` | the `HANDOFF:` header, the `wire`/`report` channels, `## Not established`, and the one-meaning-per-term glossary | the peer-review and proof-dissection chains, the orchestrators, the two gates, `research-director`, and both calibration auditors |

An agent **cites** a doctrine skill; it does not restate it. Restating is how the
suite acquired a register column duplicated in `proof-tutor` and seven
mutually-unparseable verdict vocabularies. If you need a variant, declare it as a
variant at the citation site and say why — the subset rule in `writing-registers`
is the worked example.

## Enforcement

The budget is invisible at the moment of editing, which is exactly when it is
cheapest to respect — a description that drifts past its cap taxes every session
in every directory, including sessions that have nothing to do with this
repository. So the rules above are checked by machine at two points, and neither
of them is a habit anyone has to remember:

| When | What runs | How it reaches you |
|---|---|---|
| On every `Write`/`Edit` of a file under `agents/` | `scripts/hooks/spec-lint.sh` → the linter, on that one file | a `PostToolUse` hook wired in `.claude/settings.json`; silent when clean, otherwise the findings land in the turn |
| On every push and pull request | the full linter, `--stats`, and a check that each `skills/<name>/` is well-formed and every skill an agent cites exists | `.github/workflows/lint.yml` |

The hook is repo-local: it lives in `.claude/settings.json`, not your global
settings, so cloning this repository is the whole installation. It lints only
the file that was just edited, and it exits silently for anything outside
`agents/`.

`ERROR` is a hard cap or a broken contract and fails the build. `WARN` is a
judgment the author has to make — the comma-count heuristic and a stale boundary
declaration are both cases where only a reader can tell whether the text is
fine. A warning that keeps firing is a sign the text should change or the
exception should be declared, not that the check should be deleted.

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
- **Lean formalization**: `Stage N of the Lean formalization pipeline` —
  `lean-proof-frontier-analyzer` → `lean-proof-chain-validator` →
  `lean-library-design-auditor`, rejoining the research workflow at phase 10.

These clauses are **parsed**, not just read: `scripts/gen-graph.py` builds the
README's [agent graph](README.md#the-agent-graph) from them, and CI fails when
the two disagree. Keep the wording to the forms above — a stage written any
other way silently drops the agent out of its pipeline and into the
fires-on-a-condition list, which is a visible symptom rather than a silent one,
but still a wrong graph.

Two agents are deliberately *not* pipeline-positioned, and their descriptions say
when they fire rather than what they follow: `manuscript-update-gate` (on every
manuscript change) and `hypothesis-register-keeper` (before every execution).

Note: this file lives at the repo root deliberately — anything under `agents/`
gets symlinked into `~/.claude/agents/` and would be loaded as a pseudo-agent.
