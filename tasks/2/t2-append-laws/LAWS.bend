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

# LAW: the length of an append is the sum of the lengths. An earlier version of
# this comment claimed it "is satisfied only by an `append` that really
# concatenates"; that is false, and was measured false on 2026-09-19. Both laws
# here are about `len`, so the whole set counts and never inspects: an `append`
# that recurses on `ys` and computes `ys <> xs` has the right length for every
# input, and with a hand-written proof it reached **tier 4, reward 1.000**. A
# permutation is invisible to a cardinality.
law len_append:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.len(S.append(xs, ys)) == S.len(xs) + S.len(ys) : Nat}

# LAW: the head of the first list stays at the front. Together with the empty
# case below this is `append`'s definition written out, and it is the first law
# in the set to observe *order* rather than cardinality -- `ys <> (h <> t)` and
# `h <> (ys <> t)` are different lists and were the escape above.
law append_cons:
  for h: Nat
  for t: List<Nat>
  for ys: List<Nat>
  {S.append(h <> t, ys) == h <> S.append(t, ys) : List<Nat>}

# LAW: the empty list is the left identity. `append_cons` alone leaves
# `append(Nil{}, ys)` free in *content*: `len_append` fixes only its length, so
# any permutation of `ys` passes both it and `append_cons`. This law is what
# makes the base a value rather than a length.
law append_nil_left:
  for ys: List<Nat>
  {S.append(Nil{}, ys) == ys : List<Nat>}
