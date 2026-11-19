# study-rewrite

A [Claude Code](https://claude.com/claude-code) skill that turns a study topic into a self-contained study text, delivered as a PDF.

You write a short request file naming a topic in computer science, distributed systems, blockchain or applied cryptography. Sources, goal and scope are optional. Claude then plans and writes the material one unit at a time:

- one concrete opening for the whole document, then a chain of questions where each section answers one and raises the next;
- every mechanism traced step by step on a single running scenario;
- just-in-time refreshers for prerequisites;
- many diagrams (Mermaid, Graphviz, matplotlib);
- coloured boxes: walkthrough, example, *What can go wrong*, *In practice*, *In code*, history, ...;
- runnable code snippets whose output is real, plus a verify script that checks every computed value;
- facts about real systems checked against primary sources.

Each unit is a Markdown file built to PDF with pandoc and XeLaTeX. A combined PDF of all units comes with a cover and a table of contents.

## Install

Copy the skill folder into a project, or into your user-level skills folder to use it everywhere:

```bash
cp -r .claude/skills/study-rewrite ~/.claude/skills/        # all projects
# or
cp -r .claude/skills/study-rewrite <your-project>/.claude/skills/
```

### Requirements

pandoc ≥ 3, XeLaTeX (with `tcolorbox`, `fvextra`, `booktabs`, `float`), the Latin Modern and DejaVu fonts, Graphviz, Mermaid CLI (`mmdc`), Node ≥ 22.18, Python 3 with numpy, matplotlib and Pillow, and `pdftoppm` (poppler-utils). Go, Java and Rust are optional.

You don't have to check these yourself. On every run the skill starts with `scripts/check_tools.sh`. If something is missing, Claude shows you the install commands (Debian/Ubuntu/WSL) and waits. You can also run the check directly:

```bash
bash .claude/skills/study-rewrite/scripts/check_tools.sh
```

## Usage

1. Create a folder for the material and copy the request template into it:

   ```bash
   mkdir -p studies/tendermint
   cp .claude/skills/study-rewrite/assets/request-template.md studies/tendermint/request.md
   ```

   With a user-level install, the template is at `~/.claude/skills/study-rewrite/assets/request-template.md`.

   > **Tip:** not sure how to start? Type `/study-rewrite` with no argument: Claude explains the usage and offers to copy the template into a new folder for you.

2. Edit `request.md`. Only **Topic** is required. **Sources**, **Goal**, **Scope**, **Already know** and **Overrides** are optional, and free text works too.

3. In Claude Code, run:

   ```
   /study-rewrite studies/tendermint/request.md
   ```

   Claude proposes sources (if you gave none) and a design spec. Once you agree, it builds a pilot unit and asks for your feedback.

4. Run the same command again to continue with the next unit. Edit the request file to change direction (e.g. "redo unit 2").

Everything is written next to the request file: `lesson-NN-*.md` and its PDF, `diagrams/`, `fig/`, the figure and verify scripts, and `build.sh`. To rebuild by hand:

```bash
cd studies/tendermint
./build.sh lesson-01-foo.md                               # one unit
TITLE="Tendermint" VERSION=0.2 ORG="My Org" ./build.sh    # all units + combined PDF
```

`ORG` is optional. When it is unset, the cover has no organisation line.

## Customising the reader profile

> [!IMPORTANT]
> The skill writes for one specific reader. **If you are not that reader, change the profile first**, or the depth, refreshers and code languages will be off for you.

The profile lives in two places:

| File | What to change |
|---|---|
| [`.claude/skills/study-rewrite/SKILL.md`](.claude/skills/study-rewrite/SKILL.md), the paragraph starting **"Who the reader is."** (in *Input: the request file*) | Background, field of expertise, languages known, what the reader already knows and doesn't (e.g. "knows the basic concepts of zero-knowledge proofs, but not the math"), and the goal of studying. |
| [`.claude/skills/study-rewrite/references/defaults.md`](.claude/skills/study-rewrite/references/defaults.md), the row **`code language`** | Which language the examples use by default (TypeScript) and which others to use when the material calls for them. Keep this in line with the languages in the profile. |

`references/defaults.md` also holds the other settled preferences: register, boxes, diagrams, output layout, language and so on. Claude applies them without asking, so edit any row that doesn't suit you. For a change that applies to one material only, use the **Overrides** section of its request file.

## Layout

```
.claude/skills/study-rewrite/
├── SKILL.md                  # the skill: rules, reader profile, workflow
├── references/               # narrative design, boxes and figures, review checklist, source licensing, defaults
├── assets/                   # request template, build.sh, LaTeX preamble, box filter, figure and verify helpers
└── scripts/                  # tool check, headless notebook runner
```

## License and credits

[MIT](LICENSE)

Based on work by: [@95DDB](https://github.com/95DDB) <br/>
Refined and improved by: [@paolocappelletti](https://github.com/paolocappelletti) <br/>
