# HAND MUTANT (2026-09-19, tag f1). Target: `intercalate_nil`. The empty
# collection has no gap, so the separator does not appear; this body answers the
# separator anyway, which is the mistake the empty case of every joining function
# invites. Every other law survives it, because the step law names both of its
# own sides and the single-element law never reaches this branch.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["intercalate_nil"]` -- one law,
# the one named above, and the refutation is semantic rather than a proof shape:
# the law's left-hand side is `sep` and its right-hand side is `Nil{}` with `sep`
# a variable, so the two sides differ for every non-empty separator.
import Base
import ./prelude.bend as P

def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      sep
    case h <> t:
      match t:
        case Nil{}:
          h
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(sep, h2 <> t2)))
