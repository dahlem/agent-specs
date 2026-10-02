#!/usr/bin/env python3
"""Generate the agent/skill graph section of README.md from the specs themselves.

The topology was previously written down in three places — each agent's position
clause, the README's workflow prose, and DESCRIPTION-STYLE.md's canonical
numberings — which is three copies of one graph and two chances to drift. This
makes the descriptions the source of truth and the README a view of them.

    scripts/gen-graph.py            rewrite the marked block in README.md
    scripts/gen-graph.py --check    exit 1 if the block is stale (CI)
    scripts/gen-graph.py --stdout   print the block, touch nothing

Only mechanically derivable edges appear here: a pipeline position an agent
*declares* in its own description, and a skill an agent *cites* in its body.
Delegation edges are deliberately excluded — the house idiom for them varies
(`## X (Delegated)`, `## X (Mandatory)`, prose), and a parser that guessed would
produce a graph nobody could trust. Those live in the hand-written Auditor
Consumption Matrix, where the trigger can be named.
"""
import re, sys, pathlib

BEGIN = "<!-- BEGIN GENERATED: agent-graph (scripts/gen-graph.py) -->"
END = "<!-- END GENERATED: agent-graph -->"

DESC = re.compile(r'^description: "(.*)"$', re.M)
SKILL = re.compile(r'`([a-z0-9][a-z0-9-]+)` skill')

# (regex, pipeline-name group or literal, rank). First match wins.
RULES = [
    (re.compile(r'Phase (\d+) of the 10-phase research workflow'), "Research workflow", "n"),
    (re.compile(r'Final stage \(Stage (\d+)\) of the ([A-Za-z][A-Za-z- ]*?) pipeline'), 2, "n"),
    (re.compile(r'Stage (\d+) of the ([A-Za-z][A-Za-z- ]*?) (?:pipeline|track)'), 2, "n"),
    (re.compile(r'Conditional stage of the ([A-Za-z][A-Za-z- ]*?) pipeline'), 1, "cond"),
    (re.compile(r'[Ff]inal stage of the ([A-Za-z-]+) (?:track|cycle)'), 1, 99),
    (re.compile(r'Opening move of the ([A-Za-z-]+) cycle'), 1, 1),
    (re.compile(r'Generative stage of the ([A-Za-z-]+) cycle'), 1, 2),
    (re.compile(r'Filtering stage of the ([A-Za-z-]+) cycle'), 1, 3),
    (re.compile(r'Late stage of the ([A-Za-z-]+) cycle'), 1, 4),
]
TITLES = {
    "Research workflow": "Research workflow — 10 phases",
    "peer-review": "Peer review",
    "research-shaping": "Research shaping",
    "proof-dissection": "Proof dissection",
    "math-brainstorming": "Math brainstorming",
    "Lean formalization": "Lean formalization",
}
ORDER = ["Research workflow", "peer-review", "research-shaping",
         "proof-dissection", "math-brainstorming", "Lean formalization"]
# Entry points declare no stage: they *are* the sequence. Detected by name.
ENTRY = {"research-shaping-orchestrator": "research-shaping",
         "proof-dissection-orchestrator": "proof-dissection"}


def relation(desc: str, at: int) -> str:
    """What follows a position clause: a parenthetical, or an em-dash aside."""
    rest = desc[at:]
    m = re.match(r'\s*\((.*?)\)', rest) or re.match(r'\s*—\s*([^.]*)', rest)
    return m.group(1).strip() if m else ""


def anchors(readme: str) -> dict:
    """Map agent name -> README anchor, read off the hand-maintained Agent Index.

    Phase agents live under headings like "Phase 01 — Research Framing
    Validator", so the anchor is not derivable from the file name. Rather than
    encode that rule twice, take the links the index already maintains; an agent
    missing from the index is a real gap and is reported as one.
    """
    body = re.sub(re.escape(BEGIN) + r".*?" + re.escape(END), "", readme, flags=re.S)
    return dict(re.findall(r'\[`([a-z0-9][a-z0-9-]+)`\]\(#([a-z0-9-]+)\)', body))


