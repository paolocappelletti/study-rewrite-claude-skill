---
name: study-rewrite
description: Turn a study request (a .md file naming a computer science, distributed systems, blockchain or applied cryptography topic, optionally with sources, goal and scope) into a self-contained study text written the way this user learns best — one concrete opening for the whole document, every mechanism traced step by step on one running scenario, just-in-time refreshers, many diagrams, coloured boxes including "What can go wrong" and runnable code, all claims checked, built as Markdown to PDF. Run explicitly as /study-rewrite <path/to/request.md>.
argument-hint: <path/to/request.md>
disable-model-invocation: true
---

# Study rewrite

This skill captures how this user studies effectively.
Follow the rules as defaults; the request file and the user's latest instruction always win.

## Input: the request file

This skill runs only when invoked explicitly: `/study-rewrite <path/to/request.md>`.

Request file: `$ARGUMENTS`

- If no path was given, or the file does not exist, **stop**: explain the usage in two lines and point to `assets/request-template.md` (offer to copy it into a new folder for the user). Do nothing else.
- Read the whole request file first. It is the user's own instruction for this material: **Topic** is required; **Sources**, **Goal**, **Scope**, **Already know** and **Overrides** are optional; free text is also valid. Anything it says overrides `references/defaults.md`. If the topic is missing or ambiguous, ask before doing anything else.
- **Output folder** = the folder containing the request file, unless the file names another one under Overrides.
- **Running again** with the same request file continues the material: look at the units already in the output folder and propose the next one, unless the request file (possibly edited since) says otherwise, e.g. "redo unit 2".

**Who the reader is.** A senior software engineer with a computer engineering degree and deep practical expertise (distributed systems, blockchain); knows Java, TypeScript, Go and Python, and a bit of Rust, Solidity and C++. Has notions of applied cryptography and blockchain consensus algorithms. Knows the basic concepts of zero-knowledge proofs, but is not an expert in the math behind them. The goal is **understanding how things work and why they are designed that way**, not research-level formality. The reader knows many ideas exist but has forgotten details, so nothing may be assumed silently.

## The rules (the core)

1. **No over-formalization.** Plain engineering language. No Definition/Theorem/Lemma scaffolding, no abstract generality for its own sake. Math only where the mechanism truly needs it (hash and signature properties, quorum sizes, probabilities, complexity), explained by intuition plus a tiny instance. Mechanisms that matter get a *walkthrough box*.
2. **Every new thing gets a concrete instance immediately.** Each definition, data structure, message format, API or mechanism is followed at once by a concrete example: real-looking values, a trace on a few nodes, a short snippet and its output. Families of cases get a small table.
3. **Explicit assumptions.** State what is assumed before every mechanism: threat model, network model, trust assumptions, what is simplified versus the real system.
4. **Just-in-time refreshers.** Prerequisite concepts are recalled inline, exactly where the argument first needs them, after a sentence saying *why* they are needed now. Never anticipate a concept before its need, never drop one in out of the blue.
5. **Built-up narrative, not a syllabus.** The text is one chain of reasoning towards a stated destination. Each section opens with the question it answers and closes with the question it leaves open. Broken designs are shown failing before they are fixed. Results are reused later; no dead ends.
6. **Anchor in the real world.** Open the **whole document once** (at the start of the first unit, never again in later units) with something concrete that makes the reader want the material's central idea. Pick the kind that fits the material: a surprising fact, a main feature of a real system, a main need or problem, or an incident (see `references/narrative-design.md` § 2). Incidents are one option, not the default. Carry one realistic running scenario (a few nodes, one transaction, one block) through the whole material. Technical names first in the main text; real-world meaning in "In practice" boxes; attacks and failures in "What can go wrong" boxes; a short history thread in "History" boxes.
7. **Pictures everywhere, including inside boxes.** A diagram for every flow, state machine, data structure and architecture: Mermaid for sequence/state/flow diagrams, Graphviz for trees/DAGs/layouts, matplotlib only for data. Every diagram comes from a source file whose names and values match the text.
8. **Verified and honest.** Every computed value and snippet output is checked by a script; every fact about real systems (parameters, dates, incidents, behaviour) is web-checked against a primary source (spec, EIP/BIP, source code, official postmortem); version-sensitive facts say which version they apply to; contested claims are flagged with both sides cited; rendered pages are visually inspected.

## Workflow

The user prefers planning before building, real alternatives with pros and cons, honest pushback, and proof that things work. Follow these phases; do not skip the tool check, the spec or the verification.

### Phase 0 — Intake (always)

