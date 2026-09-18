#!/usr/bin/env python3
"""Validate the hypothesis -> data -> scalars -> LaTeX macro chain.

Every number a paper states should be traceable to a registered hypothesis and
regenerable from committed data. This checks the links mechanically, so that
"generated, not transcribed" is a property of the repository rather than a habit.

    scripts/check-evidence-chain.py [paper-repo] [--json]

Expected layout (override with .evidence-chain.json at the repo root):

    hypothesis-register/H-0007-*.md    registered hypotheses
    doe/H-0007.yaml                    the registered design
    results/H-0007.json                citable scalars, with input hashes
    macros/hypothesis_H0007.tex        generated \\newcommand definitions (namespaced, see macro_pattern)
    *.tex                              the manuscript

Checks, in order of what they prevent:

  1 staleness      each JSON's recorded input hashes match the files on disk
  2 provenance     each macro file names a hypothesis that exists in the register
  3 drift          every scalar's `formatted` value appears verbatim in its macro
  4 orphan-macro   no macro defined that the scalars file does not back
  5 undefined      no \\H... macro used in the manuscript that is never defined
  6 unused         scalars generated but never cited (dead weight, or a gap)
  7 collision      one macro name defined by two hypotheses
  8 exploratory    scalars marked registered:false, whose claims must be hedged
  9 precision      more decimals printed than the sample size supports

Exit 0 clean, 1 findings, 2 layout error. Check 8 reports rather than decides:
whether the surrounding prose is honestly hedged is a calibration judgment, not
something a script can settle.
"""
import json, re, sys, hashlib, pathlib, argparse

DEFAULTS = {
    "register_dir": "hypothesis-register",
    "doe_dir": "doe",
    "results_dir": "results",
    "macros_dir": "macros",
    "manuscript_globs": ["*.tex", "sections/*.tex"],
    # Generated macros must be namespaced so that a use with no definition is
    # distinguishable from an ordinary LaTeX command. Default: a capital H
    # followed by another capital, which \Huge and friends do not match.
    "macro_pattern": "^H[A-Z]",
}
MACRO_DEF = re.compile(r'^\s*\\newcommand\{?\\([A-Za-z]+)\}?\s*\{(.*)\}\s*(?:%.*)?$', re.M)
HYP_IN_NAME = re.compile(r'(H-?\d{3,})', re.I)


