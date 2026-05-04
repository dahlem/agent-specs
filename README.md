# Agent Specs

Specialized Claude Code agents for rigorous AI research workflows, designed to support high-impact publications at top-tier venues (NeurIPS, ICML, ICLR, JMLR, Nature Machine Intelligence).

## Overview

This repository contains agent specifications organized into five categories:

1. **Research Workflow** — A structured 10-phase methodology for taking research from problem framing through submission, plus cross-phase tools.
2. **Research Shaping** — A diverge-then-converge layer that turns a body of work into the one paper it should become; an expanded entry point into phase 06.
3. **Peer Review** — A coordinated, cutoff-bounded review pipeline that produces structured artifacts for the AI paper reviewer to ground its verdicts in.
4. **Math Brainstorming** — An iterative ecosystem of agents for mathematical problem exploration, construction, and synthesis.
5. **Formal Verification** — Agents for Lean 4 proof development, validation, and documentation.

The research framework operationalizes both **benevolent** and **hostile** reviewer perspectives:

- **Benevolent Reviewer**: Assumes good faith, looks for signal over perfection, asks "Is there a real idea here?"
- **Hostile Reviewer**: Assumes overclaiming, searches for gaps and shortcuts, asks "What justifies rejection?"

A phase succeeds when a hostile reviewer cannot identify a fatal flaw and a benevolent reviewer can articulate why the phase adds value.

## Repository Structure

```
agent-specs/
├── README.md
├── agents/
│   ├── research/
│   │   ├── phases/                              # Sequential research workflow (10 phases)
│   │   │   ├── 01-research-framing-validator.md
│   │   │   ├── 02-literature-discovery-mapper.md
│   │   │   ├── 03-research-design-auditor.md
│   │   │   ├── 04-research-data-architect.md
│   │   │   ├── 05-research-analysis-interpreter.md
│   │   │   ├── 06-argument-architect.md
│   │   │   ├── 07-paper-structure-architect.md
│   │   │   ├── 08-research-revision-validator.md
│   │   │   ├── 09-research-validation-qa.md
│   │   │   └── 10-scholarly-submission-strategist.md
│   │   ├── tools/                               # Cross-phase utility agents
│   │   │   ├── ai-paper-reviewer.md
│   │   │   ├── arxiv-gap-scanner.md
│   │   │   ├── citation-provenance-auditor.md
│   │   │   └── scientific-narrative-architect.md
│   │   ├── peer-review/                         # Coordinated review pipeline (artifacts → ai-paper-reviewer)
│   │   │   ├── paper-compressor.md
│   │   │   ├── literature-expansion.md
│   │   │   ├── baseline-scout.md
│   │   │   ├── domain-historian.md
│   │   │   ├── claim-interrogator.md
│   │   │   └── math-review-router.md
│   │   └── shaping/                             # Diverge → converge: pick the paper hiding in a body of work
│   │       ├── research-divergence-cartographer.md
│   │       └── red-thread-selector.md
│   ├── math-brainstorming/                      # Iterative problem exploration ecosystem
│   │   ├── reframer.md
│   │   ├── perturber.md
│   │   ├── math-constructor.md
│   │   ├── math-strategist.md
│   │   ├── obstructor.md
│   │   └── research-director.md
│   └── formal-verification/
│       └── lean/                                # Lean 4 proof tools
│           ├── lean-proof-chain-validator.md
│           └── lean-proof-frontier-analyzer.md
└── scripts/
    └── sync-agents.sh                           # Symlink agents into ~/.claude/agents/
```

## Research Phases

The 10-phase workflow takes a research idea from initial framing through publication. Each phase produces specific artifacts and has explicit completion criteria.

### Phase 01 — Research Framing Validator

Ensures research problems are rigorously defined and properly scoped before any implementation begins. Evaluates framing across six dimensions: big picture motivation, opportunity identification, solution space exploration, implications, opportunity landscape ranking, and definition-of-done criteria. Rejects buzzword-driven framing and requires first-principles reasoning with explicit separation between theory and empirics.

### Phase 02 — Literature Discovery Mapper

