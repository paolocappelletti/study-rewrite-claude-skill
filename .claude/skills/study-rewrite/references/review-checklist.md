# Pre-delivery review checklist

Run this against the full draft before presenting it. Read the whole `.md` (with the Read tool, in chunks), log each hit with its location, fix, rebuild, re-verify. In the original iteration this pass caught 22 issues in a document that looked done.

## A. Register
- [ ] No unexplained jargon or acronyms: every term (BFT, MEV, SPV, RLP, VRF, ...) is expanded and illustrated on first use.
- [ ] No formal scaffolding (Definition/Theorem/Lemma labels, ∎); results are stated in plain words and shown with a walkthrough.
- [ ] Math only where the mechanism needs it, with a small concrete instance right after it.
- [ ] Every symbol, variable or field name appears in the notation table or is introduced with an example on first use.

## B. Mechanism over hand-waving
- [ ] Search the text for: "the protocol ensures", "guarantees", "securely", "magically", "simply", "it can be shown", "similarly", "clearly", "obviously", "under the hood", "takes care of". Each must be followed by the actual mechanism (who sends what, who checks what), or replaced by it.
- [ ] Every guarantee stated (safety, liveness, integrity, finality) is either walked through where it appears or points back to the section that walked through it.
- [ ] Every walkthrough has explicit steps with the state after each; no step hides two non-trivial moves.
- [ ] Every primitive used inside a walkthrough (hash properties, signature verification, Merkle proof, quorum overlap) has been explained earlier.

## C. Concrete instances
- [ ] Every definition / data structure / message format / API is followed by a concrete example with real-looking values.
- [ ] Every walkthrough runs on the running scenario and ends with "**Result.**".
- [ ] Families of cases (different n, different attacker power, different parameters) have a table.
- [ ] Code snippets are short, runnable, and their shown output is real.

## D. Assumptions
- [ ] Each mechanism starts with "**What we assume**": threat model (who can be malicious, how many), network model (synchronous / partially synchronous / asynchronous), trust assumptions (trusted setup, honest majority of stake/hash), what the adversary can and cannot do.
- [ ] Simplifications versus the real system are listed, with what the real system does instead.
- [ ] Claims that something is impossible or secure are preceded by a few concrete attempts at breaking it.

## E. Refreshers
- [ ] Each refresher is preceded by a sentence saying why it is needed now.
- [ ] No refresher appears before its first use, and no concept is used before its refresher.
- [ ] Refreshers include a diagram when the concept is structural.

## F. Narrative
- [ ] First unit: the destination and the document opening are stated at the start. Later units: no new opening; they start from the previous unit's open question (with at most one line on where they sit).
- [ ] Every section opens with its question as a plain sentence (no "The question:" label) and ends with what it leaves open.
- [ ] No recap table or list that repeats what nearby prose already says (e.g. a units table after the paragraph that already lists the units).
- [ ] Every concept enters because the previous step required it; broken designs are shown failing before they are fixed.
- [ ] No dead ends: each main-text result is reused later (otherwise move to an optional box).
- [ ] The unit's final picture re-explains its starting question and the running scenario; in the last unit, it also re-reads the document opening.
- [ ] The last section bridges to the next unit and plants a returning idea.
- [ ] Headings carry the unit number (`# 2.1 ...`, `## 2.3.1 ...`); cross-references ("Section 3.4", "Figure 2") point to the right place after any restructuring or user edit.
- [ ] The register matches what was agreed for this unit (see `defaults.md`, "register"): in a plain-language unit, no math, code, hex values or numeric worked examples, and the verify script checks that.

## G. Real world, security and history
- [ ] The running scenario is realistic and its origin in a real system is stated.
- [ ] Each main mechanism has an In practice explanation (real deployments, real parameters, client implementations).
- [ ] Each main mechanism has a What can go wrong box (or an explicit note that it is covered elsewhere).
- [ ] Differences between the textbook model and real implementations (and between versions/forks/clients) are stated.
- [ ] Every historical, incident, parameter or factual claim has been web-checked against a primary source (spec, EIP/BIP, source code, official postmortem) and recorded in `FACTS` of the verify script.
- [ ] Contested claims (e.g. disputed incident root causes, security of a scheme under debate) are flagged with both sides cited.
- [ ] Version-sensitive facts (gas costs, block sizes, parameters changed by a fork) state the version/fork/date they apply to.

## H. Diagrams and boxes
- [ ] Every structural idea (flow, state machine, tree, architecture) has a diagram; boxes have diagrams too where they help.
- [ ] Every rendered diagram inspected visually; labels readable, nothing cut off, names and values match the text.
- [ ] The right tool per diagram type (see `boxes-and-figures.md`).
- [ ] Box titles contain no LaTeX-special characters.
- [ ] Mermaid sequence diagrams show each participant once, at the top, and no label spills out of its box (see `boxes-and-figures.md`).

## J. Verification and build
- [ ] `python3 verify_<unit>.py` prints PASSED; every computed value, table value and snippet output in the text has a check; every web-checked fact is listed in `FACTS`.
- [ ] Every code snippet in the text was run; source code cells (if any) ran unchanged; version differences reported.
- [ ] Combined PDF: cover shows title, version, date and organisation (if `ORG` is set); each unit starts on a new page with its title and subtitle; contents list readable (units as top-level entries).
- [ ] PDF builds without warnings that matter; contact sheet inspected; densest pages inspected at higher resolution for overflowing code lines, tables or diagrams.
- [ ] Provenance/licence notice present and correct (see `source-handling.md`).
