"""Run a source's code cells headless, notebook-style, capturing text, LaTeX and figure outputs.

Usage:
    python3 run_code_cells.py notebook.ipynb  PREFIX     # code cells of a Jupyter notebook
    python3 run_code_cells.py cells.py        PREFIX     # a Python file defining BLOCKS = ["...", "..."]
Outputs:
    PREFIX-outputs.json   list (one entry per cell) of [kind, value] pairs, kind in {text, latex, fig, error}
    fig/PREFIX-N.png      figures produced by display(fig) or by a cell ending in a Figure expression
Cells run in order in one namespace, like a notebook: the last bare expression is displayed,
`display` is emulated, and lines starting with '!' or '%' are skipped. Requires the libraries the cells import.
"""
import ast
import json
import os
import sys

import matplotlib
matplotlib.use("Agg")
from matplotlib.figure import Figure  # noqa: E402


def load_cells(path):
    if path.endswith(".ipynb"):
        nb = json.load(open(path, encoding="utf-8"))
        cells = []
        for c in nb.get("cells", []):
            if c.get("cell_type") == "code":
                src = c.get("source", [])
                src = "".join(src) if isinstance(src, list) else src
                src = "\n".join(l for l in src.splitlines() if not l.lstrip().startswith(("!", "%")))
                cells.append(src)
        return cells
    ns = {}
    exec(open(path, encoding="utf-8").read(), ns)
    return ns["BLOCKS"]


def main(path, prefix):
    os.makedirs("fig", exist_ok=True)
    cells = load_cells(path)
    outputs, figs = [], [0]
    cur = []

    def display(obj):
        if isinstance(obj, Figure):
            figs[0] += 1
            p = f"fig/{prefix}-{figs[0]}.png"
            obj.savefig(p, dpi=160, bbox_inches="tight"); cur.append(("fig", p)); return
        latex = getattr(obj, "_repr_latex_", None)
        if callable(latex) and latex():
            cur.append(("latex", latex())); return
        if type(obj).__name__ == "Latex" and hasattr(obj, "data"):
            cur.append(("latex", obj.data)); return
        cur.append(("text", str(obj)))

    ns = {"display": display,
          "print": lambda *a, **k: cur.append(("text", " ".join(map(str, a))))}
    for i, src in enumerate(cells):
        cur.clear()
        try:
            tree = ast.parse(src)
            last = tree.body[-1] if tree.body else None
            if isinstance(last, ast.Expr):
                exec(compile(ast.Module(tree.body[:-1], []), f"<cell {i}>", "exec"), ns)
                val = eval(compile(ast.Expression(last.value), f"<cell {i}>", "eval"), ns)
                is_call = isinstance(last.value, ast.Call) and getattr(last.value.func, "id", "") in ("display", "print")
                if val is not None and not is_call:
                    display(val)
            elif tree.body:
                exec(compile(tree, f"<cell {i}>", "exec"), ns)
        except Exception as e:  # report and continue, as a notebook would show the error
            cur.append(("error", f"{type(e).__name__}: {e}"))
        outputs.append(list(cur))
    json.dump(outputs, open(f"{prefix}-outputs.json", "w"), indent=1)
    errors = sum(1 for o in outputs for k, _ in o if k == "error")
    for i, o in enumerate(outputs):
        sys.__stdout__.write(f"[cell {i}] {o}\n")
    sys.__stdout__.write(f"{len(cells)} cells, {errors} errors\n")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