Conducts systematic, theory-anchored literature analysis to position research as addressing *necessary* gaps rather than merely *novel* extensions. Performs epistemic triangulation by mapping conceptual, methodological, and empirical landscapes. Identifies where first principles are violated and assumptions are accidents rather than necessities, producing a positioning statement explaining why the problem remains unsolved.

### Phase 03 — Research Design Auditor

Converts well-framed problems into testable, auditable plans of inquiry. Addresses five pillars — method selection, variables/constructs, data strategy, evaluation metrics, and ethics/reproducibility — ensuring an independent researcher could execute the study without clarification. Applies the meta-success test: can the design fail, would success be believed, would failure be informative?

### Phase 04 — Research Data Architect

Designs, constructs, validates, and documents research data and benchmarks with defensible construct mappings. Bridges hypothesis and evidence by creating construct tables mapping theory to observables, designing collection protocols with sampling justification, and performing quality assurance including schema consistency, leakage detection, and edge case analysis. Documents provenance end-to-end.

### Phase 05 — Research Analysis Interpreter

Converts prepared artifacts into validated findings and defensible insights. Answers four questions: Does the hypothesis hold? Under what assumptions and regimes? Why do results look this way? What survives stress-testing? Rigorously separates demonstrated findings from suggested insights from speculation, with comprehensive robustness testing, ablation studies, and sensitivity analyses.

### Phase 06 — Argument Architect

Transforms validated results into coherent, defensible academic arguments. Enforces claim-evidence-qualification alignment where every central claim has necessary and sufficient evidence, clear scope conditions, and reasoned explanations for why competing interpretations are less plausible. Distills contributions into 1-3 irreducible claims with articulated limitations across theoretical assumptions, regime boundaries, and external validity.

### Phase 07 — Paper Structure Architect

Enforces rigorous narrative architecture where every section answers four core questions (Why exists, What gap, How addressed, So what). Applies concentric narrative arc and progressive elaboration: abstracts compress the entire argument, introductions mirror the abstract at higher resolution, methods make the solution feel unavoidable, and results test claims rather than showcase experiments.

### Phase 08 — Research Revision Validator

Converts correct papers into convincing, defensible, and reproducible ones by closing epistemic loopholes and enforcing traceability. Constructs claim-dependency graphs, enforces linguistic precision (mapping "show" to prove/demonstrate, quantifying "significant"), builds claim-evidence matrices, audits citations for provenance and scope, and reviews visual artifacts for reproducibility.

### Phase 09 — Research Validation QA

Validates work for reproducibility, methodological soundness, ethical compliance, and scholarly integrity. Approaches validation as a hostile but competent third party: "Where would an adversary succeed in invalidating this?" Evaluates three reproducibility levels (internal, external, conceptual) and treats ethical review as a threat model examining data provenance, privacy, bias, and deployment constraints.

### Phase 10 — Scholarly Submission Strategist

Transforms research artifacts into durable scholarly contributions through strategic venue selection, rigorous formatting, and controlled release. Classifies papers on three axes (contribution type, evaluation mode, temporal relevance) for venue alignment. Ensures archival integrity with versioned releases and immutable identifiers. Creates structured response matrices for reviewer feedback.

## Cross-Phase Tools

These agents can be invoked at any point during the research workflow.

### AI Paper Reviewer

Conducts rigorous pre-submission internal reviews using a dual-perspective framework. Evaluates papers across all ten research phases, applying both benevolent and hostile reviewer lenses simultaneously. Identifies fatal flaws that would trigger immediate rejection, provides a prioritized revision roadmap, and issues a conference-readiness score calibrated to top-tier venue acceptance rates (~20-25%).

### Arxiv Gap Scanner

Orchestrates a seven-phase literature-gap scan against a body of work — paper directory, formal-verification module, or research roadmap — over a defined arxiv window. Generates stream-specific queries from open theorems, bulk-fetches abstracts on the main thread (subagents are sandboxed from network), shards triage across parallel `02-literature-discovery-mapper` instances, downloads PDFs under a hard cap, deep-reviews the critical tier (per-paper claim catalogs and reuse plans via `05-research-analysis-interpreter` or `lean-proof-chain-validator`), and synthesises a deadline-sorted action list with an Impact × Effort × Stream matrix. Emits a working scan directory (`anchor.md`, `raw/`, `tracks/`, `pdfs/`, `reviews/`, `scan.md`, optional `roadmap_delta.md`) rather than a single report. Distinct from `02-literature-discovery-mapper` (single-pass landscape mapping) by running the full pipeline including PDF download and per-paper deep review.

