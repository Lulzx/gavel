# HAND MUTANT (2026-09-19, tag f1). Target: `intercalate_single`. A one-element
# collection has no gap either, so its answer is that list unchanged; this body
# appends the separator after it instead, which is the mistake that treats the
# last list as if a gap followed it. The empty law survives it -- the empty
# collection answers the empty list either way -- and the step law survives it
# too, because the step law keeps both sides inside the recursion.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["intercalate_single", "intercalate_nil_sep"]`.
# The first is the semantic kill and the one the body was written for: the law's
# right-hand side is `xs` and this body's is `P.append(xs, sep)`, which differ as
# soon as the separator is non-empty. The second is a proof-shape kill and is
# recorded as such: with the empty separator the last law's two sides still
# normalise to the same list, but its one-element branch is proved by the identity
# `P.append(xs, Nil{}) == xs`, which this body has already applied, so the
# recorded proof no longer matches the goal and that law goes unproven. The law
# that refutes the body is the single-element one.
import Base
import ./prelude.bend as P

def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          P.append(h, sep)
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(sep, h2 <> t2)))
