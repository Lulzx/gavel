import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty left list leaves the right one alone. Both sides compute, so
# this one is definitional, and it is the weak half: it fixes what the
# interleaving answers when there is nothing to alternate with.
law interleave_nil_l:
  for ys: List<&2, Nat>
  {S.interleave(Nil{}, ys) == ys : List<&2, Nat>}

# LAW: an empty right list leaves the left one alone. The left list is a
# variable, so the match in `interleave` is stuck and this one is an induction
# rather than an unfolding -- which is what makes it worth stating: a body that
# dropped the tail of the left list on the way down satisfies `interleave_nil_l`
# and leaves the two sides here unconvertible.
law interleave_nil_r:
  for +xs: List<&2, Nat>
  {S.interleave(xs, Nil{}) == xs : List<&2, Nat>}

# LAW: the interleaving has as many elements as both lists together. This is the
# work: the step counts two heads at once, so the arithmetic it leaves is an
# associativity that the prelude does not have, and the induction has to be over
# both lists at once because both of them shrink on the way down.
law interleave_len:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {P.len(S.interleave(xs, ys)) == P.len(xs) + P.len(ys) : Nat}
