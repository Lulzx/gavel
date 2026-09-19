import Base
import ./prelude.bend as P
import ./solution.bend as S

# `nat_bits_succ` and `nat_bits_len` bind both of their arguments `+`: each
# names its number more than once -- once inside the recursive call the law
# quantifies and once in the goal that is left -- and a `Nat` binder that is
# live twice is not Lone. `nat_bits_zero` names its width once, as the constant
# `0n`, so it is written plain. Anything that is not the function the policy
# writes is `P.` -- the solution module re-exports nothing, so `S.len` is not a
# name.

# LAW: the answer at width zero is the empty list, whatever the number is. The
# left-hand side is a ground term and both sides compute, so this is
# definitional: it fixes the answer the recursion reaches when there is no
# width left, and a body that answered one bit there would satisfy the two laws
# below at every width above zero. `n` is bound plain because the law never
# uses it twice.
law nat_bits_zero:
  for n: Nat
  {S.nat_bits(0n, n) == Nil{} : List<&2, Nat>}

# LAW: at width `1n + p` the answer is the low bit of `n` followed by the low
# `p` bits of `n` halved. Both sides compute, so this is definitional too, and
# it is what says *which* bits: the low bit first, least significant first, and
# the rest of the number halved rather than the width decremented alone. Written
# with `1n + p` on the left rather than `p` on the right so that the reference
# body -- a match on the width -- steps into its successor case.
law nat_bits_succ:
  for +w: Nat
  for +n: Nat
  {S.nat_bits(1n + w, n) == Nat.mod(n, 2n) <> S.nat_bits(w, Nat.div(n, 2n)) : List<&2, Nat>}

# LAW: the answer has one element per unit of width. This is the induction: the
# successor case unfolds the answer into a cons, `P.len` of a cons is one more
# than `P.len` of its tail -- so the goal becomes `1n + P.len(...)` against
# `1n + p` -- and the hypothesis at the halved number and the decremented width
# is the only thing that can rewrite the `P.len` occurrence. That hypothesis is
# at the halved number, which is a term the induction never matched on: the
# width is what shrinks, and the number is quantified alongside it, so the
# hypothesis is available at any number rather than only at the one the law
# started with.
law nat_bits_len:
  for +w: Nat
  for +n: Nat
  {P.len(S.nat_bits(w, n)) == w : Nat}
