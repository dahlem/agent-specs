# Agent Specs

Specialized Claude Code agents for rigorous AI research workflows, designed to support high-impact publications at top-tier venues (NeurIPS, ICML, ICLR, JMLR, Nature Machine Intelligence).

## Overview

This repository contains agent specifications organized into six categories:

1. **Research Workflow** — A structured 10-phase methodology for taking research from problem framing through submission, plus cross-phase tools.
2. **Research Shaping** — A diverge-then-converge layer that turns a body of work into the one paper it should become; an expanded entry point into phase 06.
3. **Peer Review** — A coordinated, cutoff-bounded review pipeline that produces structured artifacts for the AI paper reviewer to ground its verdicts in.
4. **Math Brainstorming** — An iterative ecosystem of agents for mathematical problem exploration, construction, and synthesis.
5. **Writing & Documentation** — Cross-cutting writing tools used directly or invoked by paper-writing agents to enforce calibrated clarity discipline across any document register (blog, lecture note, paper, Nature letter, policy essay).
6. **Formal Verification** — Agents for Lean 4 proof development, validation, and documentation.

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
│   │   │   ├── math-review-router.md
│   │   │   ├── proof-dissection-orchestrator.md  # Proof-dissection track (parallel to review pipeline)
│   │   │   ├── proof-chain-cartographer.md
│   │   │   └── proof-tutor.md
│   │   └── shaping/                             # Diverge → converge: pick the paper hiding in a body of work
│   │       ├── research-shaping-orchestrator.md  # User-callable entry point
│   │       ├── research-divergence-cartographer.md
│   │       └── red-thread-selector.md
│   ├── math-brainstorming/                      # Iterative problem exploration ecosystem
│   │   ├── reframer.md
│   │   ├── perturber.md
│   │   ├── math-constructor.md
│   │   ├── math-strategist.md
│   │   ├── obstructor.md
│   │   └── research-director.md
│   ├── writing/                                 # Cross-cutting writing tools (any document type)
│   │   ├── narrative-clarity-auditor.md
│   │   ├── epistemic-calibration-auditor.md
│   │   ├── evidence-provenance-auditor.md
│   │   └── theorem-presentation-auditor.md
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
research-shaping-orchestrator (user-callable entry point; sequences the four stages below)
       │
       ▼
research-divergence-cartographer  ──► candidate_threads.md (5–12 threads, deliberately over-generated)
       │
       ▼
red-thread-selector               ──► red_thread.md (1 chosen + runners-up + score table; or selection_outcome: deferred)
       │
       ▼
scientific-narrative-architect    ──► sculpt_plan.md (keep / move-to-appendix / cut)
   (mode: Sculpt; auto-conditional)
       │
       ▼
06-argument-architect (existing) — validates the converged claims;
                                   open-ended distillation is replaced by validation
                                   when red_thread.md is present.
```

If no shaping artifacts are produced, phase 06 behaves exactly as it does today.

### Research Shaping Orchestrator

User-callable entry point. Sequences the four stages, enforces preconditions at every handoff, handles `selection_outcome: deferred` as a first-class outcome rather than retrying with relaxed thresholds, and supports stop-early flags (`diverge | select | sculpt | argue`) and resume-at-stage when prior artifacts are valid. Auto-conditional sculpting: invokes Sculpt Mode whenever a draft is provided, or whenever `body_of_work.md` lists ≥ 1 abandoned thread, decorative experiment, or off-axis result. Hands off to `06-argument-architect` with `red_thread.md` and (if produced) `sculpt_plan.md` so phase 06 switches from open-ended distillation to claim validation.

Invocation:

```
# Full pipeline through phase-06 handoff
Use the research-shaping-orchestrator agent on body_of_work.md

# Stop after selection so you can review before sculpting
Use the research-shaping-orchestrator agent on body_of_work.md with stage: select

# Sculpt against an existing complete draft, reusing red_thread.md from a prior run
Use the research-shaping-orchestrator agent on body_of_work.md with stage: sculpt, draft: paper_draft.tex

