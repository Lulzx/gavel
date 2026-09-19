import Base
import ./prelude.bend as P

# `concat(xss)` is the reference with a constant `0n` prepended to the result;
# the empty list of lists therefore answers `0n <> Nil{}` instead of `Nil{}`.
#
# Hand-written, and it is the regression witness for the hole `concat_nil`
# closes -- the same defect as `t1-rev-append`'s in the same shape. The
# reference fold is kept whole under `Policy.flat` and the target only wraps it,
# so the body is the reference at *no* list of lists, and it satisfied
# `concat_append` at every instance: the law's two sides are
# `A ++ (flat(xss) ++ ys)` and `(A ++ flat(xss)) ++ ys`, and associativity makes
# them equal for every constant `A`. Measured 2026-09-19 before the repair:
# **tier 4, complete, reward 1.000, `concat_append` proven**, under a
# hand-written proof (probe `/tmp/esc/t1con/`).
#
# The wrapper is why the helper exists: no self-recursive body prepends a
# constant, and the gate refuses a plain helper name, so `Policy.flat` is the
# only place to put the fold. A proof can still reach it -- the reference is
# `S.Policy.flat` -- which is why the gap was reachable rather than theoretical.
#
# Measured after the repair: **tier 3, `concat_nil` the only failure**,
# `concat_append` still proven. This is the mutant that gives `concat_nil` its
# kill.
def Policy.flat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case a <> rest:
      P.append(a, Policy.flat(rest))

def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  P.append(0n <> Nil{}, Policy.flat(xss))