### Citation Provenance Auditor

Performs comprehensive citation audits: establishes persistent identifiers (DOI, arXiv, ISBN), verifies BibTeX entries against authoritative sources (Crossref, arXiv, PubMed, DBLP) with field-by-field diffs, maps every citation occurrence to specific claims with evidence pointers and support strength, and assesses canonicality (peer-reviewed over preprint, primary over secondary). Generates provenance files per citation key and TeX annotation comments.

### Scientific Narrative Architect

Constructs scientific writing achieving causal intelligibility at every scale, optimized for mathematically oriented ML venues (NeurIPS theory, COLT, AISTATS, JMLR) as well as Nature/Science and physics/math journals. Beyond clarity, enforces **scientific strategy** through three interlocking frameworks: a **three-tier claim architecture** (core/supporting/peripheral) with explicit scope containment; the **Three Axes of Contribution** model (Theory/Method/Evaluation) requiring axis dominance declaration, alignment verification, and venue-specific coverage; and **Single Mechanism Architecture** ensuring all results derive from one central mechanism (structural principle + mathematical representation + observable consequences). Also enforces narrative tension, theorem–empirical alignment, contribution compression (≤ 5 named objects), figure architecture (four roles), a three-layer reading model, reviewer adversary simulation, and Feynman-style clarity at every scale.

## Research Shaping

A research project rarely has one obvious paper inside it. Bodies of work accumulate results, theorems, experiments, abandoned threads, and surprising observations — and the temptation is to cram all of it into one dense paper with multiple mechanisms and unfocused contributions. The shaping layer addresses this by **deliberately diverging over candidate paper-framings before converging on one**, then sculpting the body of work down to the single red thread that becomes the paper.

This layer is an **expanded entry point into phase 06** (`argument-architect`), not a replacement. Phase 06 already validates and scopes claims that have been chosen; the shaping layer chooses them.

```
body_of_work.md (user-authored manifest)
       │
       ▼
research-divergence-cartographer  ──► candidate_threads.md (5–12 threads, deliberately over-generated)
       │
       ▼
red-thread-selector               ──► red_thread.md (1 chosen + runners-up + score table)
       │
       ▼
scientific-narrative-architect    ──► sculpt_plan.md (keep / move-to-appendix / cut)
   (mode: Sculpt)
       │
       ▼
06-argument-architect (existing) — validates the converged claims;
                                   open-ended distillation is replaced by validation
                                   when red_thread.md is present.
```

If no shaping artifacts are produced, phase 06 behaves exactly as it does today.

### Research Divergence Cartographer

First stage. Reads a user-authored `body_of_work.md` manifest (results, theorems, experiments, datasets, prior drafts, open threads, abandoned attempts, anomalies) and over-generates 5–12 candidate red threads spanning ≥3 distinct novelty types and ≥2 distinct contribution axes. Each thread carries a structured yaml block: core tension, possible core claim, supporting claim sketches, evidence pointers, missing evidence, novelty type, contribution axis, venue fit, risk, significance hypothesis. The agent does not rank, recommend, or favor; selection is downstream. Anti-convergence guardrails prevent synonym-threads, risk-laundering, and pre-ranking.

### Red Thread Selector

Convergence stage. Scores every candidate on six dimensions (novelty, clarity, technical depth, significance, evidence sufficiency, narrative inevitability) and applies six penalties (density, claim sprawl, mixed mechanisms, multi-axis dominance, decorative experiments, unsupported ambition). Mandatory pass/fail mechanism checks — Paper Identity Test and Single Mechanism Test (both from `scientific-narrative-architect`) — apply before scoring; threads that fail either cannot be selected. The selector simulates the dual benevolent/hostile reviewer lens internally per candidate (vocabulary borrowed from `ai-paper-reviewer`, not invoked) and produces an auditable `red_thread.md` with the chosen thread, 2–3 runners-up with disqualifying gaps, rejected threads with reasons, and the full scoring table. If no thread passes the mandatory checks, the agent returns `selection_outcome: deferred` rather than forcing a choice.

