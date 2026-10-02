---
name: verdict-protocol
description: The shared verdict line every auditing or gating agent in this suite ends on. Use when writing or revising an agent that issues a verdict, or when one agent must consume another's verdict programmatically — chaining, gating, or escalating on a count.
---

# Verdict Protocol

Ten agents in this suite end on a verdict. Before this protocol they ended on
three incompatible shapes, so no agent could branch on another's result without a
hand-written lookup table, and chaining had to be done by a human reading prose.

## The line

The **last line** of a verdict-emitting agent's output, with nothing after it:

```
VERDICT: <TOKEN> | level=<pass|advisory|blocking|indeterminate> | findings=<n>
```

Three fields, pipe-delimited, in this order. A consumer greps `^VERDICT:` and
splits on `|`. No other line in the output may begin with `VERDICT:`.

**`TOKEN`** — the domain verdict, `SCREAMING-KEBAB`. This is the agent's own
vocabulary and it is meant to stay domain-specific: `DESIGN-READY` says something
`ADVISORY` does not. Scope the token with a prefix unique to the agent
(`CLARITY-`, `REGISTER-`, `GATE-`) unless the bare token is already unambiguous
across the suite (`DESIGN-READY`, `TALK-READY`).

**`level`** — the universal mapping, exactly one of four values. This is the
field consumers branch on, which is why the domain token does not have to be:

| level | meaning | downstream |
|---|---|---|
| `pass` | nothing found, or nothing worth acting on | proceed |
| `advisory` | findings exist; the author should act, but the artifact is usable | proceed, carrying the findings forward |
| `blocking` | the artifact is not fit for its next step | stop; re-run after repair |
| `indeterminate` | the check could not run — the inputs it needs are absent | stop; supply the inputs, or proceed having recorded that this dimension is unchecked |

`indeterminate` is not a soft `pass` and not a finding against the artifact. It
says the agent declined to certify rather than certifying nothing was wrong, and
a consumer that collapses it into `pass` has invented a guarantee. Use it only
for a missing *input* — absent process records, no artifacts in scope — never for
a finding the agent found hard to classify.

**`findings`** — the count the level is derived from. `0` on `pass`. A count the
agent cannot honestly produce is a sign the verdict is a mood rather than a
finding; enumerate first, then count.

## Declaring a vocabulary

Every verdict-emitting agent carries a `## Verdict` section naming its tokens and
the level each maps to. Do not leave the mapping implicit — the whole point is
that a consumer never has to read the body to interpret the line.

```markdown
## Verdict

| Token | level | when |
|---|---|---|
| `CLARITY-CLEAN` | pass | no rule violated at this register |
| `CLARITY-MINOR` | advisory | violations are local; the draft reads |
| `CLARITY-MAJOR` | blocking | a section has to be rewritten, not patched |
```

Exactly one token maps to `pass`. At least one maps to `blocking`, or the agent
is not a gate and should say so rather than pretending it can stop anything. A
token maps to exactly one level; if you want one token to mean two things
depending on severity, you want two tokens.

Sub-verdicts inside the body of an output — a per-claim ruling, a per-link chain
verdict — are unaffected by this protocol and should keep whatever vocabulary
reads best. They just must not be written as a bare `VERDICT:` line at column 0,
which is reserved for the one terminal line.

## Consuming a verdict

Branch on `level`, read `findings` for severity, quote `TOKEN` when reporting to
a human. An agent that branches on a specific `TOKEN` has coupled itself to
another agent's vocabulary and will break when that vocabulary grows — do it only
when the domain distinction is the actual trigger, and say so at the call site.

Where the threshold between `advisory` and `blocking` sits is the emitting
agent's judgment and belongs in its body. A consumer that disagrees escalates its
own verdict; it does not relabel the one it received.
