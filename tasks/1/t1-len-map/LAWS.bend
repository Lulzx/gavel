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

# LAW: mapping a list does not change its length.
law len_map:
  for xs: List<Nat>
  {S.len(S.map(xs)) == S.len(xs) : Nat}

# LAW: `map` maps the head with `inc` and recurses on the tail. This is the
# companion that pins `map`: `len_map` is satisfied by the identity function
# `map(xs) = xs` and by `map(xs) = Nil{}` on the empty list, and this law is
# not.
law map_cons:
  for x: Nat
  for xs: List<Nat>
  {S.map(x <> xs) == P.inc(x) <> S.map(xs) : List<Nat>}
