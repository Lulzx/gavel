import Base
import ./prelude.bend as P

# ESCAPE PROBE, written by the verifier rather than the author. The reference
# with an extra window emitted at the front, of the length the caller asked for,
# from `windows` itself rather than from the loop. The shape under test is the
# one the `anchors` screen cannot see: `windows`'s only law that names it with
# `k` free on the left is `windows_nil`, whose right-hand side is a value, so
# the question is whether `windows_succ` is enough to pin the case split.
# Measured 2026-09-19: tier 3, laws_failed [windows_succ].

def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      P.take(xs, k) <> windows_go(t, k, P.tail(xs))

def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match k:
    case 0n:
      Nil{}
    case 1n+p:
      P.take(xs, k) <> windows_go(P.lookahead(xs, k), k, xs)
