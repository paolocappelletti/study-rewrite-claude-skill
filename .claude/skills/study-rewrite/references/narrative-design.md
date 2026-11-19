# Narrative design

How to turn a list of topics into one built-up argument. This is what fixes the "it reads like a syllabus" problem.

## Contents
1. Destination and course arc
2. The opening
3. The chain of questions
4. The running scenario
5. Section anatomy
6. The closing picture and the bridge
7. Papers, specs and protocol docs
8. Worked example: a sample spine

---

## 1. Destination and course arc

- State at the very start what the **whole material** builds towards, as one claim plus 2–3 concrete results (e.g. "a set of mutually distrusting machines can agree on one history of transactions, as long as fewer than a third misbehave: this is what lets Ethereum finalize a block in ~13 minutes and the Cosmos Hub in ~6 seconds").
- Then say in a short paragraph which units cover which part of the way (e.g. "Units 1–2 explain how X works, Units 3–4 ..., Unit 5 ..."). Do not add a units table on top of that paragraph: a recap that repeats what the prose already says is cut (the user removed one).
- All of this, and the opening (§ 2), appear **once**, at the start of the first unit. Later units start with at most one line saying where they sit in the list, then go straight to the question the previous unit left open.
- If one system or scenario can thread all units, choose it now (e.g. "a 4-validator network processing Alice's payment to Bob", or "the Bitcoin codebase"). Ask the user if several are plausible.

## 2. The opening

The **whole document** opens once, at the start of the first unit, with something concrete that makes the reader want the material's central idea. Later units have no opening of their own: they start from the question the previous unit left open. Choose the kind that fits what is being studied; none is the default:

| kind | when it fits | examples |
|---|---|---|
| **a surprising fact** | the result itself is counter-intuitive or impressive | "a Merkle proof for one transaction among 4,000 is 12 hashes, under 400 bytes"; "a ZK proof of a million-step computation verifies in milliseconds" |
| **a main feature** | the material is about a system or tool whose capability is the point | "an Ethereum light client follows the chain while downloading only tens of kilobytes per day"; "a rollup posts one proof for thousands of transactions" |
| **a main need** | the material answers a design problem | "a payment network must agree on an order of transactions with no one in charge"; "a wallet must prove ownership without revealing the key" |
| **an incident** | the mechanism exists because something broke | "block 74638 created 184 billion BTC"; "The DAO lost 3.6M ETH to reentrancy" |

A good opening, of any kind:
- is concrete: real systems, real numbers, or a scenario reproducible in a few lines of code;
- raises a question the reader's current mental model cannot answer yet ("how is that possible?", "how would I build that?", "why did that happen?");
- is answered by the material's central idea, and re-read at the end of the last unit through the final picture.

When the opening is a need or an incident, show the naive design failing (with a short trace) early; that failure becomes Section 1's climax. When it is a fact or a feature, Section 1 shows why the obvious approach could not deliver it.

When choosing, present candidates (of different kinds when that makes sense) with a criteria table: how well it motivates the mechanism; real-world significance; how much extra background it needs; link to the final destination. A hybrid (e.g. a striking feature as opener + a toy scenario as thread) is often best.

Be honest when an opening only holds under some conditions (e.g. a double spend is only a threat if the merchant accepts zero confirmations).

## 3. The chain of questions

Write the unit's spine as a numbered list before writing prose. Each step has the form:

> question → minimal idea that answers it → what it still cannot do (the next question)

Rules for the chain:
- Every concept enters because the previous step demanded it. If a concept has no "because", it moves or goes into an optional box.
- Prefer "smallest change that works" steps (add a signature → add a sequence number → add a timeout → add a quorum): they make the final design feel inevitable rather than handed down. Say honestly when the real system made a different choice, and why.
- Results established early are reused later (no dead ends). If something is never reused, it goes in an optional box or is cut.
- Show the broken version before the fix: a design that fails, with the trace of the failure, is the strongest motivation for the next step.

## 4. The running scenario