**Distinction from research-director**: `research-director` (under `agents/math-brainstorming/`) portfolios *research directions* across novelty / feasibility / insight / risk / tool-availability — its target is a research program. `red-thread-selector` picks *one paper to write now* from a body of work that already exists — its target is a single artifact. The two live in different stages of the research lifecycle.

### Sculpting (in scientific-narrative-architect)

Sculpting is a new **mode** of `scientific-narrative-architect`, not a separate agent. Sculpt Mode reads `red_thread.md` plus the body of work (or a complete draft), re-validates the Paper Identity and Single Mechanism Tests, and applies the **Remove-the-Mechanism Test at the element level** to every result, theorem, figure, experiment, and derivation. Each element is classified into `keep`, `move_to_appendix`, or `cut`, with a one-line justification grounded in mechanism preservation or contribution-axis alignment. The default is `cut`, not `appendix`; the appendix is for genuinely supportive material, not a holding pen for material the author cannot bear to remove. The output, `sculpt_plan.md`, hands off cleanly to phase 06 for argument validation.

### When to use this layer

- You have months of accumulated work and need to decide which paper it should become.
- A draft has grown dense and unfocused; sculpting can identify what is load-bearing.
- Multiple candidate framings are competing in your head and you want them on the page side-by-side.

When the framing is already obvious, skip the shaping layer and start at phase 06.

## Peer Review Ecosystem

The peer-review agents form a **coordinated pipeline** that produces structured artifacts the `ai-paper-reviewer` consumes in its Pipeline Mode. Unlike the math-brainstorming ecosystem, ordering matters: each agent depends on artifacts from the agents upstream of it. The pipeline addresses the failure modes of single-prompt review — anachronistic prior-art, missing baseline scouting, ungrounded significance verdicts, and theory-paper math gaps.

```
paper-compressor              ──► compressed_paper.md
       │
       ├──► literature-expansion ──► prior_art_bundle.md
       │            │
       │            └──► (hands bibkeys to) citation-provenance-auditor
       │
       ├──► domain-historian        ──► significance_rubric.md
       ├──► baseline-scout          ──► baseline_gap_report.md
       ├──► claim-interrogator      ──► interrogation_log.md
       └──► math-review-router*     ──► math_review_bundle.md
                  (* iff theory_heavy=true; delegates to math-brainstorming agents)
                  │
                  ▼
           ai-paper-reviewer (Pipeline Mode)
           — dual benevolent/hostile lens grounded in upstream artifacts
```

### Paper Compressor

First stage. Converts a paper into a precise, lossless-on-claims artifact: Tier-1/2/3 claim inventory with verbatim quotes and section pointers, method skeleton, exhaustive datasets/baselines/metrics tables, paper-stated and implicit assumptions, theorem index, and an inferred `cutoff_date_inferred` that bounds all downstream prior-art search. Issues no judgments — pure extraction with traceability.

### Literature Expansion

Constructs a cutoff-bounded prior-art bundle of 30–50 works across five role buckets: foundational, dataset, SOTA, direct competitor, survey. Hard temporal discipline: no work published after `cutoff_date_inferred` enters the bundle without an explicit exception. For every retrieved work, sets a `missing_from_paper` flag with severity (critical / expected / helpful), producing the Missing-Citation Report. Hands bibkeys to `citation-provenance-auditor` for metadata verification rather than duplicating that work.

### Baseline Scout

The highest-impact stage for empirical-claim review. Runs a strict two-pass protocol: Pass 1 independently re-derives the expected datasets and baselines from task and metric *without* anchoring on the paper's framing; Pass 2 reads the reported set; reconciliation produces a severity-tagged gap report. For each critical or expected gap, names the specific pre-cutoff SOTA reference that should have been compared against and quotes the paper's stated rationale (or `no-rationale`). Anti-anchoring discipline includes explicit restart conditions.