# Skip sculpting and hand off directly to phase 06
Use the research-shaping-orchestrator agent on body_of_work.md with sculpt: off
```

The orchestrator emits `shaping_handoff.md` recording which stages ran, the selection outcome (`selected` or `deferred` with diagnosis), the sculpt decision basis, and any conditional findings phase 06 should address.

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

## Proof Dissection Track

A parallel track to the peer-review pipeline, intended for *reading* a theoretical paper rather than reviewing it. When the math is outside your comfort zone — unfamiliar techniques, citations to results you don't know, hand-waved compressed steps — this track produces a static map of the paper's proof architecture and then converts it into a personalized lecture note (LaTeX, `memoir` class, Feynman style), or walks you through it interactively. Either way, only background you actually lack gets taught, and what you confirm carries forward across papers.

```
paper (PDF / arxiv id)
       │
       ▼
paper-compressor              ──► compressed_paper.md             (precondition; reused if present)
       │
       ▼
proof-chain-cartographer      ──► proof_chain.md                  (DAG over theorems / lemmas / external citations)
                                  concept_inventory.md            (prerequisite concepts, per subfield, with difficulty)
                                  compressed_steps.md             (every "clearly" / "by standard arguments", flagged)
       │
       ├──► math-review-router (optional, auto-conditional) ──► math_review_bundle.md
       │
       ▼
proof-tutor — three modes:
       document    (default) ──► lecture_notes.tex                (LaTeX memoir, Feynman style; one batched probing round)
       interactive           ──► live whiteboard session in main conversation
       hybrid                ──► interactive walk + lecture_notes.tex accumulated in parallel
       — reads/writes a persistent knowledge profile so the next paper skips what you already know
```

### Proof Dissection Orchestrator

User-callable entry point. Sequences the four stages, enforces preconditions at every handoff, and supports stop-early flags (`compress | cartography | adversarial | tutor`) and a `tutor_mode` flag (`document | interactive | hybrid`, default `document`). Reuses `compressed_paper.md` if already produced; auto-invokes `math-review-router` only when the cartographer raises ≥ 5 plausibility flags or any Tier-1 theorem has compressed steps with `uncertain` certainty (or when the user opts in explicitly). Hands off to `proof-tutor` in the main conversation rather than spawning it as a subagent — even in document mode the tutor needs the main conversation for a single batched probing round before generating LaTeX.

### Proof Chain Cartographer

One-shot map builder. Walks the paper front-to-back, creates one node per numbered/named result with role / formal statement / informal restatement / dependencies (in-paper, external, background concept), and produces a topological ordering of prerequisite concepts grouped by subfield. Light plausibility flags (notation overloading, quantifier-order changes, unstated regularity conditions) are surfaced as side-output; adversarial review is delegated to `math-review-router`. The cartographer does not teach.

### Proof Tutor

Personalized walkthrough generator. Default mode (`document`) produces `lecture_notes.tex` — a LaTeX memoir-class lecture note written in Feynman style: motivation precedes technique, concrete precedes abstract, every proof is told first as a story (the trail of thought) and then formally (the rigorous version). Concepts marked `known` in the profile appear only in a compact "Concepts assumed familiar" list; concepts marked `teach` get full Feynman-style tutorials; uncertain compressed steps surface in each theorem's "Loose ends" section and in a "Questions for the authors" appendix. Probing happens once, batched, before generation. `interactive` mode runs a live whiteboard session in the main conversation; `hybrid` does both. Reads and writes a persistent knowledge profile at `~/.claude/projects/<project>/memory/theoretical-paper-knowledge-profile.md` so subfield fluency, per-concept ledger entries, and open loops carry forward across papers.

Two styles for the LaTeX output (selectable via `tutor_style` on the orchestrator or `style` on direct invocation):

- **`explainer`** (default): distill.pub-inspired layout — wide right margin for sidebars, layered/progressive TikZ figures (comic-strip panels showing how an object is built up), annotated equation arrays where each derivation line carries a margin annotation explaining the move, per-chapter `\conceptMap` showing this chapter's slice of the proof DAG with the current theorem highlighted, `\anatomyDiagram` for new concept introductions, `\counterexampleSketch` margin figures for boundary cases, and `\comparativeDiagram` for the multiple-angles narrative-clarity rule. Built on a TikZ template library (seven named macros) and a unified `tutor-style` preset so figure quality stays consistent — the agent does not invent ad-hoc TikZ for diagram types the library covers. Optional `handdrawn: true` sub-flag applies a sketchy hand-drawn aesthetic via `decoration={random steps}`.
- **`classic`**: dense memoir-class lecture note with conventional figure/equation handling. No margin sidebars, single appendix-only DAG. Use when the reader prefers a denser, more book-like format.

The narrative discipline does not change between styles. Only the layout, figure vocabulary, and margin treatment differ.

### How to call it

The orchestrator is the entry point. Invoke it via the Agent tool with the paper as input:

```
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf
```

By default it runs the full pipeline and produces `lecture_notes.tex`. Common variants:

```
# Live whiteboard session instead of LaTeX output
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with tutor_mode: interactive

