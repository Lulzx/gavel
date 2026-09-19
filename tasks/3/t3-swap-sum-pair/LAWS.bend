import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing to swap. Both sides compute, so this one is definitional, and it
# is a pin: it fixes the answer on the empty list, which no other law here
# reaches.
law swap_each_nil:
  {S.swap_each(Nil{}) == Nil{} : List<&2, P.Pair>}

# LAW: the step, and the only law that says which way the halves go. Both sides
# compute, so this is definitional, and it is what rules out a body that left
# the records alone: `MkPair{a, b}` in front of the rest is not `MkPair{b, a}`.
# `swap_each_swap_each` below cannot see the difference on its own, since
# anything that is its own inverse twice over satisfies it.
law swap_each_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, P.Pair>
  {S.swap_each(P.MkPair{a, b} <> t) == P.MkPair{b, a} <> S.swap_each(t) : List<&2, P.Pair>}

# LAW: nothing to add up. Both sides compute, so this is definitional, and it is
# the pin on `sum_pair`'s empty case. `0n` is the only answer that keeps the sum
# law below true at the empty list.
law sum_pair_nil:
  {S.sum_pair(Nil{}) == 0n : Nat}

# LAW: the step. One record contributes both of its halves to the sum, in the
# order they are written, in front of the sum of the rest. Both sides compute, so
# this is definitional, and it says the sum is over the *elements of the records*
# and not over the records themselves.
law sum_pair_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, P.Pair>
  {S.sum_pair(P.MkPair{a, b} <> t) == a + (b + S.sum_pair(t)) : Nat}

# LAW: swapping every record twice is the identity. This is the work, and it is
# an induction: with a variable `ps` neither side computes, since `swap_each` is
# stuck until its argument is a cons. It is the law that says `swap_each` really
# swaps rather than, say, sorting the records onto the ends of the list, which
# `swap_each_cons` alone leaves open at the list level -- but it cannot say which
# way round the halves go, which is why it is not on its own either.
law swap_each_swap_each:
  for +ps: List<&2, P.Pair>
  {S.swap_each(S.swap_each(ps)) == ps : List<&2, P.Pair>}

# LAW: the interaction, and the reason the two functions are one task. Swapping
# the halves of every record does not change the sum of them all, because the
# same numbers are still added up. It is not definitional, and it is not an
# induction on its own either: the step reaches `b + (a + s)` against
# `a + (b + s)`, which is commutativity of `+`, and that is a proof of its own
# that is not asked for. The law is the only one of the six that mentions both
# functions, so it is what pins them against each other: a `sum_pair` that added
# the halves of the first record and skipped the rest, and a `swap_each` tuned to
# it, agree with every law above and disagree here.
law sum_pair_swap_each:
  for +ps: List<&2, P.Pair>
  {S.sum_pair(S.swap_each(ps)) == S.sum_pair(ps) : Nat}
