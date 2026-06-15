# Feynman.is Integration — New Agents

Date: 2026-06-15

## Summary

Added two new research agents inspired by concepts from https://www.feynman.is/ that were not already present in our agent specs:

1. **`research-session-memory`** — Indexed cross-session knowledge continuity
2. **`literature-synthesis-auditor`** — Agreement/conflict matrix construction across sources

## What We Learned from Feynman

### Concepts We Adopted

1. **Session Memory / Indexed Recall**
   - Feynman: "indexed recall across prior research sessions"
   - Our implementation: Five-index memory system (concepts, approaches, negative results, open questions, synthesis)
   - Gap filled: We had citation/evidence provenance but no cross-session conceptual continuity

2. **Side-by-Side Source Comparison with Agreement/Conflict Matrix**
   - Feynman: "agreement and conflict matrix" when sources diverge
   - Our implementation: Structured synthesis analysis with severity-tagged conflicts and consensus extraction
   - Gap filled: `literature-expansion` collected sources but didn't systematically identify conflicts

3. **Severity-Based Prioritization**
   - Feynman: "severity scores" to triage findings
   - Our implementation: Enhanced severity framework (critical/high/medium/low) with explicit resolution strategies
   - Enhancement: Applied across both new agents and aligned with existing severity patterns in `baseline-scout` and `claim-interrogator`

4. **Hybrid Compute with Isolation** (noted for future)
   - Feynman: "isolated local containers for safe experiments" + cloud bursting
   - Future work: While we have worktree isolation for code, we could add explicit sandboxed execution environments for computational experiments

5. **Explicit Separation of Planning and Execution for Replication** (noted for future)
   - Feynman: Distinct "replication planning" vs. "execution in sandboxed Docker"
   - Future work: Could create a dedicated replication protocol agent

### Concepts We Already Had Well-Covered

✅ **Evidence grounding** — our `citation-provenance-auditor` and `evidence-provenance-auditor` are more comprehensive than Feynman's description

✅ **Multi-agent architecture** — our peer-review pipeline and research phases

✅ **Adversarial verification** — `epistemic-calibration-auditor` with devil's-advocate pass, `ai-paper-reviewer` dual-lens

✅ **Source diversity** — our `literature-expansion` integrates papers, web, code

✅ **Autonomous iteration** — our research phases support hypothesis→experiment→measure cycles

## New Agent: `research-session-memory`

**Location**: `agents/research/tools/research-session-memory.md`

**Purpose**: Maintain structured, indexed, version-controlled memory for long-running research projects across multiple sessions.

**Five Memory Indexes**:
1. **Conceptual Understanding** — evolving definitions, ambiguities, cross-references
2. **Approaches and Strategies** — both successful and failed, with specific failure modes
3. **Negative Results** — first-class index for failed experiments and disproven conjectures
4. **Open Questions** — unresolved threads with blockers, priorities, dependencies
5. **Cross-Session Synthesis** — milestone integrations across sessions

**Key Features**:
- Session provenance tracking (every memory traces to when it was learned)
- Bidirectional cross-linking between related memories (`[[memory-name]]` syntax)
- Lifecycle management (active → superseded → archived)
- Structured frontmatter (type, topic, tags, dates, sessions, status)
- Query/retrieval with relevance ranking
- Synthesis operations for periodic integration

**Integration Points**:
- After `02-literature-discovery-mapper` — index conceptual insights from papers
- After `05-research-analysis-interpreter` — index experimental findings (positive and negative)
- Before `06-argument-architect` — query to avoid overclaiming vs. prior findings
- Before `08-research-revision-validator` — check claims don't contradict indexed negative results
- Math brainstorming agents — index failed proof strategies for future sessions

## New Agent: `literature-synthesis-auditor`

**Location**: `agents/research/tools/literature-synthesis-auditor.md`

**Purpose**: Analyze collections of papers to identify consensus, conflicts, methodological divergences, and synthesis opportunities.

**Four Universal Operations**:
1. **Claim Extraction** — structured extraction with scope, evidence, hedge level preserved
2. **Agreement Matrix Construction** — side-by-side comparison with agreement labels (align/partial/conflict/silent)
3. **Conflict Analysis** — diagnose probable cause, assess impact, recommend resolution strategy
4. **Consensus Extraction** — what the literature collectively establishes, with citation recommendations

**Key Features**:
- Severity-tiered conflict flagging (critical/high/medium/low)
- Methodological divergence deep-dive for evaluation-level synthesis
- Anti-pattern detection (circular citation, citation drift, scope elision, etc.)
- Configurable synthesis scope (claim/method/evaluation/conceptual/full)
- Resolution strategy per conflict (acknowledge/adjudicate/synthesize/avoid/investigate)

**Synthesis Scopes**:
- `claim-level` — specific factual or empirical claims
- `method-level` — algorithmic techniques, architectures, training procedures
- `evaluation-level` — experimental setups, datasets, metrics, reported results
- `conceptual-level` — definitions, problem formulations, theoretical frameworks
- `full` — all of the above

**Integration Points**:
- Downstream from `literature-expansion` or `02-literature-discovery-mapper`
- Feeds into `06-argument-architect` — conflicts must be acknowledged in claims
- Feeds into `scientific-narrative-architect` — consensus guides related work
- Feeds into `baseline-scout` — methodological divergence informs baseline expectations
- Feeds into `claim-interrogator` — conflicts become external evidence for interrogation
- Feeds into `research-session-memory` — index conflicts and consensus for future sessions

## Updated Files

- `agents/research/tools/research-session-memory.md` — NEW
- `agents/research/tools/literature-synthesis-auditor.md` — NEW
- `README.md` — Updated to include:
  - Agent count: 38 → 40
  - Cross-Phase Tools: 4 → 6
  - Repository structure updated
  - Detailed descriptions added for both new agents

## Future Enhancements (Noted but Not Implemented)

1. **Sandboxed Execution Environment Agent**
   - Inspired by Feynman's "isolated local containers for safe experiments"
   - Would complement our existing worktree isolation
   - Could integrate with `05-research-analysis-interpreter` for experiment execution

2. **Replication Protocol Agent**
   - Inspired by Feynman's separation of planning vs. execution
   - Would formalize the replication methodology currently distributed across multiple agents
   - Could enhance `09-research-validation-qa`

## Design Principles Applied

Both new agents follow our established patterns:

1. **Explicit integration points** — both agents document which other agents consume them
2. **Severity calibration** — both use our shared severity vocabulary
3. **Forbidden behaviors** — both enumerate what they must NOT do
4. **Definition of Done** — both have explicit completion criteria
5. **Quality standards** — both specify when they "feel done"
6. **Graceful degradation** — both handle missing inputs explicitly

## Validation

The additions strengthen our existing workflows:

- **Workflow A (Write a paper)** — can now index learnings across iterations and synthesize conflicting literature
- **Workflow D (Review a paper)** — literature synthesis enhances the `literature-expansion` → `claim-interrogator` pipeline
- **Long-running projects** — session memory enables conceptual continuity across months/years
- **Multi-source claims** — synthesis auditor prevents silent conflicts in related work

Both agents are ready for integration into the sync script and can be invoked independently or as part of the existing research pipelines.
