import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: insertion sort is sorted. This is the induction, and its step case is
# the whole task: `isort(h <> t)` is `insert(isort(t), h)`, so the element `h`
# has to be moved past a sorted list that the induction hypothesis describes
# but the proof cannot match on. Both sides depend on the argument, so no
# argument-ignoring body satisfies it -- but `isort` returning `Nil{}` does,
# `P.is_sorted(Nil{})` being `True{}`, which is why the two-element law below
# is not optional.
law isort_sorted:
  for +xs: List<&2, Nat>
  {P.is_sorted(S.isort(xs)) == True{} : Bool}

# LAW: inserting into a sorted list leaves it sorted. `isort_sorted` needs
# exactly this at its step, and it is not reachable from the definitions alone,
# so it is a law of its own -- a helper may not cite a law, and this is the
# fact the step case has to have. It does not pin `insert` by itself: an
# `insert` that dropped the list and returned `y <> Nil{}` satisfies it, the
# resulting list being sorted whatever the input was.
law insert_sorted:
  for +xs: List<&2, Nat>
  for +y: Nat
  for e: {P.is_sorted(xs) == True{} : Bool}
  {P.is_sorted(S.insert(xs, y)) == True{} : Bool}

# LAW: inserting into the one-element list `x <> Nil{}` puts `y` first exactly
# when `y` is at most `x`. This is the decision the cons step of `insert`
# cannot see for itself, stated where a `match` can reach it: the list is a
# literal, so both sides compute and the decision is the only thing left.
law insert_le:
  for +x: Nat
  for +y: Nat
  for e: {P.le(y, x) == True{} : Bool}
  {S.insert(x <> Nil{}, y) == y <> x <> Nil{} : List<&2, Nat>}

# LAW: and last when it is not. Together with `insert_le` this pins the cons
# case of `insert` at both answers the comparison can give, which is what
# `insert_sorted` cannot do on its own. The hypothesis is a binder rather than
# `1n + x` on purpose: the policy gets the fact as an assumption instead of
# having to derive it first.
law insert_gt:
  for +x: Nat
  for +y: Nat
  for e: {P.le(y, x) == False{} : Bool}
  {S.insert(x <> Nil{}, y) == x <> y <> Nil{} : List<&2, Nat>}

# LAW: two elements in the wrong order come back swapped. `isort_sorted` alone
# is satisfied by any `isort` that ignores its argument and returns a sorted
# list -- `Nil{}`, or `x <> Nil{}` -- and the result of a sort is not otherwise
# tied to the argument by these laws. Both sides compute to the cons step of
# `insert` on a literal list, so the decision is again the only thing left.
law isort_swap:
  for +x: Nat
  for +y: Nat
  for e: {P.le(x, y) == False{} : Bool}
  {S.isort(x <> y <> Nil{}) == y <> x <> Nil{} : List<&2, Nat>}

# LAW: inserting one element makes the list one longer. The five laws above say
# what the answer *is* only on lists of at most two elements: `insert_le` and
# `insert_gt` fix `insert` on a literal one-element list, `isort_swap` fixes
# `isort` on two, and everything else is a sortedness predicate, which a list
# with elements missing still satisfies. Nothing counted, so an `insert` that
# answered a two-element list whenever it was handed a longer one kept every
# law. This is the law that counts, and it is what ties the answer's length to
# the argument's.
law insert_len:
  for +xs: List<&2, Nat>
  for +y: Nat
  {P.len(S.insert(xs, y)) == 1n + P.len(xs) : Nat}
