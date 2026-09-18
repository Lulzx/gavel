import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: consing one more element onto a list adds one to its length. This is the
# law that pins `len`: `len_append` is satisfied by a `len` that ignored its
# argument entirely and returned `0n`, because then both sides are `0n`.
law len_cons:
  for x: Nat
  for xs: List<Nat>
  {S.len(x <> xs) == 1n+S.len(xs) : Nat}

# LAW: the length of an append is the sum of the lengths. This is the law that
# pins `append`: with a real `len` it is satisfied only by an `append` that
# really concatenates.
law len_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.len(S.append(xs, ys)) == S.len(xs) + S.len(ys) : Nat}
