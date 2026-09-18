import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing pairs with the empty list. Both sides compute, so this is a
# definitional companion: it fixes the empty case and rules out a body that
# answers `Nil{}` with a non-empty one -- a `zip_sum` that returned `ys` itself
# would leave `ys` on the right of `{==}` against `Nil{}`.
law zip_sum_nil_left:
  for ys: List<Nat>
  {S.zip_sum(Nil{}, ys) == Nil{} : List<Nat>}

# LAW: and the same from the other side, which the law above does not say: it
# constrains the answer only when the *first* list is empty, so a body that
# recursed on the second list instead would not be touched by it.
law zip_sum_nil_right:
  for xs: List<Nat>
  {S.zip_sum(xs, Nil{}) == Nil{} : List<Nat>}

# LAW: the sum list stops when the shorter input stops. This is the induction,
# and it is stated exactly rather than as a bound: the length is
# `P.min(P.len(xs), P.len(ys))`, both `min`s of which step together in the
# `h1 <> t1` / `h2 <> t2` case, so the step case is one use of the hypothesis
# and nothing else. The constant body `Nil{}` fails it, since the left-hand
# side is `0n` and the right-hand side is stuck; a body that padded the short
# list out to the long one, or stopped at the longer of the two, fails it too.
law zip_sum_len:
  for xs: List<Nat>
  for ys: List<Nat>
  {P.len(S.zip_sum(xs, ys)) == P.min(P.len(xs), P.len(ys)) : Nat}

# LAW: zipping a list with itself doubles every element. The laws above are all
# about `Nil{}` and about lengths, and both would be satisfied by a body whose
# elements were all `0n`; this is the law that says which elements, and it is
# the only one that constrains the answer as a list rather than as a count.
law zip_sum_self:
  for xs: List<Nat>
  {S.zip_sum(xs, xs) == P.double_all(xs) : List<Nat>}
