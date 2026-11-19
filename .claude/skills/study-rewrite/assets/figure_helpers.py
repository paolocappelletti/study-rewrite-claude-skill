"""Shared helpers for study-rewrite figures.

Structural pictures (sequence diagrams, state machines, trees, DAGs, architecture) are NOT drawn here:
write them as diagrams/<name>.mmd (Mermaid) or diagrams/<name>.dot (Graphviz) and let build.sh render them.
Use matplotlib (this file) only for data: distributions, measurements over time, parameter sweeps, comparisons.

Usage in make_figures_<unit>.py:
    from figure_helpers import *
    fig, ax = plt.subplots(figsize=(6, 3.5))
    bars(ax, ["PoW", "PoS"], [600, 12], unit="s", title="Target block time")
    out("block-times", prefix="l2")
Saves to fig/<prefix>-<name>.png at 200 dpi. Always inspect the result with the Read tool.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

plt.rcParams.update({"font.size": 11, "axes.spines.top": False, "axes.spines.right": False,
                     "axes.grid": True, "grid.alpha": .3})
# Colour-blind-friendly palette, shared with the diagram style guide; never encode meaning by colour alone.
BLUE, ORANGE, GREEN, RED, PURPLE, GREY = "#1f5fa8", "#d9822b", "#2a9d6f", "#c0392b", "#7d3c98", "#888888"
PALETTE = [BLUE, ORANGE, GREEN, RED, PURPLE, GREY]


def out(name, prefix="fig", dpi=200):
    """Save the current figure to fig/<prefix>-<name>.png and close it."""
    os.makedirs("fig", exist_ok=True)
    plt.savefig(f"fig/{prefix}-{name}.png", dpi=dpi, bbox_inches="tight")
    plt.close()


def bars(ax, labels, values, unit="", title="", colors=None, annotate=True):
    """Labelled bar chart with the value written on each bar (the text's numbers, visible in the figure)."""
    b = ax.bar(labels, values, color=colors or PALETTE[:len(values)])
    if annotate:
        ax.bar_label(b, labels=[f"{v:g}{(' ' + unit) if unit else ''}" for v in values], padding=2)
    ax.set_title(title)
    return b


def timeline(ax, events, title=""):
    """Horizontal timeline. events: list of (x, label); x can be a year, a block height, or a time in seconds."""
    xs = [x for x, _ in events]
    ax.hlines(0, min(xs), max(xs), color=GREY, lw=1)
    for i, (x, label) in enumerate(events):
        y = .6 if i % 2 == 0 else -.6
        ax.plot([x, x], [0, y * .8], color=GREY, lw=.8)
        ax.scatter([x], [0], color=BLUE, zorder=3)
        ax.text(x, y, label, ha="center", va="center", fontsize=9)
    ax.set_ylim(-1, 1); ax.set_yticks([]); ax.spines["left"].set_visible(False); ax.grid(False)
    ax.set_title(title)


def mark(ax, x, y, label, color=RED):
    """Mark the running example's point on a curve, with its value."""
    ax.scatter([x], [y], color=color, zorder=3)
    ax.annotate(label, (x, y), textcoords="offset points", xytext=(6, 6), color=color)


def contact_sheet(paths, out_path, width=900):
    """Stack images vertically into one PNG for quick visual inspection with the Read tool."""
    from PIL import Image
    ims = [Image.open(p) for p in paths]
    ims = [im.resize((width, int(im.height * width / im.width))) for im in ims]
    sheet = Image.new("RGB", (width, sum(i.height for i in ims)), "white"); y = 0
    for im in ims:
        sheet.paste(im, (0, y)); y += im.height
    sheet.save(out_path)
