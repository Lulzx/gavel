import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty association list has no values. It is definitional, and it is
# the weak half: a body that answered `0n <> Nil{}` or dropped the projection
# entirely leaves the two sides here unconvertible.
law values_nil:
  {S.values(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the step. A cons cell projects its value onto the front of the projection
# of its tail and *discards its key*. It is definitional, and it is the law that
# pins which component of the pair the projection reads: a body that projected
# the key instead satisfies `values_nil` and leaves the two sides here
# unconvertible as soon as a value is not its key.
law values_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  {S.values(P.Mk{hk, hv} <> kvs) == hv <> S.values(kvs) : List<&2, Nat>}

# LAW: storing under a key puts exactly that value at the front of the
# projection, and leaves the projection of the rest of the association list
# alone. It is definitional, since the store puts the new entry at the head.
# Together with `values_cons` it says the projection reads the stored value and
# not the query: a body that prepended `k` satisfies `values_cons` and leaves the
# two sides here unconvertible as soon as a value is not its key.
law values_put:
  for kvs: List<&2, P.Entry>
  for k: Nat
  for v: Nat
  {S.values(P.assoc_put(kvs, k, v)) == v <> S.values(kvs) : List<&2, Nat>}

# LAW: the empty association list sums to zero. It is the weak half that fixes
# the base case of the sum, and both sides compute.
law sum_values_nil:
  {S.sum_values(Nil{}) == 0n : Nat}

# LAW: the step. A cons cell adds its value to the sum of its tail. It is
# definitional, and it is the law that pins *which* component is summed: a body
# that summed the keys satisfies `sum_values_nil` and leaves the two sides here
# unconvertible.
law sum_values_cons:
  for hk: Nat
  for hv: Nat
  for kvs: List<&2, P.Entry>
  {S.sum_values(P.Mk{hk, hv} <> kvs) == hv + S.sum_values(kvs) : Nat}

# LAW: the sum of the values is the sum of the value projection, for every
# association list. It is the law that ties the two functions together, and it is
# where the sum is pinned as *the* sum of the projection rather than any fold
# that happens to agree on one cell: the four laws above are relative to what
# each function does to one cell, and this one compares them on a whole list.
# It is an induction on the list, because the sum descends on the list and the
# projection hands it a computed one.
law sum_values_values:
  for kvs: List<&2, P.Entry>
  {S.sum_values(kvs) == P.nsum(S.values(kvs)) : Nat}
