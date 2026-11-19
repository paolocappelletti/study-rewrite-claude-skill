# Source handling: licences, attribution, reproduction

The output of this skill is always an **original explanation** of the source material, never a copy or a lightly edited copy of it. That is both the legal requirement and the point of the exercise: the source's wording is exactly what the user found hard to learn from.

## Rules that always apply

1. **Never reproduce source prose.** Do not copy paragraphs, sentences, or distinctive phrasing from the course, book, or paper, and do not paraphrase it sentence by sentence with small substitutions. Read the source, close it, and write the explanation in your own words, in the order the narrative design requires.
2. **Structure and ideas are free to follow.** Topics, the order of a syllabus, standard definitions, standard algorithms and protocols, and standard notation are not owned by the source. Re-ordering them for the narrative is expected.
3. **Short quotes only when wording matters**, under 15 words, attributed, and at most one per source. Usually there is no need to quote at all.
4. **Figures are redrawn from scratch** with the figure script, never copied from the source. Do not reproduce a source's distinctive diagrams or artwork; draw what the idea needs.
5. **Examples and code are original.** Do not copy the source's worked examples or exercises; build new ones on the running scenario that show the same ideas.
6. **Song lyrics, poems, book passages, and similar works are never reproduced**, whatever the material is.

## Code from the source

- Check the licence first (search the repository README / LICENSE). Many course repos license **code** permissively (e.g. a docs repo with code under Apache 2.0 or MIT) and **text** separately (e.g. CC BY-SA 4.0).
- If the code licence permits redistribution (Apache 2.0, MIT, BSD, CC BY / BY-SA), code cells may be kept **verbatim** when the user wants them, with attribution to the original authors and the licence named. The commentary around the cells is always original.
- If the licence is unclear or restrictive, do not copy code: describe what it does and write original code that demonstrates the same idea.
- Code taken from an open-source project (a client, a library, a reference implementation) follows that project's licence: check it, keep excerpts short, link the file and commit, and name the licence. Prefer linking plus a short excerpt over pasting whole files.
- Always run code you include and report version differences.

## Specs, RFCs, EIPs and BIPs

- Explain them in original words like any other source. Quote a normative sentence (e.g. a MUST/SHOULD line) only when the exact wording is the point, under 15 words, with the section number.
- Field names, constants, opcode names and message formats are facts: reproduce them freely, citing the spec section.
- Many EIPs/BIPs are public domain or CC0 and RFCs have their own terms; state what applies in the provenance notice.

## The provenance notice

Every unit starts with a short blockquote stating:
- which material it follows (title, author, publisher), and that material's text licence;
- that the explanations, walkthroughs, diagrams and code examples are new;
- what (if anything) is reproduced verbatim, under which licence, with the copyright holder;
- if the source text licence is share-alike (CC BY-SA), that redistribution of the rewrite should keep the notice and the same licence (a conservative choice, since the structure follows the source).

Example (adapt per source):

> **Provenance.** This lesson follows the syllabus of *<Title>* (<Author>, <Publisher>), whose text is licensed <licence>. The explanations, walkthroughs, diagrams and code examples here are new; the code cells in Section N are reproduced verbatim from that course under the <code licence>, © <holder>. If you redistribute this document, keep this notice and license it <licence>.

## Papers

- Explain the paper in original words, following `narrative-design.md` § Papers.
- Restate the paper's results in your own (usually simpler, informal) words; reproduce an equation or algorithm listing only where it is the object being explained, and attribute it ("Algorithm 2 of the paper").
- Do not reproduce the paper's figures; redraw what the explanation needs.
- Cite the paper with a link at the top, and cite follow-ups/critiques found during fact-checking.

## Personal use vs sharing

The user studies for personal use. If they ask to share or publish a rewrite, remind them of the share-alike terms of the source (if any) and keep the provenance notice.