def collect(agents_dir: pathlib.Path):
    pipes, loose, skills = {}, [], {}
    for f in sorted(agents_dir.rglob("*.md")):
        text = f.read_text()
        m = DESC.search(text)
        if not m:
            continue
        name, desc = f.stem, m.group(1)
        for s in set(SKILL.findall(text)):
            skills.setdefault(s, set()).add(name)

        if name in ENTRY:
            pipes.setdefault(ENTRY[name], []).append((-1, name, "entry point; sequences the stages below"))
            continue
        for pat, who, rank in RULES:
            hit = pat.search(desc)
            if not hit:
                continue
            pipe = who if isinstance(who, str) else hit.group(who)
            n = int(hit.group(1)) if rank == "n" else rank
            pipes.setdefault(pipe, []).append(
                (n if isinstance(n, int) else 50, name, relation(desc, hit.end())))
            break
        else:
            loose.append(name)
    return pipes, loose, skills


def render(pipes, loose, skills, anchor) -> str:
    out = [BEGIN, ""]
    out.append("### Pipelines")
    out.append("")
    out.append("Every row below is parsed from the agent's own `description:`, so this "
               "table and the router see the same topology.")
    out.append("")
    for key in ORDER + [k for k in sorted(pipes) if k not in ORDER]:
        rows = pipes.get(key)
        if not rows:
            continue
        out.append(f"**{TITLES.get(key, key)}**")
        out.append("")
        out.append("| | Agent | Reads / feeds |")
        out.append("|---|---|---|")
        for n, name, rel in sorted(rows):
            label = {-1: "→", 50: "cond", 99: "last"}.get(n, str(n))
            out.append(f"| {label} | [`{name}`](#{anchor[name]}) | {rel or '—'} |")
        out.append("")
    out.append("`cond` runs only when a flag fires; `last` is a declared final "
               "stage with no number; `→` is the orchestrator you invoke to run "
               "the whole track.")
    out.append("")
    out.append("### Agents that fire on a condition, not a position")
    out.append("")
    out.append("These declare no pipeline stage, deliberately: a gate that fires on "
               "every manuscript change, or a tool reached for when a question comes "
               "up, has no \"after\" to name.")
    out.append("")
    out.append(", ".join(f"[`{a}`](#{anchor[a]})" for a in sorted(loose)) + ".")
    out.append("")
    out.append("### Skills")
    out.append("")
    out.append("| Skill | Cited by |")
    out.append("|---|---|")
    for s in sorted(skills):
        who = ", ".join(f"`{a}`" for a in sorted(skills[s]))
        out.append(f"| [`{s}`](skills/{s}/SKILL.md) | {who} |")
    out.append("")
    out.append(END)
    return "\n".join(out)


def main() -> int:
    root = pathlib.Path(__file__).resolve().parent.parent
    readme = root / "README.md"
    s = readme.read_text()
    if BEGIN not in s or END not in s:
        print(f"error: {readme.name} has no generated-block markers", file=sys.stderr)
        return 2

    pipes, loose, skills = collect(root / "agents")
    anchor = anchors(s)
    named = {n for rows in pipes.values() for _, n, _ in rows} | set(loose)
    missing = sorted(named - set(anchor))
    if missing:
        for n in missing:
            print(f"error: {n} has no entry in the README Agent Index, so the "
                  f"graph cannot link to it", file=sys.stderr)
        return 2
    block = render(pipes, loose, skills, anchor)
    if "--stdout" in sys.argv:
        print(block)
        return 0
    new = re.sub(re.escape(BEGIN) + r".*?" + re.escape(END), lambda _: block, s, flags=re.S)
    if "--check" in sys.argv:
        if new != s:
            print("README.md agent-graph block is stale — run scripts/gen-graph.py",
                  file=sys.stderr)
            return 1
        return 0
    readme.write_text(new)
    print(f"regenerated agent-graph block ({len(block.splitlines())} lines)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
