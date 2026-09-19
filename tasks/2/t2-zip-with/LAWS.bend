import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing combines with the empty list. Both sides compute, so this is
# definitional, and it fixes the answer on the one empty case the outer match
# can reach by itself.
law zip_with_nil_left:
  for ys: List<Nat>
  {S.zip_with(Nil{}, ys) == Nil{} : List<Nat>}

# LAW: and nothing combines with the empty list from the other side either. The
# law above constrains the answer only when the *first* list is empty, so a body
# that recursed on the second list instead of on the two together would not be
# touched by it. With a variable `xs` the outer match is stuck, so this one is
# the induction on `xs`, and its step case is the inner match on the literal
# `Nil{}`.
law zip_with_nil_right:
  for xs: List<Nat>
  {S.zip_with(xs, Nil{}) == Nil{} : List<Nat>}

# LAW: the combined list stops when the shorter input stops. This is the
# induction, and it is stated exactly rather than as a bound: the length is
# `P.min(P.len(xs), P.len(ys))`, both `min`s of which step together in the
# `h1 <> t1` / `h2 <> t2` case. The constant body `Nil{}` fails it, since the
# left-hand side is `0n` and the right-hand side is stuck; a body that padded
# the short list out to the long one, or stopped at the longer of the two, fails
# it too.
law zip_with_len:
  for xs: List<Nat>
  for ys: List<Nat>
  {P.len(S.zip_with(xs, ys)) == P.min(P.len(xs), P.len(ys)) : Nat}

# LAW: combining a list with itself gives the list back. This is the law about
# the *operation* rather than about the zipping: it holds because `P.max` is
# idempotent, and it is the one thing a law set for a pairing `zip` cannot say,
# since a pair of an element with itself is not the element. The laws above are
# all about `Nil{}` and about lengths, and every one of them would be satisfied
# by a body whose elements were all `0n`; this is the law that says which
# elements, and the diagonal is where a body that read only the first list's
# element is caught.
law zip_with_self:
  for xs: List<Nat>
  {S.zip_with(xs, xs) == xs : List<Nat>}

# LAW: the step, with both elements spelled out. `zip_with_self` only ever
# compares `zip_with(xs, xs)` with itself, where the two heads are the same
# element, so none of the laws above says what happens to a pair of *different*
# elements: a body that answered `P.max(h1, h1)` -- never reading the second
# list's element -- proves all four at tier 4, reward 1.000. Both sides compute
# here, so this costs one `{==}`.
law zip_with_cons:
  for h1: Nat
  for t1: List<Nat>
  for h2: Nat
  for t2: List<Nat>
  {S.zip_with(h1 <> t1, h2 <> t2) == P.max(h1, h2) <> S.zip_with(t1, t2) : List<Nat>}