# Both — interactive walk plus LaTeX accumulated in parallel
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with tutor_mode: hybrid

# Classic dense memoir output instead of distill-style explainer
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with tutor_style: classic

# Hand-drawn / sketchy TikZ aesthetic for a warmer tutorial
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with tutor_style: explainer, handdrawn: true

# Stop after the static map; no tutoring, no LaTeX
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with stage: cartography

# Force adversarial soundness review
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with adversarial: on

# Skip adversarial review entirely
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with adversarial: off

# Resume in a later session — re-invoke with stage: tutor; cartography artifacts and knowledge profile
# from the prior session are reused; the tutor resumes at the next undelivered node
Use the proof-dissection-orchestrator agent on /path/to/paper.pdf with stage: tutor
```

The orchestrator emits `dissection_handoff.md` recording which stages ran, which were skipped, why, the chosen `tutor_mode`, and the expected deliverable. After handoff, the tutor either generates `lecture_notes.tex` (document mode) or walks you through the proofs in your main conversation (interactive/hybrid).

### When to use this track

- You're tasked with reviewing a paper whose proof techniques are partly outside your subfield.
- You want a hyper-personalized lecture note for a paper rather than a generic survey of its area.
- You'd rather invest time once in learning the prerequisite concepts (and have that investment compound across future papers) than re-derive them every time.

When the paper's math is fully within your comfort zone, skip this track and use the standard peer-review pipeline.

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

## Writing & Documentation Agents

Cross-cutting writing tools that operate on *any* document register — blog post, tutorial, lecture note, tech report, empirical paper, theoretical paper, Nature letter, policy essay. Designed to be invoked directly by an author and also called by other agents in the repo (`proof-tutor`, `scientific-narrative-architect`, `07-paper-structure-architect`) so the discipline has a single canonical home.

### Narrative Clarity Auditor

Audits a draft against a calibrated narrative-clarity discipline. The discipline factors into **universal rules** (motivation precedes technique, concrete grounding before generality, no padding, pre-empt confusion at known stuck points, honest uncertainty, formalism after fluency) that apply at every register, and **register-conditional rules** that toggle by venue (personal voice, story-of-discovery proofs, physical metaphors, inline "where readers get stuck" warnings, plain acknowledgment of difficulty). The auditor takes a `register` parameter — `blog | tutorial | lecture-note | tech-report | empirical-paper | theoretical-paper | nature-letter | policy-essay` — and applies only the appropriate subset, surfacing a `Deliberately not enforced` section so the author can see which rules were *suppressed by venue calibration* rather than overlooked. This is the safeguard against the natural failure mode of "Feynman style": importing blog-style intuition and physical metaphors into a NeurIPS or Nature submission.

The auditor is consumed by:

- **`proof-tutor`** (lecture-note register) — invoked generatively before drafting `lecture_notes.tex` and as an audit pass on each chapter.
- **`scientific-narrative-architect`** (register matched to its `AUDIENCE` parameter) — invoked at the end of `Draft`, `Restructure`, `Adapt`, `Review`, and `QualityControl` modes.
- **`07-paper-structure-architect`** (paper register) — invoked per section after structural validation, to catch clarity issues that structure alone cannot.

Direct invocation:

```
# Audit a blog post draft
Use the narrative-clarity-auditor agent on draft.md with register: blog

