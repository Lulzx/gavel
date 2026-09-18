import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: merging with an empty left list is the right list. Both sides compute, so
# this one is definitional, and it is the weak half: it fixes what `merge`
# answers when there is nothing on the left to compare against.
law merge_nil_l:
  for ys: List<&2, Nat>
  {S.merge(Nil{}, ys) == ys : List<&2, Nat>}

# LAW: merging with an empty right list is the left list. The left list is a
# variable, so the match in `merge` is stuck and this one is an induction rather
# than an unfolding -- which is what makes it worth stating: a body that read
# only one of its arguments satisfies `merge_nil_l` and leaves the two sides
# here unconvertible.
law merge_nil_r:
  for +xs: List<&2, Nat>
  {S.merge(xs, Nil{}) == xs : List<&2, Nat>}

# LAW: when the decision says the left head is not the greater one, the left head
# goes first. Together with the law below it this pins what `k` *means*: a
# `merge_go` branch whose two heads have nothing left to be compared against owes
# its answer to the comparison alone, and these two say which answer each value
# of the comparison calls for. A body that gave the same pair on both branches,
# or gave the pair the wrong way round, keeps every length and satisfies all
# three laws above, and leaves this one unconvertible.
law merge_go_true:
  for a: Nat
  for b: Nat
  {S.merge_go(Nil{}, a, Nil{}, b, True{}) == a <> b <> Nil{} : List<&2, Nat>}

# LAW: when the decision says the left head is the greater one, the right head
# goes first. The pair is the same two heads in the other order, so together with
# `merge_go_true` this fixes the answer to the comparison completely.
law merge_go_false:
  for a: Nat
  for b: Nat
  {S.merge_go(Nil{}, a, Nil{}, b, False{}) == b <> a <> Nil{} : List<&2, Nat>}

# LAW: `merge` keeps every element of both lists, so its result has as many
# elements as the two of them together. This is the work, and it is the law that
# says the head is chosen by the comparison rather than by which list it came
# from: a body that kept the two heads and dropped the tails -- `hx <> hy`,
# say -- satisfies all the pins above and leaves the two sides here
# unconvertible.
law merge_len:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {P.len(S.merge(xs, ys)) == P.len(xs) + P.len(ys) : Nat}