- One concrete instance carried through the unit, realistic, small enough to trace by hand at every stage (e.g. "4 validators A, B, C, D, one of which (D) is Byzantine; Alice sends 5 ETH to Bob; block height 100").
- Concrete values stay readable: short hex prefixes (`0x3f2a…`), small amounts, 3–5 nodes, 4–8 transactions.
- Introduce it where the design first can hold it, and say how it arises in a real system.
- Revisit it at every new tool: the same transaction is hashed, signed, gossiped, included, ordered, finalized; the same four nodes vote in every round.
- If the source uses a different example (e.g. in its code), keep the source's example where its code needs it and connect it to the running scenario.

## 5. Section anatomy

Each section:
1. **Opening line:** the question the section answers, written as a plain sentence ending with a question mark (no "**The question:**" label; the user removed it everywhere).
2. Main text: the idea, with the technical name.
3. Refresher box(es) exactly where a prerequisite is first used.
4. Example box with concrete values right after each new definition, data structure or message format.
5. Walkthrough box(es) for each mechanism the chain relies on: step by step, on the running scenario, with the state after each step.
6. "What can go wrong" box for the failure modes and attacks the mechanism prevents (or doesn't).
7. In practice / In code box for the real-world meaning; history box when a historical step happens here.
8. Diagram(s).
9. Closing sentence(s): what is now explained, and what is still missing, phrased as the next section's question.

## 6. The closing picture and the bridge

- The last main section of each unit assembles the unit into **one comprehensive picture** (an architecture diagram, a full message-flow sequence, a state machine, a comparison table) and re-reads the unit's starting question and the running scenario off it.
- The last unit's closing picture covers the whole material and re-reads the document's opening.
- A side-by-side "design evolution" table: naive design, intermediate designs, final design; for each, what it guarantees and how it fails.
- A short "what this still can't do" section that sets up the next unit (its last question is where the next unit starts), and plants an idea or a number that returns later.

## 7. Papers, specs and protocol docs

For a research paper, a whitepaper, an EIP/BIP or a protocol spec the same machinery applies:

1. **Destination**: the paper's main result or the spec's guarantee, stated informally with its headline numbers (throughput, latency, fault tolerance, proof size).
2. **Opening**: usually the need (the problem and why the obvious approach fails, with a small concrete instance and its trace), or the headline result as a surprising fact.
3. **Chain**: reconstruct the design as the sequence of ideas that makes it inevitable; reorder the document if its order is presentation-driven (specs in particular are written for implementers, not learners).
4. **Running scenario**: a toy instance small enough to trace by hand (and in a script) at every step.
5. **Refreshers**: background the document assumes (primitives, prior protocols, notation), just in time.
6. **In practice** boxes: real deployments, parameter values, client implementations, known incidents.
7. **Security and limits**: the threat model and network model the result needs (synchrony, honest majority, trusted setup), known attacks and critiques, follow-up work (web-checked).
8. Explain in original words; never reproduce the document's text (see `source-handling.md`). Quote at most a short phrase when exact wording matters (e.g. a MUST in a spec).

## 8. Worked example: a sample spine

A spine for the **first unit** of a course on Byzantine fault-tolerant consensus (so it carries the document opening), to show the shape (not a finished unit):

| section | question it answers | what it leaves open |
|---|---|---|
| 0 | where the course is going; the opening (a need): a payment network with no one in charge must still put every node's transactions in one order | how do honest nodes agree on one history at all? |
| 1 | can nodes just broadcast transactions and apply them in arrival order? No: trace with 4 nodes shows two different orders | who decides the order? |
| 2 | a leader proposes the order; trace works; but a faulty leader can send different blocks to different nodes (equivocation trace) | how do nodes detect equivocation? |
| 3 | signatures + vote on the proposal; quorum of 2f+1 out of 3f+1; overlap argument with n=4, f=1, worked by hand | votes can arrive late or never: when do you give up on a leader? |
| 4 | timeouts and view change; the trace when D is the leader and stays silent | what is the full picture, and what does it cost? |
| 5 | full message-flow diagram of one height; the single-order need from the opening answered for this unit's scope; messages per block O(n²) | how do real chains with 1M validators avoid O(n²)? → next unit (aggregation, committees) |
