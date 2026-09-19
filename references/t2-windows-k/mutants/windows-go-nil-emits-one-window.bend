import Base
import ./prelude.bend as P

# HAND MUTANT (base-case rule). The reference with the loop's stopped case
# answering one more window -- the one longer than the input can supply, which
# `P.take` fills with what is left -- instead of `Nil{}`. The law
# `windows_go_nil` has a constructor scrutinee on the left, so it is an answer
# rather than a step. Measured 2026-09-19: tier 3, laws_failed
# [windows_nil, windows_go_nil].

def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match ys:
    case Nil{}:
      P.take(xs, k) <> Nil{}
    case h <> t:
      P.take(xs, k) <> windows_go(t, k, P.tail(xs))

def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match k:
    case 0n:
      Nil{}
    case 1n+p:
      windows_go(P.lookahead(xs, k), k, xs)