# Audit a NeurIPS introduction — neutral tone, sparse metaphors
Use the narrative-clarity-auditor agent on intro.tex with register: empirical-paper

# Audit a theoretical paper section, allowing physical metaphors because the paper is itself about physical systems
Use the narrative-clarity-auditor agent on section3.tex with register: theoretical-paper, overrides: { metaphor_budget: moderate }

# Generative checklist (no draft) — produces clarity_checklist.md as a writing target for a lecture note
Use the narrative-clarity-auditor agent with register: lecture-note
```

The auditor emits `clarity_audit.md` with a calibration block, per-rule verdicts, anti-pattern findings, recommended minimal rewrites, and the deliberately-not-enforced list. Generative invocation emits `clarity_checklist.md`.

When the discipline changes, it changes here. Other agents reference; they do not duplicate.

### Epistemic Calibration Auditor

Audits any agent output, draft, audit document, handoff record, or end-of-turn summary for the systemic positivity bias of LLM agents: language stronger than the evidence supports ("we show" when the evidence is consistent with X under conditions Y); coverage inflation ("Done", "all stages completed cleanly" without enumeration); marketing adjectives asserted rather than earned ("comprehensive", "robust", "novel"); and verdicts that have not been adversarially stress-tested. Three audit passes plus a devil's-advocate pass:

- **Language calibration** — does each claim's verb match the evidence ladder (proof / strong empirical / moderate empirical / weak / none)?
- **Coverage calibration** — are scope claims (Done, complete, all, every, fully, comprehensive) enumerated rather than asserted?
- **Negative-result surfacing** — are failed experiments, ablations that hurt, warnings encountered, and counter-evidence first-class outputs rather than glossed?
- **Devil's advocate** — for each load-bearing claim, what is the strongest plausible counter-argument? The author resolves; the auditor surfaces.

Critical design constraint: the auditor flags both **overclaim** *and* **underclaim**. Forced hedging on proven results is also a violation — the discipline is *match language to evidence*, not "always hedge". Strictness is set by an `audit_target` parameter (`paper | audit_document | agent_handoff | status_report | blog | informal`) so that paper claims are checked harder than internal status reports, but coverage enumeration is required at every target because "Done" without scope is the most common agent overclaim pattern.

The auditor is consumed by:

- **`06-argument-architect`** — invoked after the claim-evidence matrix is built, with `audit_target: paper`, before phase 06 declares done. Devil's-advocate alternatives must be addressed in the document, not merely acknowledged.
- **`08-research-revision-validator`** — invoked alongside its own linguistic-precision pass; the two complement (08 audits vagueness, this audits overclaim).
- **`proof-dissection-orchestrator`, `research-shaping-orchestrator`** — invoked on `dissection_handoff.md` / `shaping_handoff.md` with `audit_target: agent_handoff` before reporting done. Catches "all stages completed cleanly" overclaim.

Direct invocation:

```
# Audit a paper draft (strictest)
Use the epistemic-calibration-auditor agent on draft.tex with audit_target: paper

# Audit an end-of-turn agent summary
Use the epistemic-calibration-auditor agent on summary.md with audit_target: status_report