### Domain Historian

Calibrates the significance verdict. Names the specific subfield, sketches its history as 3–7 inflection points up to cutoff, enumerates open problems the field considered live as of cutoff, and defines a *subfield-specific* Tier-1/2/3 contribution rubric. Issues a four-stage calibration verdict (stated → earned → counterfactual at earlier and later dates → final tier) with stage ordering enforced to prevent counterfactual contamination of the at-time judgment. Distinct from `scientific-narrative-architect`: that agent helps writers; the historian helps reviewers.

### Claim Interrogator

For every Tier-1 and Tier-2 claim, generates 3–7 specific questions targeting the weakest defensible point, answers each with paper-internal evidence + external evidence (prior_art_bundle, baseline_gap_report, math_review_bundle), and issues a per-claim verdict (Supported / Partial / Unsupported / Contradicted) with severity (fatal / major / minor / none). Maintains a flat discrepancy log of every observed disagreement between paper-internal and external evidence. Becomes the evidentiary basis the final reviewer cites.

### Math Review Router

Activates when `theory_heavy: true`. Re-validates the gate, restates each Tier-1 theorem with assumptions named, and routes targeted questions to the math-brainstorming agents:

- `reframer`: Is the formalization right? Are alternate encodings missed?
- `perturber`: Which assumptions are essential? Where does the result fail under relaxation?
- `math-constructor`: Counterexamples or boundary cases for Tier-1 theorems?
- `math-strategist`: Are proof dependencies plausible? Hand-waved steps?
- `obstructor`: Adversarial stress-test of theorems and proof technique.

Preserves delegate outputs in their native formats; the synthesis section consolidates without re-judging.

### Pipeline Discipline

- **Cutoff date is the contract**: every downstream agent respects `cutoff_date_inferred`. Anachronism is a category-level failure.
- **Artifacts are explicit**: each agent produces one canonical markdown file consumed by name. No implicit hand-offs.
- **Severity calibration is shared**: `critical` / `fatal` levels propagate across `prior_art_bundle.md` (missing-citation severity) → `baseline_gap_report.md` (gap severity) → `interrogation_log.md` (verdict severity) → `ai-paper-reviewer` (fatal-flaw enumeration).
- **Graceful degradation**: missing artifacts don't silently disable phases of the final review — they are flagged.

## Math Brainstorming Agents

These agents form an **iterative ecosystem** (not a linear pipeline). They can be invoked in any order and their outputs feed into each other. The `research-director` orchestrates and prioritizes outputs from the other five.

### Reframer

Discovers alternative problem encodings that unlock different toolsets. Applies seven transformation types (representation shift, perspective shift, granularity shift, dualization, embedding, relaxation, encoding transformation) to generate 8-12 substantially different reframings. Core insight: breakthroughs often come from a changed viewpoint rather than a new technique. Does not solve problems — transforms them into forms where solutions become tractable.

### Perturber

Maps problem neighborhoods by systematically modifying assumptions, parameters, and constraints. Extracts all assumptions from a problem, then generates 10-15 nearby variants via weakening, strengthening, extremal cases, randomization, and degeneration. Reveals which assumptions are essential vs dispensable, where phase transitions occur, and which variants are easier to attack. Constructs a perturbation landscape matrix identifying the most informative directions.

### Math Constructor

Builds explicit mathematical objects, examples, and constructions satisfying problem constraints. Applies seven construction strategies (example mining, parametric, incremental, hybrid composition, algorithmic, symmetric/extremal/random) to produce 5-10 diverse candidates. Evaluates constraint satisfaction for each, identifies structural patterns and invariants, and proposes general construction schemas. Constructions serve as evidence for strategists, test cases for obstructors, and empirical foundation of insight.

### Math Strategist

Designs structured proof-search roadmaps without attempting full proofs. Selects among proof paradigms (induction, contradiction, probabilistic method, spectral, compactness, extremal, algebraic, topological), decomposes problems into dependency trees with difficulty assessment, and generates 5-8 genuinely different strategies with concrete proof plans and required lemmas. Ranks strategies by feasibility and recommends a path. Emulates experienced research mathematicians planning attacks before writing.

