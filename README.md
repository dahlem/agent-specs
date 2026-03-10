# Agent Specs

Specialized Claude Code agents for rigorous AI research workflows, designed to support high-impact publications at top-tier venues (NeurIPS, ICML, ICLR, JMLR, Nature Machine Intelligence).

## Overview

This repository contains agent specifications organized into three categories:

1. **Research Workflow** — A structured 10-phase methodology for taking research from problem framing through submission, plus cross-phase tools.
2. **Math Brainstorming** — An iterative ecosystem of agents for mathematical problem exploration, construction, and synthesis.
3. **Formal Verification** — Agents for Lean 4 proof development, validation, and documentation.

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
│   │   └── tools/                               # Cross-phase utility agents
│   │       ├── ai-paper-reviewer.md
│   │       ├── citation-provenance-auditor.md
│   │       └── scientific-narrative-architect.md
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

### Citation Provenance Auditor

Performs comprehensive citation audits: establishes persistent identifiers (DOI, arXiv, ISBN), verifies BibTeX entries against authoritative sources (Crossref, arXiv, PubMed, DBLP) with field-by-field diffs, maps every citation occurrence to specific claims with evidence pointers and support strength, and assesses canonicality (peer-reviewed over preprint, primary over secondary). Generates provenance files per citation key and TeX annotation comments.

### Scientific Narrative Architect

Constructs scientific writing achieving causal intelligibility at every scale, optimized for mathematically oriented ML venues (NeurIPS theory, COLT, AISTATS, JMLR) as well as Nature/Science and physics/math journals. Beyond clarity, enforces **scientific strategy**: a three-tier claim architecture (core/supporting/peripheral) with explicit scope containment, narrative tension (phenomenon → explanation → failure → new mechanism), theorem–empirical alignment (every theorem maps to a prediction and experiment), contribution compression (≤ 5 named conceptual objects), and a reviewer adversary pass simulating theorist, empiricist, and skeptic archetypes. Applies Feynman-style clarity, multi-scale concentric arc, audience adaptation, and a three-layer reading model ensuring skim readers grasp the core claim from abstract + intro + figure captions alone.

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
