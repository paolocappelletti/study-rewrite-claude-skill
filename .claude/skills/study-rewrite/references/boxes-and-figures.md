# Boxes, diagrams and figures

## Box types

Boxes are pandoc fenced divs, rendered as coloured `tcolorbox` environments by `assets/boxes.lua` + `assets/preamble.tex`:

```markdown
::: {.walkthrough title="one round with a silent leader"}
**Step 1.** ...
:::

::: example
...
:::
```

| class | label | colour | use for |
|---|---|---|---|
| `refresher` | Refresher | blue | prerequisite concept (a primitive, a data structure, a complexity notion, a bit of math) recalled exactly where first needed; include a diagram if structural |
| `example` | Example | teal | concrete values right after a new definition, data structure, message format or API; tables of cases |
| `walkthrough` | Walkthrough | brown | every mechanism the chain relies on, traced as Step 1/2/3 on the running scenario, with the state after each step; ends with **Result.** |
| `why` | Why? | orange | the idea behind a design choice, in words, when a trace alone hides the intuition |
| `keyidea` | Key idea | violet | the 1–2 conceptual turning points of the unit (e.g. "safety comes from quorum overlap, not from trusting anyone") |
| `practice` | In practice | olive | real deployments, real parameter sizes, client implementations, operational trade-offs, honest caveats about where the textbook model differs from reality |
| `incode` | In code | cyan | a short runnable snippet (TypeScript by default; Go, Java or Python when the ecosystem uses them) that makes the mechanism concrete; its output shown and checked |
| `wrong` | What can go wrong | red | attacks, failure modes and real incidents linked to the mechanism; what the mechanism prevents and what it doesn't |
| `history` | History | magenta | who designed/discovered/broke what, when; 2–5 sentences; web-checked |
| `study` | What this study adds | cyan | in a proposal or analysis, the points the material itself contributes (corrections to earlier work, new findings, measurements), kept apart from what sources already say |
| `deeper` | Optional, going deeper | grey | material off the main chain, formal security arguments, contested claims with both sides cited, generalizations deferred to later units |

**Title rules (they go straight into LaTeX):** plain words only, no `_ ^ & % # $ \ { } ~`. Commas are fine (the preamble wraps titles in braces). Use "the reentrancy attack on The DAO", not "DAO::withdraw()".

**Box hygiene:**
- One idea per box. A walkthrough that needs a sub-mechanism gets a refresher before it instead.
- Boxes contain code, tables and diagrams too, not just prose.
- The main text must still read as a continuous story if the reader skips grey boxes, but not if they skip walkthrough or example boxes.

## Code in the text

- Short (≤ 25 lines), runnable, and run: every snippet's output shown in the text is produced by actually running it, and checked in `verify_<unit>.py` when it is a value the text relies on.
- TypeScript for illustrations (hashing with `node:crypto`, toy protocols, simulations), run with `node file.ts` (Node strips the types natively; use only erasable syntax: no `enum`, `namespace` or parameter properties). Prefer the standard library; when a package is needed (e.g. `viem`, `@noble/hashes`), pin its version in a scratch `package.json`.
- Go, Java or Python when the material or its ecosystem uses them (a go-ethereum or Cosmos SDK excerpt, a Besu/Teku class, a Python reference implementation).
- Rust, Solidity or C++ when the material is written in them (the reader knows them a bit); briefly explain non-obvious constructs where they matter to the mechanism (e.g. lifetimes or `unsafe` in Rust, `delegatecall` or storage layout in Solidity). Pseudocode only when the language would distract, and then say so.
- Comment the line that matters, not every line.

## Diagrams and figures: which tool

