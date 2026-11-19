#!/usr/bin/env bash
# Preflight for the study-rewrite skill: are the tools needed to build a unit installed and working?
# Usage:  bash check_tools.sh            check presence + run quick test renders (pandoc/xelatex, dot, mmdc)
#         bash check_tools.sh --quick    presence and versions only, no test renders
# Exit status: 0 if every REQUIRED item is OK, 1 otherwise. OPTIONAL items only warn.
# Install hints target Debian/Ubuntu (incl. WSL). The skill must show the hints to the user, not run them.
set -uo pipefail

QUICK=0; [ "${1:-}" = "--quick" ] && QUICK=1
HERE="$(cd "$(dirname "$0")" && pwd)"
ASSETS="$HERE/../assets"
FAIL=0; APT=(); NPM=(); NOTES=()

ok()   { printf '  \033[32mOK\033[0m       %-22s %s\n' "$1" "$2"; }
miss() { printf '  \033[31mMISSING\033[0m  %-22s %s\n' "$1" "$2"; FAIL=1; }
warn() { printf '  \033[33mWARN\033[0m     %-22s %s\n' "$1" "$2"; }
add_apt() { for p in "$@"; do [[ " ${APT[*]-} " == *" $p "* ]] || APT+=("$p"); done; }

echo "== Required: PDF build =="
if command -v pandoc >/dev/null; then
  v=$(pandoc --version | head -1 | awk '{print $2}')
  if [ "${v%%.*}" -ge 3 ]; then ok pandoc "$v"; else miss pandoc "$v is too old (need >= 3)"; NOTES+=("pandoc >= 3: download the .deb from https://github.com/jgm/pandoc/releases"); fi
else miss pandoc "not found"; add_apt pandoc; fi

if command -v xelatex >/dev/null; then ok xelatex "$(xelatex --version | head -1 | cut -c1-50)"
else miss xelatex "not found"; add_apt texlive-xetex texlive-latex-extra; fi

if command -v kpsewhich >/dev/null; then
  for sty in tcolorbox fvextra booktabs float; do
    if [ -n "$(kpsewhich "$sty.sty")" ]; then ok "$sty.sty" "found"
    else miss "$sty.sty" "LaTeX package not found"; add_apt texlive-latex-extra; fi
  done
fi

for fam in "Latin Modern Roman" "Latin Modern Math" "DejaVu Sans Mono"; do
  if fc-list ":family=$fam" 2>/dev/null | grep -q .; then ok "font" "$fam"
  else miss "font" "$fam"
    case "$fam" in DejaVu*) add_apt fonts-dejavu-core ;; *) add_apt fonts-lmodern ;; esac
  fi
done

echo "== Required: TypeScript examples =="
if command -v node >/dev/null; then
  nv=$(node --version | tr -d v); maj=${nv%%.*}; min=$(echo "$nv" | cut -d. -f2)
  if [ "$maj" -ge 23 ] || { [ "$maj" -eq 22 ] && [ "$min" -ge 18 ]; }; then ok node "v$nv (runs .ts natively)"
  else miss node "v$nv is too old to run .ts natively (need >= 22.18)"; NOTES+=("Node >= 22.18: see https://nodejs.org or use nvm"); fi
else miss node "not found"; add_apt nodejs npm; fi

echo "== Required: diagrams and figures =="
if command -v dot >/dev/null; then ok "dot (Graphviz)" "$(dot -V 2>&1 | awk '{print $5}')"
else miss "dot (Graphviz)" "not found"; add_apt graphviz; fi

if command -v mmdc >/dev/null; then ok "mmdc (Mermaid)" "$(mmdc --version 2>/dev/null | head -1)"
else
  miss "mmdc (Mermaid)" "not found"
  if command -v npm >/dev/null; then NPM+=("@mermaid-js/mermaid-cli"); else add_apt nodejs npm; NPM+=("@mermaid-js/mermaid-cli"); fi
fi

for mod in numpy matplotlib PIL; do
  if python3 -c "import $mod" 2>/dev/null; then ok "python3: $mod" "$(python3 -c "import $mod; print($mod.__version__)")"
  else miss "python3: $mod" "not importable"
    case $mod in numpy) add_apt python3-numpy ;; matplotlib) add_apt python3-matplotlib ;; PIL) add_apt python3-pil ;; esac
  fi
