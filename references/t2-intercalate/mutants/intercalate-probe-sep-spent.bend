# PROBE (2026-09-19, tag f1): the candidate body this law set was probed with.
# The worry for a joining function is a thin law set -- the step law is satisfied
# by the recursion on its own two sides, and the empty and one-element laws never
# reach the recursion, so a body could in principle emit the first separator
# correctly and then spend it, handing the recursive call the empty list as the
# separator from the second gap on.
#
# This body does exactly that: it agrees with the reference on the empty and
# one-element collections and on the first separator, and every gap after the
# first is closed with nothing instead of `sep`. It is the analogue of the
# "correct at the named depth, wrong in the interior" body that a law set
# reaching only the named shapes would let through.
#
# The set is sound against it, and for a structural reason rather than a lucky
# one: the step law is stated over a *variable* separator, so its two sides are
# `append(a, append(sep, ...))` on the right and the recursive call's own answer
# on the left, and with `sep` a variable the two are convertible only if the
# recursive call receives `sep` as well. The gap this body closes wrongly is
# therefore named by the law, not merely instantiated.
#
# Measured 2026-09-19: **tier 1 (no-check)**, and it never gets as far as a law.
# The checker rejects the body itself:
#
#   - expected : a decreasing self-call (arguments are read left to right: each
#                passed unchanged until one shrinks)
#   - observed : intercalate
#
# Read left to right, `Nil{}` is the first argument of the self-call and the
# enclosing parameter in that position is `sep`, so the candidate is not a
# well-formed recursion to begin with. This is worth recording rather than
# deleting: the obvious way to "spend" the separator is closed off by the
# termination check, and the escape has to be looked for elsewhere -- see
# `intercalate-probe-drops-a-list.bend`, which is the candidate that type-checks.
import Base
import ./prelude.bend as P

def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          h
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(Nil{}, h2 <> t2)))
