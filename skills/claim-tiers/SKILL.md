---
name: claim-tiers
description: The Tier-1/2/3 claim taxonomy shared across this suite's authoring, review, and gating agents, including the two different cardinality regimes and the separate significance-tier axis that uses the same word. Use when enumerating, tiering, or arguing about a paper's claims.
---

# Claim Tiers

Twenty-one agents in this suite talk about Tier-1 claims. They mean the same
structural thing, they disagree on cardinality for a good reason, and one agent
uses the same word for a different axis entirely. All three facts are here so no
agent has to carry a second copy.

## The structural tiers

Tiering is about **load**: what the paper collapses without.

**Tier-1 — Core.** The scientific statement that justifies the paper's existence.
Remove it and the paper has no reason to exist. Canonical form:

> "We show that [mechanism/principle] enables [new capability / explanation]
> under [specific conditions]."

It must appear in the abstract, at the end of the introduction, and in the
conclusion. In an empirical paper it is carried by both theory and evidence.

**Tier-2 — Supporting.** Claims that enable the core claim: a structural theorem,
an estimator construction, an empirical phenomenon, an evaluation methodology.
Each maps to a section, a figure, a result, and exactly one contribution axis,
and each derives from the paper's central mechanism rather than standing beside
it.

**Tier-3 — Peripheral.** Observations that support the narrative without being
necessary: dataset-specific patterns, secondary ablations, architectural
speculation. They never appear in the abstract.

A claim's tier is a property of the paper's argument, not of how confident the
authors are or how much work it took. A hard result that nothing depends on is
Tier-3.

## Two cardinality regimes

The counts differ by what you are doing, and this is deliberate — an agent that
"corrects" one regime to the other is introducing a bug.

| | Tier-1 | Tier-2 | who |
|---|---|---|---|
| **Authoring** — prescribing the paper you are writing | exactly 1 | 2–4 | `scientific-narrative-architect`, `06-argument-architect`, `red-thread-selector` |
| **Describing** — recording the paper someone else wrote | typically 1–3 | typically 3–8 | `paper-compressor` and the peer-review pipeline downstream of it |

Authoring cardinalities are a discipline: a second core claim means two papers.
Describing cardinalities are observations, so they are wider. A paper carrying
three Tier-1 claims is not a compression error — it is a **finding**, reported as
diffuse identity, and the reviewer decides what it costs.

An agent that both describes and prescribes says which hat it is wearing at each
step. `claim-disposition-gate` is the clearest case: it enumerates your own
paper's claims (describing, so it accepts what it finds) and then dispositions
them (prescribing, so residue is a defect).

## The other Tier-1

`domain-historian` uses `Tier-1 / Tier-2 / Tier-3` for a **significance** tier:
what magnitude of contribution counts as top-tier *in this subfield at this
date*. That is an orthogonal axis. A paper's Tier-1 claim is whatever it rests
on; whether that claim amounts to a Tier-1 *contribution* is the question
`domain-historian` answers, and the answer is routinely "no."

Conflating them produces a specific error: reading a confident Tier-1 claim as
evidence of a Tier-1 contribution, which is exactly the inference a paper's
framing is designed to invite.

When both axes are in play in one artifact, qualify every use — **Tier-1 claim**
or **Tier-1 contribution**, never a bare "Tier-1." `domain-historian`'s own
output does this where the two meet, and anything consuming it should preserve
the qualifier rather than shortening it back.
