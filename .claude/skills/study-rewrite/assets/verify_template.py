"""verify_<unit>.py: one check per concrete claim in the unit.

What counts as a claim: a computed value (hash, Merkle root, address, signature check, quorum size, fee, probability),
a table value, the output of a code snippet shown in the text, the step-by-step state of a walkthrough trace.
Facts about real systems (parameters, dates, incidents) are not checked here: they are web-checked against
specs/EIPs/BIPs/source code and listed in the FACTS table at the bottom with their source.

Conventions:
- Group checks by section, in the same order as the text, with a comment naming the claim.
- Recompute values from scratch (hashlib, small reference implementations); never copy the expected value
  from the code under test.
- Test properties on random inputs too (fixed seed), not just the running example.
- The script must end by printing a PASSED line; any failure aborts with the claim's description.
Run: python3 verify_<unit>.py
"""
import hashlib
import random

rng = random.Random(0)


def check(cond, claim):
    """Abort with the text's claim if a check fails."""
    if not cond:
        raise AssertionError(f"FAILED: {claim}")


def sha256(b: bytes) -> bytes:
    return hashlib.sha256(b).digest()


# --- Section 1: <title> ------------------------------------------------------------------
# Example of a computed value quoted in the text: "the Merkle root of tx1..tx4 starts with 0x..."
def merkle_root(leaves):
    level = [sha256(x) for x in leaves]
    while len(level) > 1:
        if len(level) % 2:
            level.append(level[-1])  # Bitcoin-style: duplicate the last node on odd levels
        level = [sha256(level[i] + level[i + 1]) for i in range(0, len(level), 2)]
    return level[0]


root = merkle_root([b"tx1", b"tx2", b"tx3", b"tx4"])
check(len(root) == 32, "a SHA-256 Merkle root is 32 bytes")

# Example of a table of cases: "with n validators, BFT tolerates f = floor((n-1)/3) faults; quorum = 2f+1"
for n, f_quoted, q_quoted in [(4, 1, 3), (7, 2, 5), (10, 3, 7), (100, 33, 67)]:
    f = (n - 1) // 3
    check(f == f_quoted and 2 * f + 1 == q_quoted, f"n={n}: f={f_quoted}, quorum={q_quoted}")

# Example of a property tested on random inputs: "any two quorums of size 2f+1 among 3f+1 overlap in >= f+1 nodes"
for _ in range(200):
    f = rng.randint(1, 20); n = 3 * f + 1
    a = set(rng.sample(range(n), 2 * f + 1)); b = set(rng.sample(range(n), 2 * f + 1))
    check(len(a & b) >= f + 1, "two quorums share at least one honest node")

# Example of a probability quoted to 3 decimals: "attacker with q=0.1 catches up from z=6 blocks behind ~ 0.0002"
# (implement the formula from the source and compare with atol matching the quoted precision)

# --- Facts checked on the web (not executable) ----------------------------------------------
FACTS = [
    # ("claim as written in the text", "source URL or spec section", "date checked"),
]

print("ALL CHECKS PASSED")
