---
name: handoff-protocol
description: The discipline governing what one agent's output says to the next agent and to the human — the handoff header, the three-way distinction between checked-clean, unchecked, and inconclusive, and the shared glossary with one meaning per term. Use when writing an agent whose output another agent consumes, or when a term is about to acquire a second meaning.
---

# Handoff Protocol

This suite has an interface language. `verdict-protocol` governs its last line,
`narrative-clarity-auditor` bans eighteen of its terms from reaching a
manuscript, and `epistemic-calibration-auditor` audits handoffs for calibration
against a form nobody ever wrote down. This file is the form.

It borrows from ASD-STE100 (Simplified Technical English) in one respect: **one
term, one meaning, one part of speech**, with a declared escape hatch for domain
vocabulary. The rest of STE is deliberately not adopted, for reasons in the last
section. Brevity is not the goal — an unambiguous read on the first pass is, and
the two are not the same thing.

## Two channels

A handoff travels on one of two channels, governed differently because the
reader differs.

| | `wire` | `report` |
|---|---|---|
| reader | another agent, no human in between | the human |
| form | a named artifact another agent parses | the turn that announces it |
| header | required | not used |
| discipline | strict; a malformed handoff is a defect against the producer | advisory |
| length | whatever coverage costs | the verdict, the count, the decision the human owns |

Most agents emit both, and the usual error is to collapse them: the chat turn
re-narrates the audit document, and the human reads the same findings twice at
lower fidelity. The artifact carries the content; the announcement carries the
decision. An agent with nothing for the human to decide says so in one line and
stops.

Glossary terms below are `wire` *and* `report` vocabulary. They are forbidden in
a **manuscript**, which is a third thing and not a channel —
`narrative-clarity-auditor`'s apparatus-leakage sweep enforces that boundary,
and this file is the same list read in the other direction.

## The handoff header (`wire`)

First line of the artifact, nothing before it — the mirror of the verdict line,
which is the last with nothing after:

```
HANDOFF: <artifact> | from=<agent-name> | consumed=<artifact[,artifact]|none>
```

**`artifact`** — the filename a downstream agent refers to it by
(`compression.md`, `baseline_gap.md`). **`from`** — the producer's exact
frontmatter name. **`consumed`** — every upstream artifact this one was built
from, or `none` at a pipeline's first stage.

`consumed` is the field that makes a chain checkable. It catches the failure
that otherwise surfaces as a mysterious disagreement between two reviewers: a
stage built on a *different* revision of an upstream artifact than its sibling
read.

An output with no header is a `report`, whatever it contains. A consumer that
cannot find a header does not parse the text — it stops and says so. That fails
at the point of consumption rather than three stages later.

**With a verdict.** An artifact that is both a handoff and a verdict-emitter is
bracketed: `HANDOFF:` is the first line with nothing before it, the `VERDICT:`
line of the `verdict-protocol` skill is the last with nothing after it, and
`## Not established` is the last *section*, immediately above the verdict. The
two protocols do not compete for the same position, and a reader can find either
end without reading the middle.

## What the consumer must not infer (`wire`)

Silence is the most expensive thing on this channel. A consumer reading an
artifact with no finding against some dimension will infer the dimension is
clean, and several reasons for silence are not that. So every `wire` artifact
carries:

```markdown
## Not established
- `unchecked` <dimension> — <out of scope | input absent | delegated to X>
- `inconclusive` <dimension> — <what was tried; what would settle it>
```

The distinction is three-way where prose defaults to two. **Checked and clean**
is a finding and belongs with the findings. **Unchecked** is a gap in coverage.
**Inconclusive** is a gap in evidence. Collapsing the last two loses the only
thing the reader wants to know next — whether more work would help.

This is the per-dimension counterpart of `indeterminate` in the
`verdict-protocol` skill, which can only report that an *entire* agent declined
to certify. An agent may return `level=pass` with a populated `Not established`
section; that is a normal, honest result and the two are not in tension. What is
forbidden is an empty section kept as a formality. If nothing is unchecked,
write `- none` and mean it.