1. **Check the tools.** Run `bash <skill-dir>/scripts/check_tools.sh`. It checks pandoc, XeLaTeX and the LaTeX packages, fonts, Graphviz, Mermaid CLI, the Python libraries and pdftoppm, and runs a test render of each. If it exits non-zero, **stop**: show the user the missing items and the exact install commands it printed, explain briefly what each is for, and ask them to run the commands (suggest the `! <command>` prefix so the output lands in the session, or a separate terminal for `sudo`). Do not install anything yourself. Re-run the check after they confirm. Node is required (TypeScript is the default example language, and Mermaid needs it); the other language toolchains (Go, Java, Rust) are optional: if the material has snippets in a language whose toolchain is missing, say so and offer to show the code without running it.
2. Get the material.
   - **No sources in the request (topic only):** search for primary sources (spec, original paper, official docs, reference implementation, well-regarded courses), then propose 3–5 with a pros/cons table (authority, depth, up to date, fit with the Goal) and ask which to follow, or which mix. If the topic is broad (e.g. "ZK rollups"), also ask about scope. Do not design anything before the user picks.
   - **Sources given:** for a URL, fetch it; for a local file, read it; for a course, find all units/lessons and their raw sources (notebooks, markdown, repos) via search + fetch; for a paper or spec, fetch the PDF/arXiv page/EIP/BIP. Read the whole unit before designing it.
3. **Check the license and decide how source material may be used** — read `references/source-handling.md`. In short: always write original explanations; never reproduce source prose; reproduce code verbatim only if its license permits, with attribution.
4. Check the output folder (next to the request file) for prior units of the same material, to continue the same arc, running scenario, notation and file layout.

### Phase 1 — Design spec (present to the user before writing)

Produce a short spec, in chat, containing:

- **Destination**: the comprehensive result the whole material builds towards, shaped by the request's Goal, and this unit's role in it (`references/narrative-design.md`).
- **Opening** (first unit only): the concrete fact, feature, need or incident that motivates the whole material. For later units, the starting point is the question the previous unit left open. Offer 2–3 candidates, of different kinds when that makes sense, with a pros/cons table when the choice is not obvious (criteria: how well it motivates the mechanism, real-world significance, background needed, link to the final destination).
- **The chain**: numbered steps, each "question → answer → new question".
- **Running scenario**: one concrete, realistic instance with small readable values, used throughout.
- **Register**: technical or plain-language, per unit if they differ (see `references/defaults.md`). In a plain-language unit rules 1–2 and the code/example boxes do not apply; the why and the how are told in high-level words.
- **Assumptions**: threat and network model, protocol/spec version followed.
- **Refresher map**: which prerequisites, and the exact point where each is first needed.
- **Diagram list** (with tool per diagram) and **box plan**.
- **Verification plan**: what the check script will assert, which snippets will be run, which facts will be web-checked.

Ask only what is genuinely open (use the AskUserQuestion tool, ≤3 questions, 2–4 options each). Settled defaults for this user are listed in `references/defaults.md` — do not re-ask those.

### Phase 2 — Build one unit (pilot first for new material)

For new material, build **one unit as a pilot** and get feedback before doing the rest.

1. Create the output folder and copy the assets into it: `assets/preamble.tex`, `assets/boxes.lua`, `assets/build.sh`, `assets/make_combined.py`, `assets/toc.tex`, `assets/figure_helpers.py`, `assets/verify_template.py`; `scripts/run_code_cells.py` if the source has notebook/code cells to run.
2. Write the diagrams first: `diagrams/<unit>-<name>.mmd` / `.dot`, and `make_figures_<unit>.py` (importing `figure_helpers`) only for data charts. Render with `./build.sh --diagrams` and `python3 make_figures_<unit>.py`, then **look at every image** with the Read tool (contact sheet first). Fix overlapping labels, cut-off text, tiny fonts on wide diagrams, wrong arrow directions.
3. Write the unit as `<unit>.md` following `references/narrative-design.md` (structure) and `references/boxes-and-figures.md` (boxes, code, diagrams).
4. Run every code snippet that appears in the text and paste the real output. TypeScript snippets run with `node file.ts` in the scratchpad directory; Go, Java or Rust snippets in a scratch project there.
5. Write `verify_<unit>.py` from the template: one check per computed value, table value and snippet output the text relies on, plus the `FACTS` list of web-checked claims with sources. It must print a PASSED line.
6. If the source has notebook/code cells: run them headless with `scripts/run_code_cells.py`, capture outputs, and report version differences.
7. Build with `./build.sh <unit>.md`, then render pages to PNG (`pdftoppm -r 50`) and inspect a contact sheet plus the densest pages at higher resolution. Check: no overflowing code lines or tables, no stranded figures, boxes render, diagrams readable.