# Devil's advocate pass on an audit document
Use the epistemic-calibration-auditor agent on prior_audit.md with audit_target: audit_document, evidence_sources: [experiment_logs.md, theorems.tex]
```

The auditor emits `calibration_audit.md` with the strictness profile, per-rule verdicts (overclaim/underclaim direction named), anti-pattern findings, the devil's-advocate alternatives with plausibility ratings, and minimal recommended rewrites.

The two writing auditors compose: `narrative-clarity-auditor` checks *how* the prose reads at the venue's register; `epistemic-calibration-auditor` checks *what the prose claims relative to evidence*. Both can run on the same draft, in either order.

### Evidence Provenance Auditor

Audits any document or repository for end-to-end provenance: every data file, script, figure, table, numerical claim in prose, and experimental result must trace back to a documented origin. The discipline is *evidence-driven* — no number, plot, or quoted result enters a document without a chain back to its raw input. Six universal rules: data files have provenance metadata (source, date, version, license, schema); scripts declare inputs and outputs; figures and tables have a producer trail (which script, which data, which version); numerical claims in prose are sourced (table / figure / citation / script output / stated experimental setup); experimental results have replication metadata (setup, hyperparameters, seeds, hardware, variability); transformations are documented step-by-step.

Companion to `citation-provenance-auditor`: that agent audits *bibliographic* provenance per citation; this one audits *data and computational* provenance. Together they cover the full evidence chain a reader needs to verify a claim.

Anti-pattern catalog covers: magic constants in scripts (`threshold = 0.05` with no comment), headerless data files, figures without producer scripts, "data from [partner]" without specifics, hard-coded local paths signalling un-portable provenance, silent re-runs without seeds documented, and unsourced statistics in prose.

The auditor is consumed by:

- **`04-research-data-architect`** — primary upstream user; data-design output gets audited before downstream phases.
- **`05-research-analysis-interpreter`** — invoked after results to verify replication metadata and chain integrity.
- **`06-argument-architect`** — every numerical claim in the claim-evidence matrix must have an intact chain (claim → table/figure → script → data → source) before phase 06 declares done.
- **`08-research-revision-validator`** — invoked alongside epistemic-calibration before sign-off.
- **`09-research-validation-qa`** — chain-integrity directly answers the reproducibility question.
- **`scientific-narrative-architect`** — invoked when prose contains numerical claims, in `Review` and `QualityControl` modes.

Direct invocation:

```
# Audit a paper repo end-to-end
Use the evidence-provenance-auditor agent on /path/to/paper-repo with audit_target: paper_repo

# Audit only the data directory
Use the evidence-provenance-auditor agent on /path/to/repo/data with audit_target: data_artifacts