| what to draw | tool | source file |
|---|---|---|
| message flows between parties (protocol rounds, RPC calls, handshakes) | Mermaid `sequenceDiagram` | `diagrams/<unit>-<name>.mmd` |
| state machines (node states, tx lifecycle, channel states) | Mermaid `stateDiagram-v2` | `diagrams/<unit>-<name>.mmd` |
| simple flows and decision logic | Mermaid `flowchart` | `diagrams/<unit>-<name>.mmd` |
| trees and DAGs (Merkle trees, Patricia tries, block trees and forks, dependency graphs) | Graphviz `dot` | `diagrams/<unit>-<name>.dot` |
| architecture / component views, data layouts (block header fields, a tx's bytes) | Graphviz `dot` (`record`/HTML-like labels, `rankdir=LR`) | `diagrams/<unit>-<name>.dot` |
| data: distributions, measurements over time, parameter sweeps, bar comparisons, timelines | matplotlib via `make_figures_<unit>.py` + `figure_helpers.py` | `fig/<unit>-<name>.png` |

`build.sh` renders `diagrams/*.mmd` and `diagrams/*.dot` to `fig/<name>.png` (only when the source changed); `./build.sh --diagrams` renders without building PDFs. Embed every picture with a caption that says what to look at:

```markdown
![Round 1 with D as a silent leader: A, B, C time out after 2 s and move to view 2, where A leads.](fig/l3-silent-leader.png){width=80%}
```

Figures are pinned in place by the preamble (`\floatplacement{figure}{H}`), so no figure drifts away from its text or strands on an empty page.

### Diagram types that work

| idea | diagram |
|---|---|
| an incident or a need | sequence diagram of the failing (naive) run, with the faulty step highlighted (Mermaid `rect` / `Note over`) |
| a surprising fact or a main feature | before/after comparison: the naive approach vs the real system, with the headline number on each (Graphviz panels or a matplotlib bar chart) |
| a protocol round | sequence diagram, one lifeline per node of the running scenario, message labels with real values |
| a fork / chain split | Graphviz block tree, canonical branch bold, orphaned branch dashed, heights labelled |
| a Merkle proof | Graphviz tree, the leaf and the proof's sibling hashes coloured, path to the root bold |
| a tx / block lifecycle | Mermaid state diagram with the transition triggers as labels |
| a design evolution | side-by-side panels (one diagram per design), or a table |
| an attack | sequence diagram with attacker lifeline, plus a "what the victim sees" note |
| a data format | Graphviz record node with field names and byte sizes |
| a performance claim | matplotlib chart with the running scenario's point marked, and the regime where the claim holds shaded |
| history of a protocol | matplotlib timeline (`figure_helpers.timeline`) with dates/block heights |

### Style and figure checklist

- Same palette everywhere: in Graphviz/Mermaid use the hex colours from `figure_helpers.py` (`#1f5fa8` blue, `#d9822b` orange, `#2a9d6f` green, `#c0392b` red for faulty/attacker, `#7d3c98` purple, `#888888` grey). Never encode meaning by colour alone: add a label, a dashed line, or a shape.
- The running scenario's names and values appear in labels (A, B, C, D; `0x3f2a…`; height 100).
- Inspect every rendered PNG with the Read tool (contact sheet via `figure_helpers.contact_sheet`) before using it: overlapping labels, text cut off, unreadably small fonts on wide sequence diagrams (split them), wrong arrow directions.
- Keep diagrams small: ≤ 6 lifelines in a sequence diagram, ≤ 15 nodes in a tree. Split into stages rather than one giant picture.
- **Mermaid sequence diagrams**: start every `.mmd` with this line, so each participant appears once, at the top (Mermaid repeats the boxes at the bottom by default, which the user dislikes), and labels fit inside their boxes (the default font is measured wrongly by the headless renderer, so text spills out):
  ```
  %%{init: {"fontFamily": "Arial, Helvetica, sans-serif", "sequence": {"mirrorActors": false}}}%%
  ```
- **Wide diagrams**: when a left-to-right Graphviz layout makes the text too small at page width, switch to top-down (`rankdir=TB`).

### Tables

- Column widths follow the dashes in the separator line once any row is long: `|--|----------|-------|` gives the first column about 10% of the width. Use it to keep a short first column narrow.
- More space between rows: wrap the table in raw LaTeX and reset after it (blank lines around the table are required, or pandoc stops reading it as a table):
  ````markdown
  ```{=latex}
  \renewcommand{\arraystretch}{1.5}
  ```

  | a | b |
  |---|---|
  | ... | ... |

  ```{=latex}
  \renewcommand{\arraystretch}{1.0}
  ```
  ````
  If the extra space pushes a few lines onto a new page, a smaller value (e.g. 1.35) usually avoids it; say so to the user.
