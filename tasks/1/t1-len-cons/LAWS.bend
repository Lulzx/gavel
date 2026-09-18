import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: consing one more element onto a list adds one to its length.
law len_cons:
  for x: Nat
  for xs: List<Nat>
  {S.len(x <> xs) == 1n+S.len(xs) : Nat}

# LAW: a one-element list has length one. This is the weak companion that pins
# the base case: `len_cons` constrains only the cons step, so on its own it is
# satisfied by a `len` that returns the wrong value for `Nil{}`.
law len_single:
  for x: Nat
  {S.len(x <> Nil{}) == 1n : Nat}

# LAW: appending nothing on the right does not change a list's length. This one
# needs induction in `xs`: `append` matches on its first argument, so with a
# variable `xs` on the left the goal does not reduce on its own.
law len_nil_right:
  for xs: List<Nat>
  {S.len(P.append(xs, Nil{})) == S.len(xs) : Nat}
