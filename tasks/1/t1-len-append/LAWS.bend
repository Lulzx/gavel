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

# LAW: appending nothing on the right does not change a list's length.
law len_nil_right:
  for xs: List<Nat>
  {S.len(S.append(xs, Nil{})) == S.len(xs) : Nat}

# LAW: appending to the empty list on the left returns the other list. This is
# the companion that pins `append`: `len_nil_right` is satisfied by the
# projection `append(xs, ys) = xs` (it reduces `append(xs, Nil{})` to `xs`),
# and this law is not.
law append_nil_left:
  for ys: List<Nat>
  {S.append(Nil{}, ys) == ys : List<Nat>}

# LAW: the second argument survives the cons step. None of the laws above ever
# applies `append` to a non-empty second argument in a cons step -- they count,
# or they fix the empty first argument -- so a body whose cons step recurses
# against `Nil{}` instead of `ys` satisfies all four at tier 4, reward 1.000
# (it answers `xs` whenever `xs` is non-empty). This law is what sees `ys`.
law append_cons:
  for h: Nat
  for t: List<Nat>
  for ys: List<Nat>
  {S.append(h <> t, ys) == h <> S.append(t, ys) : List<Nat>}
