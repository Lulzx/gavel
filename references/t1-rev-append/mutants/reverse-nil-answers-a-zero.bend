import Base
import ./prelude.bend as P

# `reverse(xs)` is the reference with one extra element appended to the end; the
# empty list therefore answers `0n <> Nil{}` instead of `Nil{}`.
#
# Hand-written, and it is the regression witness for the hole `rev_nil` closes.
# The reference `reverse` is kept whole under `Policy.rev_core` and the target
# only wraps it, so the body is the reference at *no* list -- and it satisfied
# `rev_append` at every instance, because that law compares two applications of
# `reverse` and the trailing element cancels on both sides. Measured
# 2026-09-19 before the repair: **tier 4, complete, reward 1.000, `rev_append`
# proven**, under a hand-written proof (probe `/tmp/esc/t1rev/`).
#
# The wrapper is why the helper has to exist: a self-recursive body cannot
# post-compose with a constant, and the gate refuses a plain helper name, so
# `Policy.rev_core` is the only place to put it. A proof can still reach it --
# the reference is `S.Policy.rev_core` -- which is why the law-level gap was
# reachable rather than theoretical.
#
# Measured after the repair: **tier 3, `rev_nil` the only failure**, `rev_append`
# still proven. This is the mutant that gives `rev_nil` its kill.
def Policy.rev_core(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.append(Policy.rev_core(t), h <> Nil{})

def reverse(xs: List<Nat>) -> List<Nat>:
  P.append(Policy.rev_core(xs), 0n <> Nil{})