### Obstructor

Stress-tests ideas, conjectures, and proof strategies by searching for counterexamples, hidden assumptions, and structural impossibilities. Applies six adversarial strategies (counterexample construction, minimal obstruction analysis, hidden assumption detection, adversarial perturbation, boundary stress testing, logical gap detection). Generates 5-8 adversarial instances, isolates root causes explaining *why* ideas fail, and suggests minimal repairs. Issues verdicts: Fatal, Wounded, or Robust.

### Research Director

Synthesizes, deduplicates, evaluates, and prioritizes research ideas from all brainstorming agents into a structured portfolio. Extracts core mechanisms from candidates, clusters by underlying structure (not surface wording), scores on novelty/feasibility/insight potential/tool availability/failure risk, and classifies into priority tiers: immediate experiment (hours), promising direction (days), high-risk research (weeks+), or discarded. Designs concrete next actions specific enough for execution without clarification.

**Typical workflow**: Reframer/Perturber explore the space → Constructor builds examples → Strategist designs attack plans → Obstructor stress-tests → Research Director prioritizes and assigns next actions.

## Formal Verification Agents

### Lean Proof Chain Validator

Validates Lean proof chains for research-grade correctness across six phases: scope locking (freezing Lean/mathlib versions), logical soundness (zero `sorry`/`admit`/warnings), dependency closure (frontier YAML validation and axiom boundary checks), epistemic validation (novelty integrity, claim-proof alignment, quantifier discipline), infrastructure assessment (mathlib compatibility, conceptual compression), and robustness (proof stability, rebuild/replay, boundary cases). Issues PASS/CONDITIONAL/FAIL verdicts with specific file/line references.

### Lean Proof Frontier Analyzer

Performs breadth-first proof dependency analysis on Lean 4 formalizations. Constructs complete dependency DAGs by recursively expanding until every leaf is classified as `mathlib`, `assumed`, `novel`, or `infrastructure`. Assigns novelty levels (0-5) along five axes (conceptual, theorem, formalization, structural, methodological). Documents axiom boundaries with precise Lean statements and source citations. Generates frontier YAML files and provenance markdown with dependency summaries.

## Installation

### Using the sync script (recommended)

The sync script creates symlinks from `~/.claude/agents/` to the repo, keeping everything in sync:

```bash
./scripts/sync-agents.sh
```

The script:
- Creates symlinks for all `.md` files under `agents/`
- Warns (does not overwrite) if a regular file already exists at the target
- Removes stale symlinks from previous syncs
- Is idempotent — safe to run repeatedly

### Manual installation

```bash
# Copy all agents
find agents -name "*.md" -exec cp {} ~/.claude/agents/ \;
```

## Agent Memory

The math brainstorming agents support **persistent agent memory** at `~/.claude/agent-memory/{agent-name}/`. This allows agents to accumulate knowledge across sessions — recording which patterns worked, which approaches failed, and what structural insights were discovered.

Memory setup is user-local and not tracked in this repo. Each agent's spec references its memory directory; the memory infrastructure is created automatically on first use.

## Phase Completion Criteria

Each phase has explicit "Definition of Done" criteria. A phase is complete when:

1. All gate checks pass
2. A hostile reviewer cannot identify a phase-specific fatal flaw
3. A benevolent reviewer can articulate why the phase adds value
4. Artifacts are documented and reproducible

## Reviewer Failure Triggers

Common rejection signals by phase:

| Phase | Hostile Reviewer Attacks |
|-------|--------------------------|
| 01 | "Why should anyone care?" / "This is a toy problem" |
| 02 | "They missed X which already does this" / "Incremental over Y" |
| 03 | "This evaluation does not test the claim" |
| 04 | "Dataset is too small" / "Benchmark favors their method" |
| 05 | "This could be noise" / "No error bars" |
| 06 | "They did not actually show this" / "Correlation ≠ causation" |
| 07 | "I don't understand what they did" |
| 08 | "Sloppiness indicates deeper problems" |
| 09 | "I could not reproduce this" |
| 10 | "This is merely incremental" / "Who will cite this?" |

## License

MIT