## The `report` channel

Three rules. The first does most of the work.

1. **Modality carries epistemic state, never politeness.** "You may want to
   consider re-running the gate" is either a finding or it is not. If the gate
   should be re-run, say so; if it is genuinely optional, say what the decision
   turns on. Hedges that encode uncertainty — "the evidence supports this
   weakly" — stay, and are required by the `epistemic-calibration-auditor`
   ladder. Hedges that encode deference are padding and read as uncertainty the
   agent does not actually have.

2. **Name the artifact, not its position.** "The above", "as noted earlier",
   "the previous finding" — the human is reading a scrollback containing other
   agents' output, and a relative reference resolves against the wrong thing.

3. **State the decision the human owns, then stop.** Where there is none, say
   the step is complete. An announcement offering three next actions when only
   one is live spends the reader's attention on the other two.

## One term, one meaning

A term has **one meaning and one part of speech** across the suite. A second
sense is not a nuance; it is a new term that needs a new name.

These collisions predate the rule. Each resolution names a replacement rather
than only a prohibition — STE's discipline, and the reason its rules are
followable.

Where the resolution is a qualifier, it is required **at first use in an
artifact, and at every point where both senses are in scope** — not at every
occurrence. An agent that establishes `claim ledger` in its first paragraph may
write `ledger` thereafter; an agent that handles two ledgers may not. Qualifying
every instance buys nothing and makes the rule the first one a writer drops.

| Term | Colliding senses | Resolution |
|---|---|---|
| `register` | the venue (`writing-registers`); the append-only hypothesis log; the risk register of `claim-disposition-gate` | qualify — `venue register`, `hypothesis register`, `risk register`. Bare `register` is also the parameter name, where the type disambiguates. |
| `ledger` | the claim ledger (`claim-disposition-gate`); the notation ledger (`manuscript-update-gate`) | qualify |
| `seam` | the join between two manuscript sections; the boundary between two agents' jurisdictions | `seam` is the manuscript join only. Agent jurisdiction is a **boundary** — the word `DESCRIPTION-STYLE.md` and `check-boundaries.py` already use. |
| `load-bearing` | the ordinary adjective (a load-bearing claim, term, assumption); the proof-step significance tag of `theorem-presentation-auditor` | as a tag, backticked and inside an explicit significance-tagging context, alongside `technical` and `bookkeeping`; unbackticked prose use stays adjectival |
| `Tier-1` | claim load; contribution significance | owned by the `claim-tiers` skill — write `Tier-1 contribution` in full. Cite it; do not restate it here. |
| `satellite claim` | reads as a kind of claim; names a failure mode | `Satellite-claim instance`, never a bare noun phrase |

**Adding a term** takes three edits in one commit: define it at the owning
agent, add the row below, add it to the apparatus-leakage list in
`narrative-clarity-auditor`. A term with only the first is undefined vocabulary
on the wire. A term with only the third is a ban on a word the suite never
defined — the state several of the current eighteen are in, `spine` and
`harness` among them.

## The glossary

One meaning each. The owner is where the term is defined and where a change to
its meaning starts.