done

if command -v pdftoppm >/dev/null; then ok pdftoppm "page rendering for visual inspection"
else miss pdftoppm "needed to render PDF pages to PNG for inspection"; add_apt poppler-utils; fi

echo "== Optional =="
# Toolchains only needed to run snippets in that language.
opt() { if command -v "$1" >/dev/null; then ok "$1" "$($1 $2 2>&1 | head -1 | cut -c1-50)"; else warn "$1" "only for $3 snippets ($4)"; fi; }
opt go    version   Go         "sudo apt install golang-go"
opt java  --version Java       "sudo apt install default-jdk"
opt cargo --version Rust       "https://rustup.rs"

if [ $QUICK -eq 0 ]; then
  echo "== Test renders =="
  T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
  if command -v node >/dev/null; then
    echo 'const n: number = 4; console.log((n - 1) / 3 | 0)' > "$T/t.ts"
    if [ "$(node "$T/t.ts" 2>/dev/null)" = "1" ]; then ok "run: typescript" "node ran a .ts file"
    else miss "run: typescript" "node could not run a .ts file natively"; fi
  fi
  if command -v dot >/dev/null; then
    if echo 'digraph{a->b}' | dot -Tpng -o "$T/g.png" 2>"$T/dot.err"; then ok "render: graphviz" "PNG produced"
    else miss "render: graphviz" "$(head -1 "$T/dot.err")"; fi
  fi
  if command -v mmdc >/dev/null; then
    printf 'sequenceDiagram\n  A->>B: hi\n' > "$T/s.mmd"
    if mmdc -i "$T/s.mmd" -o "$T/s.png" -q >"$T/mmdc.err" 2>&1 && [ -s "$T/s.png" ]; then ok "render: mermaid" "PNG produced"
    else
      miss "render: mermaid" "mmdc is installed but failed to render (headless Chromium)"
      NOTES+=("Mermaid render failed: $(grep -m1 -i 'error' "$T/mmdc.err" | cut -c1-160)")
      NOTES+=("On WSL/Ubuntu Chromium usually needs system libs: sudo apt install libnss3 libatk-bridge2.0-0t64 libgbm1 libasound2t64 libxkbcommon0 libgtk-3-0t64")
      NOTES+=("If it still fails (e.g. sandbox errors), create puppeteer.json with {\"args\":[\"--no-sandbox\"]} and export MMDC_PUPPETEER_CONFIG=/path/to/puppeteer.json (build.sh passes it to mmdc)")
    fi
  fi
  if command -v pandoc >/dev/null && command -v xelatex >/dev/null && [ -f "$ASSETS/preamble.tex" ]; then
    cp "$ASSETS/preamble.tex" "$ASSETS/boxes.lua" "$T/"
    printf '# Test\n\n::: {.walkthrough title="a box"}\nInline math $n \\geq 3f+1$ and `code`.\n:::\n' > "$T/t.md"
    if (cd "$T" && pandoc t.md --pdf-engine=xelatex -V fontfamily=fontspec -V mainfont="Latin Modern Roman" \
          -V monofont="DejaVu Sans Mono" -V mathfont="Latin Modern Math" -H preamble.tex --lua-filter=boxes.lua \
          -o t.pdf >pandoc.err 2>&1); then ok "render: pandoc+xelatex" "PDF with a coloured box produced"
    else miss "render: pandoc+xelatex" "$(grep -m1 -E '^!|rror' "$T/pandoc.err" | cut -c1-120)"; fi
  fi
fi

echo
if [ $FAIL -eq 0 ]; then echo "All required tools are available."; exit 0; fi
echo "Some required tools are missing or broken. To install (Debian/Ubuntu/WSL):"
[ ${#APT[@]} -gt 0 ] && echo "  sudo apt update && sudo apt install ${APT[*]}"
[ ${#NPM[@]} -gt 0 ] && echo "  npm install -g ${NPM[*]}     # add sudo if npm's global prefix is system-owned"
for n in "${NOTES[@]-}"; do [ -n "$n" ] && echo "  - $n"; done
echo "Then re-run: bash $0"
exit 1
