#!/usr/bin/env bash
# Render diagrams, then build each unit PDF and a combined PDF with pandoc + XeLaTeX.
# Usage:  ./build.sh                    render diagrams; build every lesson-*.md / chapter-*.md / unit-*.md and a combined PDF
#         ./build.sh lesson-02-foo.md   render diagrams; build one unit
#         ./build.sh --diagrams         only render diagrams
# Diagrams: diagrams/<name>.mmd (Mermaid) and diagrams/<name>.dot (Graphviz) -> fig/<name>.png.
#           A diagram is re-rendered only when its source is newer than its PNG.
# Env:    TITLE="Course name (rewrite)" sets the combined PDF title (cover page).
#         VERSION=0.1 sets the version on the cover and in the file name; ORG sets the organisation on the cover.
#         DOCNAME sets the combined file's base name (default: this folder's name, "-" -> "_"); output is <DOCNAME>_<VERSION>.pdf.
#         OUT overrides the whole output file name.
#         MMDC_PUPPETEER_CONFIG=/path/puppeteer.json is passed to mmdc (e.g. {"args":["--no-sandbox"]} on WSL).
# Needs:  see scripts/check_tools.sh of the skill (pandoc >= 3, xelatex, tcolorbox, Latin Modern + DejaVu fonts,
#         graphviz, @mermaid-js/mermaid-cli), preamble.tex, boxes.lua, make_combined.py and toc.tex next to this script.
set -euo pipefail
cd "$(dirname "$0")"

render_diagrams() {
  [ -d diagrams ] || return 0
  mkdir -p fig
  shopt -s nullglob
  for src in diagrams/*.dot; do
    png="fig/$(basename "${src%.dot}").png"
    if [ ! -f "$png" ] || [ "$src" -nt "$png" ]; then
      dot -Tpng -Gdpi=200 "$src" -o "$png" && echo "rendered $png"
    fi
  done
  for src in diagrams/*.mmd; do
    png="fig/$(basename "${src%.mmd}").png"
    if [ ! -f "$png" ] || [ "$src" -nt "$png" ]; then
      MMDC_OPTS=(-i "$src" -o "$png" -b white -s 3 -q)
      [ -n "${MMDC_PUPPETEER_CONFIG:-}" ] && MMDC_OPTS+=(-p "$MMDC_PUPPETEER_CONFIG")
      mmdc "${MMDC_OPTS[@]}" && echo "rendered $png"
    fi
  done
  shopt -u nullglob
}

render_diagrams
[ "${1:-}" = "--diagrams" ] && exit 0

# fontfamily=fontspec avoids requiring lmodern.sty (missing on some TeX installs) and uses OpenType fonts instead.
OPTS=(--pdf-engine=xelatex -V geometry:margin=2.3cm -V fontsize=11pt -V colorlinks=true
      -V linkcolor=blue -V urlcolor=blue --highlight-style=tango
      -V fontfamily=fontspec -V mainfont="Latin Modern Roman" -V monofont="DejaVu Sans Mono"
      -V monofontoptions=Scale=0.85 -V mathfont="Latin Modern Math"
      -H preamble.tex --lua-filter=boxes.lua)
if [ $# -gt 0 ]; then
  units=("$@")
else
  mapfile -t units < <(ls lesson-*.md chapter-*.md unit-*.md 2>/dev/null | sort)
fi
for f in "${units[@]}"; do
  pandoc "$f" "${OPTS[@]}" -o "${f%.md}.pdf" && echo "built ${f%.md}.pdf"
done
if [ $# -eq 0 ] && [ ${#units[@]} -gt 1 ]; then
  # Combined PDF: cover (title, version, date, organisation), contents with units as top-level entries,
  # each unit on a new page with its own title and subtitle (see make_combined.py, toc.tex).
  VERSION="${VERSION:-0.1}"
  DOCNAME="${DOCNAME:-$(basename "$PWD" | tr '-' '_')}"
  OUT="${OUT:-${DOCNAME}_${VERSION}.pdf}"
  TITLE="${TITLE:-Study notes}" VERSION="$VERSION" python3 make_combined.py "${units[@]}" > combined.md
  pandoc combined.md "${OPTS[@]}" -H toc.tex --toc --toc-depth=2 -o "$OUT" && echo "built $OUT"
fi
