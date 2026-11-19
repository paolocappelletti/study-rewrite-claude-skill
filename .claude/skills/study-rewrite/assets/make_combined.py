"""Build combined.md from the unit files, for the combined PDF (called by build.sh).

- Cover: the title (env TITLE), then one per line: "Version <VERSION>", the generation date, and ORG (only if set).
- Each unit starts on a new page with its own title and subtitle, exactly as in the unit's separate PDF,
  and appears in the table of contents as a top-level entry (toc.tex styles the levels below it).
Unit files need front matter with `title: "..."` and `subtitle: "..."` (double-quoted).

Usage: TITLE="..." VERSION=0.1 ORG="..." python3 make_combined.py lesson-01-*.md lesson-02-*.md ... > combined.md
"""
import datetime
import os
import re
import sys


def tex(s):
    return re.sub(r'([&%#_$])', r'\\\1', s).replace('`', '')


today = datetime.date.today()
cover_lines = [f"Version {os.environ.get('VERSION', '0.1')}", f"{today.day} {today:%B %Y}"]
if os.environ.get('ORG'):
    cover_lines.append(os.environ['ORG'])
out = ['---', f'title: "{os.environ.get("TITLE", "Study notes")}"', 'date: |'] + [f'  | {l}' for l in cover_lines] + ['---']
for f in sys.argv[1:]:
    text = open(f, encoding='utf-8').read()
    _, front, body = text.split('---', 2)
    meta = dict(re.findall(r'^(\w+):\s*"(.*)"\s*$', front, flags=re.M))
    title, subtitle = tex(meta.get('title', f)), tex(meta.get('subtitle', ''))
    out.append(f"""
```{{=latex}}
\\clearpage
\\begin{{center}}
\\vspace*{{1em}}
{{\\LARGE {title}\\par}}
\\vspace{{0.8em}}
{{\\large {subtitle}\\par}}
\\end{{center}}
\\vspace{{1.5em}}
\\addcontentsline{{toc}}{{part}}{{{title}}}
```
""")
    out.append(body.strip() + "\n")
print("\n".join(out))
