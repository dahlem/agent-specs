# Agent Specs

Specialized Claude Code agents for rigorous AI research workflows, designed to support high-impact publications at top-tier venues (NeurIPS, ICML, ICLR, JMLR, Nature Machine Intelligence).

## Overview

This repository contains agent specifications that guide researchers through a structured 10-phase research methodology. Each phase has a dedicated agent that enforces quality gates and provides domain expertise.

The framework operationalizes both **benevolent** and **hostile** reviewer perspectives:

- **Benevolent Reviewer**: Assumes good faith, looks for signal over perfection, asks "Is there a real idea here?"
- **Hostile Reviewer**: Assumes overclaiming, searches for gaps and shortcuts, asks "What justifies rejection?"

A phase succeeds when a hostile reviewer cannot identify a fatal flaw and a benevolent reviewer can articulate why the phase adds value.

## Repository Structure

```
agent-specs/
├── README.md
└── agents/
    └── research/
        ├── phases/          # Sequential research workflow agents
        │   ├── 01-research-framing-validator.md
        │   ├── 02-literature-discovery-mapper.md
        │   ├── 03-research-design-auditor.md
        │   ├── 04-research-data-architect.md
        │   ├── 05-research-analysis-interpreter.md
        │   ├── 06-argument-architect.md
        │   ├── 07-paper-structure-architect.md
        │   ├── 08-research-revision-validator.md
        │   ├── 09-research-validation-qa.md
        │   └── 10-scholarly-submission-strategist.md
        └── tools/           # Cross-phase utility agents
            ├── ai-paper-reviewer.md
            └── citation-provenance-auditor.md
```

## Research Phases

| Phase | Agent | Purpose |
|-------|-------|---------|
| 01 | `research-framing-validator` | Validate problem is real, relevant, and precisely scoped |
| 02 | `literature-discovery-mapper` | Map knowledge landscape, identify genuine gaps |
| 03 | `research-design-auditor` | Ensure methodology aligns with claims |
| 04 | `research-data-architect` | Design rigorous data collection and artifacts |
| 05 | `research-analysis-interpreter` | Validate analysis, check robustness |
| 06 | `argument-architect` | Construct defensible claim-evidence chains |
| 07 | `paper-structure-architect` | Ensure clear narrative architecture |
| 08 | `research-revision-validator` | Refine and verify all claims |
| 09 | `research-validation-qa` | Reproducibility and quality assurance |
| 10 | `scholarly-submission-strategist` | Venue selection and submission strategy |

## Cross-Phase Tools

| Agent | Purpose |
|-------|---------|
| `ai-paper-reviewer` | Dual-perspective review across all 10 phases |
| `citation-provenance-auditor` | Verify citation integrity and provenance |

## Usage

### Installation

Copy agents to your Claude Code agents directory:

```bash
cp -r agents/research ~/.claude/agents/
```

### Invoking Agents

Agents can be invoked via the Task tool in Claude Code:

```
Use the 01-research-framing-validator agent to evaluate my problem statement.
```

Or referenced by phase number when discussing your research:

```
I think I'm ready to move from Phase 2 to Phase 3. Can you validate?
```

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
