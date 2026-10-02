#!/usr/bin/env python3
"""Boundary-symmetry check for agent descriptions (lint check 11).

DESCRIPTION-STYLE.md: if A's description disambiguates from B, B's must
disambiguate from A. A cluster of four would need twelve boundary sentences to
satisfy that literally, which is more description budget than the router gets
back — so an asymmetry is allowed when it is *declared*, with a reason, in
scripts/boundary-exceptions.txt. Undeclared asymmetry is an error; a declaration
that no longer describes an asymmetry is a warning, so the file cannot rot.

    check-boundaries.py AGENTS_DIR EXCEPTIONS_FILE [SPEC...]

With SPEC arguments, only pairs touching those files are reported. Prints one
finding per line, prefixed WARN for warnings; silent and exit 0 when clean.
"""
import re, sys, pathlib

DESC = re.compile(r'^description: "(.*)"$', re.M)
# The boundary clause runs from "Distinct from" to the end of the prose block;
# the examples begin at the first escaped newline.
CLAUSE = re.compile(r"Distinct from (.*?)(?:\\n|$)")
TOKEN = re.compile(r"`([a-z0-9][a-z0-9-]*)`")


def main() -> int:
    agents_dir = pathlib.Path(sys.argv[1])
    exc_file = pathlib.Path(sys.argv[2])
    scope = {str(pathlib.Path(p).resolve()) for p in sys.argv[3:]}

    desc = {}
    for f in sorted(agents_dir.rglob("*.md")):
        m = DESC.search(f.read_text())
        if m:
            desc[f.stem] = (m.group(1), str(f.resolve()))

    declared = {}
    if exc_file.is_file():
        for raw in exc_file.read_text().splitlines():
            line = raw.split("#", 1)[0].strip()
            if "->" not in line:
                continue
            a, b = (x.strip() for x in line.split("->", 1))
            declared[(a, b)] = True

    seen, out = set(), []
    for a, (da, fa) in desc.items():
        clause = CLAUSE.search(da)
        if not clause:
            continue
        for b in TOKEN.findall(clause.group(1)):
            if b == a or b not in desc:
                continue
            db, fb = desc[b]
            if f"`{a}`" in db or f"the {a} agent" in db:
                continue
            seen.add((a, b))
            if (a, b) in declared:
                continue
            if scope and not ({fa, fb} & scope):
                continue
            out.append(
                f"`{a}` disambiguates from `{b}`, but `{b}` does not name `{a}` — "
                f"make it symmetric, or declare the pair in "
                f"{exc_file.name} with the reason it is one-way"
            )

    for a, b in declared:
        if (a, b) not in seen:
            out.append(
                f"WARN {exc_file.name} declares `{a}` -> `{b}` one-way, but that "
                f"asymmetry no longer exists — drop the line"
            )

    for line in out:
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