def sha256(p: pathlib.Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def norm(hid: str) -> str:
    """H0007, h-0007, H-0007 all name the same hypothesis."""
    m = HYP_IN_NAME.search(hid)
    return "H-" + re.sub(r'\D', '', m.group(1)).zfill(4) if m else hid


class Findings:
    def __init__(self): self.items = []
    def add(self, check, severity, where, msg):
        self.items.append({"check": check, "severity": severity, "where": where, "message": msg})
    def __bool__(self): return any(i["severity"] != "info" for i in self.items)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("root", nargs="?", default=".")
    ap.add_argument("--json", action="store_true", help="machine-readable output")
    args = ap.parse_args()

    root = pathlib.Path(args.root).resolve()
    cfg = dict(DEFAULTS)
    cfg_file = root / ".evidence-chain.json"
    if cfg_file.exists():
        try:
            cfg.update(json.loads(cfg_file.read_text()))
        except json.JSONDecodeError as e:
            print(f"error: {cfg_file} is not valid JSON ({e})", file=sys.stderr)
            return 2

    results_dir = root / cfg["results_dir"]
    macros_dir = root / cfg["macros_dir"]
    if not results_dir.is_dir() and not macros_dir.is_dir():
        print(f"error: neither {cfg['results_dir']}/ nor {cfg['macros_dir']}/ found under {root}", file=sys.stderr)
        print("       not an evidence-chain repository, or run from the paper root", file=sys.stderr)
        return 2

    f = Findings()

    registered = {norm(p.name) for p in (root / cfg["register_dir"]).glob("*.md")} \
        if (root / cfg["register_dir"]).is_dir() else set()
    doe = {norm(p.stem) for p in (root / cfg["doe_dir"]).glob("*")} \
        if (root / cfg["doe_dir"]).is_dir() else set()

    # --- load scalars ---------------------------------------------------
    scalars = {}          # hyp -> {name: entry}
    for jp in sorted(results_dir.glob("*.json")) if results_dir.is_dir() else []:
        hyp = norm(jp.stem)
        try:
            doc = json.loads(jp.read_text())
        except json.JSONDecodeError as e:
            f.add("layout", "error", str(jp.relative_to(root)), f"invalid JSON: {e}")
            continue
        scalars[hyp] = doc.get("scalars", {})

        # 1 staleness
        for inp in doc.get("inputs", []):
            ip = root / inp.get("path", "")
            if not ip.exists():
                f.add("staleness", "error", str(jp.relative_to(root)),
                      f"declared input {inp.get('path')!r} does not exist")
            elif inp.get("sha256") and sha256(ip) != inp["sha256"]:
                f.add("staleness", "error", str(jp.relative_to(root)),
                      f"{inp['path']} changed since these scalars were generated — regenerate before citing them")
        if not doc.get("inputs"):
            f.add("staleness", "warn", str(jp.relative_to(root)),
                  "no inputs[] recorded, so staleness cannot be detected")

        # 2 provenance
        if registered and hyp not in registered:
            f.add("provenance", "error", str(jp.relative_to(root)),
                  f"{hyp} has no entry in {cfg['register_dir']}/ — results exist for an unregistered hypothesis")
        if doe and hyp not in doe:
            f.add("provenance", "warn", str(jp.relative_to(root)),
                  f"{hyp} has no design in {cfg['doe_dir']}/ — the executed design cannot be diffed against a registered one")

        # 8 exploratory, 9 precision
        for name, e in scalars[hyp].items():
            if not isinstance(e, dict):
                continue
            if e.get("registered") is False:
                f.add("exploratory", "warn", f"{jp.name}:{name}",
                      "registered:false — every claim citing this must be labelled exploratory (prose judgment; not decided here)")
            elif "registered" not in e:
                f.add("exploratory", "warn", f"{jp.name}:{name}",
                      "no `registered` flag; cannot tell a pre-specified metric from a post-hoc one")
            n, fm = e.get("n"), str(e.get("formatted", ""))
            if isinstance(n, int) and n > 0 and "." in fm:
                dec = len(fm.split(".")[-1].rstrip("%"))
                if dec > max(1, len(str(n))):
                    f.add("precision", "warn", f"{jp.name}:{name}",
                          f"{fm} shows {dec} decimals from n={n}; more precision than the sample supports")

    # --- load macro definitions ----------------------------------------
    defined = {}          # macro -> (hyp, value, file)
    for mp in sorted(macros_dir.glob("*.tex")) if macros_dir.is_dir() else []:
        hyp = norm(mp.stem)
        text = mp.read_text()
        for name, value in MACRO_DEF.findall(text):
            if name in defined and defined[name][0] != hyp:      # 7 collision
                f.add("collision", "error", f"{mp.name}:{name}",
                      f"also defined by {defined[name][0]} — \\newcommand will abort the build, which is correct; rename")
            defined[name] = (hyp, value.strip(), mp.name)

        if hyp not in scalars:
            f.add("orphan-macro", "error", mp.name,
                  f"no {cfg['results_dir']}/{mp.stem}.json backs this macro file")
            continue

        # 3 drift + 4 orphan-macro
        jname = f"{hyp}.json"
        formatted = {str(e.get("formatted")) for e in scalars[hyp].values() if isinstance(e, dict)}
        by_value = {}
        for nm, e in scalars[hyp].items():
            if isinstance(e, dict):
                by_value.setdefault(str(e.get("formatted")), []).append(nm)
        for name, value in MACRO_DEF.findall(text):
            if value.strip() not in formatted:
                f.add("drift", "error", f"{mp.name}:\\{name}",
                      f"value {value.strip()!r} matches no `formatted` scalar in {jname} — hand-edited, or the macro file is stale")
        emitted = {v.strip() for _, v in MACRO_DEF.findall(text)}
        for val, names in by_value.items():
            if val not in emitted:
                f.add("orphan-scalar", "warn", f"{jname}:{','.join(names)}",
                      "scalar has no macro; it cannot be cited without transcription")

    # --- manuscript usage ----------------------------------------------
    tex = []
    for g in cfg["manuscript_globs"]:
        tex += [p for p in root.glob(g) if macros_dir not in p.parents and p.parent != macros_dir]
    try:
        is_generated = re.compile(cfg["macro_pattern"]).search
    except re.error as e:
        print(f"error: macro_pattern is not a valid regex ({e})", file=sys.stderr)
        return 2
    used = {}
    for p in tex:
        body = re.sub(r'(?<!\\)%.*', '', p.read_text())     # strip comments
        for m in re.finditer(r'\\([A-Za-z]+)', body):
            if m.group(1) in defined or is_generated(m.group(1)):
                used.setdefault(m.group(1), set()).add(p.name)

    for name, where in sorted(used.items()):               # 5 undefined
        if name not in defined:
            f.add("undefined", "error", ", ".join(sorted(where)),
                  f"\\{name} matches the generated-macro namespace but is defined nowhere — "
                  f"the build will fail, or worse, a \\providecommand fallback will ship a placeholder")
    for name, (hyp, _, mf) in sorted(defined.items()):     # 6 unused
        if name not in used and tex:
            f.add("unused", "info", f"{mf}:\\{name}",
                  f"defined but never cited (fine while drafting; dead weight at freeze)")

    # --- lineage map (the payoff) ---------------------------------------
    lineage = {}
    for name, files in used.items():
        if name in defined:
            lineage.setdefault(defined[name][0], set()).update(files)

    if args.json:
        print(json.dumps({
            "findings": f.items,
            "lineage": {k: sorted(v) for k, v in sorted(lineage.items())},
            "verdict": "CHAIN-CLEAN" if not f else f"FINDINGS({sum(1 for i in f.items if i['severity'] != 'info')})",
        }, indent=2))
    else:
        for sev in ("error", "warn", "info"):
            for i in [x for x in f.items if x["severity"] == sev]:
                print(f"{sev.upper():5} [{i['check']}] {i['where']}: {i['message']}")
        if lineage:
            print("\nClaim lineage (hypothesis -> manuscript files citing it):")
            for hyp, files in sorted(lineage.items()):
                print(f"  {hyp} -> {', '.join(sorted(files))}")
        n_err = sum(1 for i in f.items if i["severity"] != "info")
        print(f"\n{'CHAIN-CLEAN' if not f else f'FINDINGS({n_err})'}"
              f"  ({len(defined)} macros, {sum(len(v) for v in scalars.values())} scalars, {len(scalars)} hypotheses)")
    return 1 if f else 0


if __name__ == "__main__":
    sys.exit(main())
