import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a one-element list has length one. This is the weak companion that pins
# the base case: `len_snoc` constrains only the recursion step, so on its own it
# is satisfied by a `len` that returns the wrong value for `Nil{}`.
law len_single:
  for x: Nat
  {S.len(x <> Nil{}) == 1n : Nat}

# LAW: putting one element on the right makes a list one element longer. `snoc`
# matches on its first argument, so with a variable `xs` on the left the goal
# does not reduce on its own: this one is inductive in `xs`.
law len_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.len(S.snoc(xs, x)) == 1n + S.len(xs) : Nat}
