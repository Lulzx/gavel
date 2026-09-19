import Base
import ./prelude.bend as P

# HAND MUTANT (base-case rule). The reference with `windows`' length-zero case
# answering one empty window instead of `Nil{}`. The law `windows_zero` has a
# stopped match with a literal scrutinee on the left, so it is an answer rather
# than a step, and the generated mutants only rewrite steps. Measured
# 2026-09-19: tier 3, laws_failed [windows_zero, windows_nil].

def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      P.take(xs, k) <> windows_go(t, k, P.tail(xs))

def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match k:
    case 0n:
      Nil{} <> Nil{}
    case 1n+p:
      windows_go(P.lookahead(xs, k), k, xs)
