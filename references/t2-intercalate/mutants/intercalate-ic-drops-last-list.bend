# HAND MUTANT (2026-09-19, tag f1). Target: `intercalate_nil_sep`, and the
# one-element law with it. The last list in the collection carries no separator,
# so a body that forgets it loses nothing from the step law's two sides -- those
# both recurse -- and nothing from the empty law. This body answers the empty
# list for a one-element collection, so `intercalate` loses the final list of
# everything it joins. The one-element law is what names that list directly, and
# it is also the branch where the last law -- whose right-hand side is the
# concatenation of all the lists -- stops being provable, since the collection's
# last list is exactly what the step law's recursion passes down unread.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["intercalate_single", "intercalate_nil_sep"]`.
# Both kills are semantic. The first is direct: `intercalate(sep, xs <> Nil{})`
# answers `Nil{}` here and `xs` in the law, and `xs` is a variable. The second is
# the one the law exists for: the last law's one-element branch wants
# `P.append(xs, Nil{})` on the right where this body has `Nil{}`, so the collection
# whose whole content is its final list is exactly where the truncation shows. The
# step law survives, which is why the truncation needs the law above: the step law
# only ever hands the tail down unread.
import Base
import ./prelude.bend as P

def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(sep, h2 <> t2)))
