---
name: writing-registers
description: The eight venue registers this suite calibrates writing against, and the knob matrix that says what each register permits. Use when auditing, drafting, or gating prose where the venue changes what counts as a defect, or when an agent needs to declare which registers it accepts.
---

# Writing Registers

A rule that is load-bearing in a Nature letter can be a defect in a blog post.
`register` is the parameter that carries the venue into every writing agent, and
this file is where its values and their meanings are defined. An agent that
enumerates registers inline will drift from the others; point here instead.

## The values

`blog | tutorial | lecture-note | tech-report | empirical-paper | theoretical-paper | nature-letter | policy-essay`

Eight, no more. A venue that does not fit picks the nearest and records the
divergence; adding a ninth value means editing this file, not improvising one.

## The knob matrix

Defaults per register. An agent's `overrides` input may adjust individual cells —
useful when a paper genuinely is about physical systems and physical metaphors
should be allowed despite the register being `theoretical-paper`.

| Knob | blog | tutorial | lecture-note | tech-report | empirical-paper | theoretical-paper | nature-letter | policy-essay |
|---|---|---|---|---|---|---|---|---|
| **voice** | personal | personal | personal | first-person-plural | first-person-plural | first-person-plural | impersonal | personal |
| **metaphor budget** | liberal | moderate | liberal | moderate | sparse | none-default | none-default | moderate |
| **inline warnings** | optional | required | required | optional | discouraged | discouraged | suppressed | optional |
| **story-of-discovery proofs** | encouraged | required | required | sketch | sketch-then-formal | sketch-then-formal | suppressed | n/a |
| **acknowledge difficulty plainly** | explicit | explicit | explicit | semi-explicit | euphemistic | euphemistic | passive-only | explicit |
| **multiple angles on a concept** | encouraged | encouraged | encouraged | space-budgeted | space-budgeted | space-budgeted | one angle only | encouraged |
| **anecdote / personal trail of thought** | encouraged | optional | optional | discouraged | suppressed | suppressed | suppressed | encouraged |
| **figures / diagrams as primary teaching tools** | encouraged | required | encouraged | encouraged | required | encouraged | required | encouraged |

### Reading a cell

- **liberal / required / encouraged** — actively enforce. Absence is a violation
  where the discipline calls for it.
- **moderate / optional / space-budgeted** — do not require, but accept. Flag only
  when the use is *out of calibration*: a paper that reaches for a metaphor amid
  formal paragraphs and then forgets to land back in formality.
- **sparse / discouraged** — flag presence beyond a small budget, and suggest a
  replacement rather than only a deletion.
- **suppressed / none-default / one angle only** — flag any presence.
- **n/a** — the knob does not apply at this register; say nothing about it.

A register never switches a *universal* rule off. It changes the length and form
a rule takes, never whether it holds. In particular, `euphemistic` and
`passive-only` on the difficulty knob govern how difficulty is named — they are
not permission to flatten the expository weight gradient.

### Voice

- `personal` — "I", "you", direct address. "We" with the reader as participant is allowed.
- `first-person-plural` — "we" meaning the authors collectively. No "I". Reader-as-participant ("we will see…") is permitted but minimized.
- `impersonal` — "the data show" rather than "we show". Many Nature-style venues require it.

### Metaphor budget

`none-default` does not mean "never any analogy." It means a physical or everyday
analogy must earn its place: the default is formal language, and a deviation needs
a reason — usually that the formal statement is opaque on first reading and the
analogy gives the reader a foothold.

At `theoretical-paper` and `empirical-paper`, *mathematical* analogies ("this
generalizes the Lipschitz condition") stay liberal. The budget restricts physical
and everyday analogies. A paper genuinely about physical systems may override the
knob to `moderate`, and the agent that accepts the override records it.

## Declaring a subset

Most agents accept fewer than eight. A theorem auditor has nothing to say about a
blog post; a manuscript gate runs on papers. Subsetting is legitimate. Silently
subsetting is not — a caller reading four values cannot tell whether the other
four were excluded or forgotten.

An agent that accepts a subset states it in that shape:

> **`register`** (required): one of `empirical-paper | theoretical-paper |
> nature-letter | tech-report` — the paper-bearing subset of the eight registers
> in the `writing-registers` skill. The four excluded registers (`blog`,
> `tutorial`, `lecture-note`, `policy-essay`) have no manuscript to gate.

Name the excluded values and give the reason. One sentence is enough, and it is
the sentence that keeps the next person from "fixing" the subset by widening it.

"Not a register" is not a register. An agent that needs a sentinel for input it
refuses to handle uses a refusal condition, not a ninth value.

## Setting the register for a paper

`07-paper-structure-architect` sets it from the venue and records it in the
paper's `.manuscript-gate.json`. Every downstream writing agent reads it from
there rather than defaulting separately, which is what keeps the auditors, the
gate, and the update hooks calibrated to one venue instead of three.
