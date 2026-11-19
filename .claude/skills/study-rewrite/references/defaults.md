# Settled defaults (do not re-ask)

These were decided explicitly by the user. Apply them unless the user says otherwise for a specific material.

| decision | default | how it was decided |
|---|---|---|
| subject area | computer science, distributed systems, blockchain, applied cryptography; math only where the mechanism needs it | user adapted the skill from a math/physics version |
| scope of depth | integrated: deepen inline wherever useful; off-chain depth in optional boxes | asked; user picked "integrated, no limit" |
| output format | Markdown + LaTeX per unit → PDF via pandoc/XeLaTeX with coloured boxes; combined PDF for the whole material | asked; user kept the PDF pipeline (Claude Docs was too limited for inline math) |
| diagrams | Mermaid for sequence/state/flow diagrams, Graphviz for trees/DAGs/architecture, matplotlib only for data charts | asked; user picked "both" |
| tool check | run `scripts/check_tools.sh` before building; if something is missing, show the install commands and wait | requested |
| invocation | explicit only: `/study-rewrite <path/to/request.md>`; the request file holds topic, sources, goal, scope, overrides | requested |
| output location | the folder containing the request file (overridable in the request) | asked; user picked "next to the request" |
| layout | one `.md` per unit (lesson/chapter/section of a paper or spec) | asked |
| refreshers | inline, exactly where first needed, flowing naturally | asked |
| exercises | avoid | asked |
| code language | TypeScript for illustrations (run natively with `node file.ts`, Node >= 22.18); Go, Java or Python when the material or its ecosystem uses them (e.g. go-ethereum, Cosmos SDK, ethers/viem, Besu/Teku); Rust, Solidity or C++ when the material is written in it, explaining only non-obvious constructs | reader knows Java, TypeScript, Go and Python, and a bit of Rust, Solidity and C++ |
| source code cells | keep verbatim when the licence allows, with attribution; run them and report version differences | user: "relevant and useful, keep them intact" |
| technical vs real-world language | field's technical names first in main text; real-world meaning in In practice boxes | asked |
| security perspective | every main mechanism gets a What can go wrong box (attacks, failure modes, real incidents) | proposed, accepted |
| history | short history thread in boxes | asked |
| real-world anchor | concrete opener chosen per material: a surprising fact, a main feature, a main need, or an incident (not incident by default); one realistic running scenario throughout | requested; user: incidents not mandatory |
| course arc | yes: build every unit towards the material's final destination | asked |
| narrative spine style | one concrete opening for the whole document (first unit only) + "smallest change that works" chain, broken designs shown failing first | asked (A+B hybrid) |
| density / register | **not fixed: ask per material, and per unit when units differ in nature** (see "Still ask"). Two registers seen so far: *technical* (rules 1–2 apply: concrete values, short code, minimal math, every assumption explicit) and *plain-language* (no math, no code, no hex or numeric worked examples; why and how in high-level words for a reader with very basic crypto and math). Even in technical units, prefer simplifying over adding detail: the user trimmed code boxes, examples and boxes from every unit | earlier "expand rather than compress" was reversed on a past five-unit material (Units 1–2 technical but trimmed, Units 3–5 plain-language) |
| section numbering | headings carry the unit number: `# 2.1 Title`, `## 2.3.1 Title`; cross-references use the same numbers ("Section 2.6") | requested, so the combined contents list reads well |
| unit titles | front matter `title: "Unit N. <title>"` and `subtitle: "<material subtitle>"`; no date line in the unit | requested |
| section openings | the question as a plain sentence, no "The question:" label | user removed the label everywhere |
| recaps | no table or list that repeats what the prose already says | user removed the units table |
| combined PDF | cover: title, "Version <x>", generation date, organisation (env ORG; omitted when unset); file named `<name>_<version>.pdf` (env DOCNAME, VERSION); each unit on a new page with its title and subtitle; contents with units as top-level entries | requested |
| Mermaid sequence diagrams | participants shown once, at the top (`mirrorActors: false`) | requested |
| language | English | user writes in English |
| advanced tools (formal models, proofs of security) | introduce when the chain needs them, in optional boxes by default | delegated |

## Still ask (per material)

- Which unit to start with, and whether to pilot first (default: pilot the first unit).
- The register of each unit: technical or plain-language (see the table above). Ask when the material mixes kinds (e.g. a technical description, then a threat analysis, a survey and a proposal), and propose a register per unit.
- For the combined PDF: its title, the file's base name and the version (default 0.1), when the request does not give them.
- The document opening (fact, feature, need or incident; asked once, for the first unit), when more than one candidate is plausible: present candidates with a criteria table.
- Whether a thread scenario (one system or network across all units) should be used, if the material allows it.
- Which version of a protocol/spec/client to follow when versions differ materially (e.g. pre/post-Merge Ethereum, Bitcoin before/after SegWit).
- Which sources to follow, when the request gives only a topic: propose 3–5 with pros/cons.
- Anything about the material the request and the sources do not settle (e.g. which version of a paper, which chapters).
