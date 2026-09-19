# HAND MUTANT (2026-09-19, tag f1). Target: `intercalate_cons`. The separator
# goes between two lists, never in front of the first one; this body puts it in
# front instead, which is the mistake that reads the step as "the separator and
# the rest" rather than "the first list and the rest". Both the empty and the
# one-element law survive it, because neither reaches this branch, and the last
# law survives it too, because with the empty separator the two placements are
# the same list -- only the step law, which names the first list and the
# separator on the two sides, tells them apart.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["intercalate_cons"]` -- the
# step law alone, and it is a semantic kill: `P.append(sep, P.append(a, ...))`
# and `P.append(a, P.append(sep, ...))` are unconvertible for a variable `a` and a
# variable `sep`, so the placement of the separator is what this law pins. That
# the other three laws survive is the measurement: a body can put every separator
# in the collection and still get the first one's position wrong.
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
          P.append(sep, P.append(h, intercalate(sep, h2 <> t2)))