# Audit a blog post that quotes statistics
Use the evidence-provenance-auditor agent on draft.md with audit_target: blog_with_data
```

The auditor emits `provenance_audit.md` with an inventory of artifacts in scope, per-artifact provenance verdicts, chain-integrity walks, anti-pattern findings, and minimal recommended patches (a header to add, a preamble to write, a footnote to insert). It does not produce data, scripts, or prose; it traces and recommends.

### Citation provenance as a gate

The existing `citation-provenance-auditor` (under `agents/research/tools/`) has been extended with explicit **gate semantics**: no citation enters a document without a provenance record from this agent first. Severity-tiered to keep the gate from becoming a bottleneck:

- **Tier-1 (load-bearing)** — citations supporting Tier-1/Tier-2 claims, baselines, or canonical references. **Strict gate** before acceptance.
- **Tier-2 (supporting)** — contextual citations. **Light gate** (persistent identifier + metadata only); claim-mapping deferred to a batch pre-submission pass.
- **Tier-3 (peripheral)** — tangential references. **Batch gate** before submission only.

Suggesting agents (`literature-expansion`, `02-literature-discovery-mapper`, `06-argument-architect`, `scientific-narrative-architect`, `arxiv-gap-scanner`) treat the auditor as a gate, not a downstream check. Failed Tier-1 citations are *replaced, demoted, or dropped* — never silently retained. Each suggesting agent's Definition of Done now reflects this contract.

### Theorem Presentation Auditor

Audits how theorems and proofs are presented in a paper, lecture note, or technical document. The dominant failure mode of theoretical papers is "wall of theorems with proofs": pages of formal statements with no signposting, no separation of load-bearing from bookkeeping moves, no clear answer to *what does this theorem do for the paper's argument*. Reviewers cannot tell on a first pass what to scrutinize. The auditor inverts that failure mode by enforcing two reviewer-centric disciplines:

**Part A — Theorem rhythm.** Every theorem the paper invokes for its argument is surrounded by four elements in fixed order:
1. **Theorem statement** — formal, with all assumptions named in the statement.
2. **Intuition** — plain-language meaning, marked explicitly ("Informally,…").
3. **Operational interpretation** — what the theorem *does*: how it gets used, what computational/algorithmic/argumentative consequence it produces.
4. **Consequence** — what changes downstream in the paper's argument because this theorem holds.

The rhythm can take three compliant forms (inline / sectioned / pre-stated) but the four elements must all be present.

**Part B — Modular proof architecture.** Every non-trivial proof is structured for reviewer skimmability:
1. **Proof sketch in main text** — names the proof technique, identifies the one or two **load-bearing steps**, references key lemmas by name, readable in 30 seconds.
2. **Key lemmas extracted and named** — non-trivial intermediate results are named lemmas with their own rhythm (Part A).
3. **Full formal proof in appendix** — with `\label`s matching the sketch's named load-bearing steps for bidirectional cross-reference.
4. **Significance tagging** — each step in the sketch tagged `[load-bearing] | [technical] | [bookkeeping]` (via inline tags, macros, or consistent typographic convention) so reviewers see at a glance what to scrutinize vs. take on faith.

Anti-pattern catalog covers: theorems with no intuition, operational interpretation absent (the theorem floats free of the paper's argument), proofs running uninterrupted for two pages without named lemmas, "by a tedious but standard calculation" without elaboration, all steps presented as equally important, lemmas cited from prior work without their own intuition, inline anonymous claims doing real work, appendix proofs without labels matching the sketch, and significance tagging applied as decoration (every step labeled load-bearing, defeating the purpose).

Register calibration: required for `theoretical-paper` and `empirical-paper`; rhythm-only with delegated architecture for `lecture-note` (proof-tutor's `story → formal` pattern carries the architecture role); compact rhythm for `nature-letter`; encouraged for `tech-report`; refused for non-theorem-bearing registers.

The auditor is consumed by:

- **`07-paper-structure-architect`** — invoked after section-level structural validation. Section structure and theorem-internal architecture are orthogonal and both required.
- **`scientific-narrative-architect`** — invoked when introducing or repositioning theorems; complements its existing Theorem-Empirical Alignment (Section X) which audits a different concern.
- **`06-argument-architect`** — every theorem in the claim-evidence matrix's evidence column must pass the rhythm audit, because the operational interpretation *is* the bridge between the theorem and the claim it supports.
- **`proof-tutor`** (lecture-note register) — Part A applies (rhythm required for every chapter); Part B is delegated to the tutor's `story → formal → loose-ends` pattern.

Direct invocation:

```
# Audit a theoretical paper
Use the theorem-presentation-auditor agent on draft.tex with register: theoretical-paper

# Audit only the architecture of one chapter (lecture note delegates Part B)
Use the theorem-presentation-auditor agent on chapter3.tex with register: lecture-note, scope: T1

# Audit a Nature letter — compact rhythm, no architecture
Use the theorem-presentation-auditor agent on letter.tex with register: nature-letter
```

The auditor emits `theorem_presentation_audit.md` with theorem inventory, per-theorem rhythm verdicts (statement/intuition/operational/consequence/order/exemption), per-proof architecture verdicts (sketch/technique/load-bearing/lemmas/location/tagging), anti-pattern findings, and minimal recommended patches.

The five writing auditors compose. They cover orthogonal concerns:

| Auditor | Audits |
|---|---|
| `narrative-clarity-auditor` | *How the prose reads* at the venue's register |
| `epistemic-calibration-auditor` | *What the prose claims* relative to evidence (overclaim + devil's advocate) |
| `evidence-provenance-auditor` | *That the evidence chain exists* (data → script → figure → claim) |
| `citation-provenance-auditor` | *That cited works are real, canonical, and support the cited claim* |
| `theorem-presentation-auditor` | *That every theorem has rhythm and every proof has reviewer-skimmable architecture* |

A paper that passes all five is reproducible, defensible, honest about what it claims, and structured for the reviewer to triangulate at a glance.

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
