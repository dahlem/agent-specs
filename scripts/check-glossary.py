#!/usr/bin/env python3
"""Two-way check between the apparatus glossary and the apparatus-leakage list.

The `handoff-protocol` skill defines the suite's internal vocabulary and
permits it on the wire; `narrative-clarity-auditor`'s apparatus-leakage sweep
bans the same vocabulary from reaching a manuscript. The skill states that the
two are one list read in opposite directions. Nothing enforced that, and the
first mechanical check found three terms banned with no definition — the exact
state the skill calls "vocabulary the suite bans without having defined".

Both directions are errors, for different reasons:

  banned, not defined   the suite forbids a word it never defined, so nobody
                        can tell what was meant or propose a replacement
  defined, not banned   apparatus vocabulary that can reach a manuscript with
                        no sweep flagging it

A qualified form counts as covered when the bare term it specialises is banned:
`claim ledger` is covered by `ledger`, because a manuscript containing the
first contains the second.

    check-glossary.py [SKILL_FILE AUDITOR_FILE]

Prints one finding per line; silent and exit 0 when clean, exit 1 on findings.
"""
import re
import sys
import pathlib

SKILL = "skills/handoff-protocol/SKILL.md"
AUDITOR = "agents/writing/narrative-clarity-auditor.md"

GLOSSARY_HEADER = "| Term | Part | Meaning | Owner |"
LEAK_MARKER = "Apparatus leakage"
LEAK_START = "Flag any of it that reaches the manuscript:"
LEAK_END = ". This list"

BACKTICKED = re.compile(r"`([^`]+)`")

# A parser that silently finds nothing would pass forever. Both lists are known
# to be well over this today; the floor only has to catch a structural break.
MIN_TERMS = 10


def fail(msg: str) -> int:
    print(f"ERROR {msg}")
    return 1


def banned_terms(path: pathlib.Path) -> set[str]:
    """The backticked terms of the apparatus-leakage sweep."""
    lines = [l for l in path.read_text().splitlines() if LEAK_MARKER in l]
    if len(lines) != 1:
        raise LookupError(
            f"{path}: expected exactly one '{LEAK_MARKER}' line, found {len(lines)}"
        )
    line = lines[0]
    if LEAK_START not in line or LEAK_END not in line:
        raise LookupError(
            f"{path}: the apparatus-leakage line no longer has its "
            f"'{LEAK_START}' … '{LEAK_END}' markers — update this script with it"
        )
    segment = line.split(LEAK_START, 1)[1].split(LEAK_END, 1)[0]
    return set(BACKTICKED.findall(segment))


def defined_terms(path: pathlib.Path) -> set[str]:
    """Glossary row keys, plus inflections declared in the Part cell."""
    text = path.read_text()
    if GLOSSARY_HEADER not in text:
        raise LookupError(
            f"{path}: glossary table header not found — update this script with it"
        )
    terms = set()
    for row in text.split(GLOSSARY_HEADER, 1)[1].splitlines():
        if not row.startswith("| `"):
            # The table ends at the first line that is not a row.
            if terms and not row.startswith("|"):
                break
            continue
        cells = [c.strip() for c in row.split("|")]
        term = BACKTICKED.findall(cells[1])
        if not term:
            continue
        terms.add(term[0])
        # "n., v. (`dispositioned`)" declares an inflection of the same term.
        terms.update(BACKTICKED.findall(cells[2]) if len(cells) > 2 else [])
    return terms


def covered_by(term: str, banned: set[str]) -> bool:
    """True when `term` is banned outright, or specialises a banned term."""
    if term in banned:
        return True
    words = term.split()
    return any(
        b in banned
        for n in range(1, len(words))
        for b in (" ".join(words[n:]), " ".join(words[:-n]))
    )


def main() -> int:
    root = pathlib.Path(__file__).resolve().parent.parent
    skill = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else root / SKILL
    auditor = pathlib.Path(sys.argv[2]) if len(sys.argv) > 2 else root / AUDITOR

    for f in (skill, auditor):
        if not f.is_file():
            return fail(f"{f}: not found")

    try:
        banned = banned_terms(auditor)
        defined = defined_terms(skill)
    except LookupError as e:
        return fail(str(e))

    if len(banned) < MIN_TERMS or len(defined) < MIN_TERMS:
        return fail(
            f"parsed {len(banned)} banned and {len(defined)} defined terms; "
            f"both lists are far longer than that, so the parser is broken, "
            f"not the lists"
        )

    out = []
    for t in sorted(banned - defined):
        out.append(
            f"`{t}` is banned from manuscripts by {AUDITOR} but defined in no "
            f"glossary row — the suite bans a word it never defined. Add a row "
            f"to {SKILL}, or drop it from the sweep."
        )
    for t in sorted(defined - banned):
        if covered_by(t, banned):
            continue
        out.append(
            f"`{t}` is glossary vocabulary with no entry in the apparatus-leakage "
            f"sweep of {AUDITOR} — it can reach a manuscript unflagged. Add it "
            f"to the sweep, or drop the glossary row."
        )

    for line in out:
        print(line)
    return 1 if out else 0


if __name__ == "__main__":
    sys.exit(main())
