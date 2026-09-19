import Base
import ./prelude.bend as P

# `dedup` answers `Nil{}` on a one-element input.
#
# This file exists for the inner empty case, which is a second answer reached by
# a match that has already stopped: the outer match takes the cons case and the
# answer comes from the branch on the empty tail. The generated mutants rewrite
# steps, not answers, so none of them lands here -- `dedup_single` also has a
# generated killer, but this is the mutant that fails *only* this law, which is
# what makes the two base cases separately pinned.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `dedup_single`.
def dedup(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      match t:
        case Nil{}:
          Nil{}
        case +h2 <> t2:
          P.same_put(h, dedup(h2 <> t2), P.same(h, h2))