### Phase 3 — Self-review before presenting

Run the full checklist in `references/review-checklist.md` against the draft and fix every hit. In the original iteration this step caught 22 violations in a document that looked finished. Then present the result: the PDF path, a short summary of what the unit does, what was verified, and honest caveats (contested claims, version-sensitive facts, simplifications, length).

### Phase 4 — Iterate and continue

Expect feedback in the categories the rules cover (too formal, too concise, disconnected, hand-wavy mechanism, unjustified example, missing diagrams). Fix by section, rerun verification, rebuild, re-inspect. For the following units, reuse the same arc, running scenario, notation table, file layout and build, and start each unit directly from the question the previous one left open (no new opening; the document's opening is only re-read in the last unit).

After the user approves the first unit of a new material, offer to extract 4–5 annotated excerpts from it (the document opening, a walkthrough, a What can go wrong box, a refresher, the closing picture) into `references/example-unit-excerpts.md`, as the style reference for future units. Until that file exists, calibrate on the rules and the references.

## Output format (defaults)

- One Markdown file per unit (`lesson-NN-<slug>.md`) with front matter `title: "Unit N. <title>"` and `subtitle: "<material subtitle>"` (no date), headings numbered with the unit number (`# 2.1 ...`, `## 2.3.1 ...`). Built to PDF via pandoc + XeLaTeX with the bundled `build.sh`. Diagram sources in `diagrams/`, rendered images in `fig/`, pinned in place (no floating).
- Run with no arguments, `build.sh` also builds the combined PDF `<DOCNAME>_<VERSION>.pdf`: a cover with title, version, date and organisation, a contents list with units as top-level entries, and each unit on a new page with its own title and subtitle. Set `TITLE`, `VERSION` (default 0.1), `DOCNAME` (default: folder name) and `ORG` (optional; the organisation line is left off the cover when unset) as environment variables.
- While the user is iterating on one unit, rebuild only that unit (`./build.sh <unit>.md`) unless they ask for the combined PDF.
- Files go to the folder containing the request file, unless the request names another location. Keep the `.md`, the `.pdf`, the diagram sources, the figure script and the verify script.
- English unless the user asks otherwise.

## Adapting to the kind of material

- **A research paper or whitepaper**: the destination is the paper's main result; the opening is usually the need: the problem the paper solves and why the obvious approach fails; the chain reconstructs the argument in the order that makes it inevitable (not necessarily the paper's order); a final section states the assumptions, limitations, known attacks and follow-up work. See `references/narrative-design.md` § "Papers, specs and protocol docs".
- **A spec, EIP/BIP or RFC**: reorder from implementer order (formats first) to learner order (problem first); the running scenario is one concrete message/transaction/block encoded and processed end to end; state the version and fork.
- **Documentation of a library or system**: the opening is usually a main feature or a task that is hard without it; "In code" boxes carry real API usage, run against a pinned version.
- **Math-heavy topics** (ZK proofs, elliptic curves, erasure codes): keep the math minimal and concrete (tiny fields, small numbers computed in the verify script), lean on refreshers, and put formal arguments in optional boxes.

## Bundled files

| file | what it is | when to read/use |
|---|---|---|
| `assets/request-template.md` | template for the request file the skill is invoked with | when no request file is given |
| `scripts/check_tools.sh` | preflight: checks and test-renders every required tool, prints install commands | Phase 0, always |
| `references/narrative-design.md` | how to design the spine, sections, running scenario, course arc; papers and specs | Phase 1 |
| `references/boxes-and-figures.md` | box types, code in the text, which diagram tool for what, figure conventions | Phase 2 |
| `references/review-checklist.md` | the pre-delivery checklist | Phase 3 |
| `references/source-handling.md` | licensing, attribution, what may be reproduced (incl. specs and open-source code) | Phase 0 |
| `references/defaults.md` | settled preferences: do not re-ask | Phase 1 |
| `assets/preamble.tex`, `assets/boxes.lua` | coloured box styles for pandoc → PDF | Phase 2 |
| `assets/build.sh` | renders `diagrams/*.mmd` / `*.dot`, builds per-unit PDF + combined PDF | Phase 2 |
| `assets/make_combined.py`, `assets/toc.tex` | combined PDF: cover, per-unit title pages, contents layout (called by `build.sh`) | Phase 2 |
| `assets/figure_helpers.py` | palette and helpers for data charts (bars, timeline, marking a point, contact sheet) | Phase 2 |
| `assets/verify_template.py` | check script template: computed values, tables, properties, `FACTS` list | Phase 2 |
| `scripts/run_code_cells.py` | runs a source's notebook/code cells headless and captures outputs | Phase 2, if the material has code cells |
