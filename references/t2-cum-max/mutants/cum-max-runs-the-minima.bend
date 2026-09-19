import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `cum_max_three` (and, on the way, `cum_max_cons`). The
# mirror of the walk: every cell is the largest of what has gone before, so this
# body answers the *smallest* instead. It is the reading a policy that reached
# for the other end of `Nat` while writing the raise has, and it agrees with the
# reference on every list that only ever falls -- `[3n, 1n, 2n]` is the shortest
# closed list where the two disagree, which is why that is the closed law.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-cum-max --solution <this file> --proof references/t2-cum-max/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["cum_max_cons",
# "cum_max_len", "cum_max_three"]`. The step law catches it because the body's
# raise is not the one the law names, the closed law because `Nat.min` is not
# `Nat.max`, and the length law because its proof turns on the lemma about
# `max_all` -- a running minimum is as long as its input, so the length is not
# where the body is wrong, and the law still separates the bodies that do their
# raising somewhere else.
def max_all(ys: List<&2, Nat>, +m: Nat) -> List<&2, Nat>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.max(h, m) <> max_all(t, m)

def Policy.min_all(ys: List<&2, Nat>, +m: Nat) -> List<&2, Nat>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      Nat.min(h, m) <> Policy.min_all(t, m)

def cum_max(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> Policy.min_all(cum_max(t), h)
