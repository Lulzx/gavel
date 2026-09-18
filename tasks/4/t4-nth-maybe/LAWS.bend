import Base
import ./prelude.bend as P
import ./solution.bend as S

# The value half is the two clauses of `nth`'s walk, and together they fix the
# answer wherever the list is a cons. The domain half is the pair of conditional
# laws below, and it is what fixes the empty case: there is no bare clause
# saying `nth(k, Nil{})` is `None{}`, because the out-of-range law already says
# that and says where the boundary is as well. A bare clause would take the
# conditional law's mutant weight -- the bodies that are wrong only on the empty
# list would be killed by the clause and nothing would be left for the law the
# task is about.

# LAW: the first element of a non-empty list. It is definitional -- `nth`
# consumes its index first, and `0n` is a constructor, so both sides compute to
# `Some{h}` -- and it is the law that says the answer is an element of the list
# rather than a constant. A body that answered `Some{0n}` at every index
# satisfies the step law below and leaves the two sides here unconvertible.
law nth_zero:
  for h: Nat
  for t: List<&2, Nat>
  {S.nth(0n, h <> t) == Some{h} : Maybe<&2, Nat>}

# LAW: one step of the walk. Also definitional, and it is what rules out a body
# that answers the head at every index: the step has to hand the *tail* to the
# recursive call with the index decremented, so the law says the answer depends
# on the index in the way `Nat` counts. It holds at every index, in range or
# not, which is why it needs no premise.
law nth_succ:
  for k: Nat
  for h: Nat
  for t: List<&2, Nat>
  {S.nth(1n + k, h <> t) == S.nth(k, t) : Maybe<&2, Nat>}

# LAW: an index the list has is an index the function answers. The premise is
# the invariant, and it is a fact about the index and the length --
# `Nat.is_lt(k, P.len(xs))`, both of which reduce through the `1n` step and are
# stuck on a variable -- rather than about the answer, so what the claim says is
# that the domain of the function is exactly the indices the list has. On the
# empty list the premise is `{False{} == True{}}` and the law is vacuous, which
# is the point of the pair: the positive half says nothing there, and the
# negative half says everything.
law nth_some:
  for +k: Nat
  for +xs: List<&2, Nat>
  for e: {Nat.is_lt(k, P.len(xs)) == True{} : Bool}
  {P.is_some(S.nth(k, xs)) == True{} : Bool}

# LAW: an index the list does not have is an index the function refuses. This is
# the half that pins the empty case, and it is the only law that does: on
# `Nil{}` the premise reduces to `{False{} == False{}}`, which *holds*, so the
# conclusion is not vacuous -- every `k` is out of range on the empty list, and
# the law says the answer is `None{}` for all of them. A body that answered
# `Some{0n}` on the empty list and the reference everywhere else satisfies every
# other law and is killed here and nowhere else.
law nth_none:
  for +k: Nat
  for +xs: List<&2, Nat>
  for e: {Nat.is_lt(k, P.len(xs)) == False{} : Bool}
  {S.nth(k, xs) == None{} : Maybe<&2, Nat>}