| Term | Part | Meaning | Owner |
|---|---|---|---|
| `bookkeeping` | adj. | significance tag for a proof step that is routine given its surroundings; siblings `load-bearing`, `technical` | `theorem-presentation-auditor` |
| `carrier` | n. | a figure, table, theorem, or script that carries or supports a dispositioned claim | `claim-disposition-gate` |
| `claim ledger` | n. | the enumerated claim surface, one disposition per claim, with the bipartite carrier map | `claim-disposition-gate` |
| `delta mode` | n. | a re-run scoped to what changed since the last run rather than to the full surface | `claim-disposition-gate`, `manuscript-update-gate` |
| `disposition` | n., v. (`dispositioned`) | the assignment of exactly one of PROVED / MEASURED / TESTED / HEDGED / CUT to a claim | `claim-disposition-gate` |
| `enumeration failure` | n. | a claim present in the paper and absent from the claim ledger; a finding against the gate, not against the paper | `claim-disposition-gate` |
| `gate` | n. | an agent that can return `level=blocking`; an agent with no blocking token is not one | `verdict-protocol` skill |
| `harness` | n. | the scaffold, tooling, and model version that produced an artifact, recorded for reproducibility | `lean-proof-chain-validator` |
| `ledger` | n. | an append-only record with one row per enumerated item; qualified wherever both senses are in scope — see `claim ledger` and `notation ledger` | `claim-disposition-gate` |
| `load-bearing` | adj. | of a claim, term, assumption, or proof step: the argument fails without it. As a backticked significance tag, the level above `technical` and `bookkeeping` | `theorem-presentation-auditor` |
| `notation ledger` | n. | the manuscript's symbol inventory, checked for drift on every edit | `manuscript-update-gate` |
| `orphan` | n. | either end of a broken carrier edge: an artifact carrying no dispositioned claim, or a claim with no carrier. Both directions are findings. | `claim-disposition-gate` |
| `red thread` | n. | a candidate paper latent in a body of work: one core claim with its evidence map and risk profile | `research-divergence-cartographer` |
| `registration debt` | n. | a `DEBT:` line emitted by a generative agent for a finding worth pursuing, discharged by registration or a recorded decline | `hypothesis-register-keeper` |
| `residue` | n. | a typed, sourced counter-argument still standing after a claim is closed `supported`; what the limitations section owes the reader | `hypothesis-register-keeper` |
| `satellite claim` | n. | a failure mode: a value in the paper that does not derive from the pipeline — a remark formula never formalized, a prose number not generated, a constant hand-copied into code | `claim-disposition-gate` |
| `seam` | n. | the join between two manuscript sections, where notation, scope, or voice drifts | `manuscript-update-gate` |
| `shadow statement` | n. | the S⁺/S⁻ pair making a narrative claim falsifiable: the strongest statement the prose commits to, and the weakest the argument needs. Audit apparatus; never displayed. | `claim-disposition-gate` |
| `so-what` | n. | the fourth narrative question — what follows from the result — distributed unevenly across title, abstract, introduction, body, and conclusion by a contract this agent owns | `manuscript-update-gate` |
| `spine` | n. | the main line of a paper, or of a candidate thread before a paper exists: the definitions, theorems, and claims the argument depends on, as against what hangs off it in appendices | `07-paper-structure-architect` |

## Adopted from ASD-STE100, and not

STE governs aircraft maintenance procedures read by non-native speakers under
time pressure. Two of its premises fail here: the reader is not a technician
executing steps, and the content is findings rather than procedures.

**Adopted.** One term / one meaning / one part of speech. The technical-name
escape hatch — a domain may add vocabulary provided it is declared, which is
what the glossary above and the domain `TOKEN` of `verdict-protocol` both are.
Never ban a word without naming its replacement.

**Not adopted, deliberately:**

- **Sentence-length caps.** STE caps procedural sentences near twenty words.
  Uniform compression is precisely the failure Rule 7 of
  `narrative-clarity-auditor` exists to catch: expository weight tells the
  reader where the hard part is, and a cap destroys that signal.
- **A closed dictionary.** STE approves under a thousand words, one sense each.
  Agents here are asked for scientific judgment — to say the thing no template
  anticipated. A closed word list bounds the finding, not just its phrasing.
- **The ban on modality.** STE strips *may*, *might*, *could*, because a
  technician must not improvise. Here, hedges are calibrated to evidence by the
  `epistemic-calibration-auditor` ladder, and stripping them would mandate
  overclaim. The `report` rule above restricts modality spent on *deference*,
  which is a different thing.

These are recorded rather than omitted so that the next person to read STE does
not import it whole.
