import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing triples with an empty first list. Both sides compute, so this is
# definitional, and it fixes the answer on the one empty case the outer match
# can reach by itself.
law zip3_nil_left:
  for ys: List<Nat>
  for zs: List<Nat>
  {S.zip3(Nil{}, ys, zs) == Nil{} : List<Nat>}

# LAW: and nothing triples with an empty second list either. The law above
# constrains the answer only when the *first* list is empty, so a body that
# recursed on the third list instead of the three together would not be touched
# by it. With a variable `xs` the outer match is stuck, so this one is an
# induction, and its step case is the inner match on the literal `Nil{}`.
law zip3_nil_mid:
  for xs: List<Nat>
  for zs: List<Nat>
  {S.zip3(xs, Nil{}, zs) == Nil{} : List<Nat>}

# LAW: and the same from the third side, which neither law above says. This one
# is the deepest: with `xs` and `ys` variables both matches are stuck, so the
# induction is on `xs` and then on `ys`, and the innermost step is the match on
# the literal `Nil{}`.
law zip3_nil_right:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.zip3(xs, ys, Nil{}) == Nil{} : List<Nat>}

# LAW: the sum list stops when the shortest input stops. This is the induction,
# and it is stated exactly rather than as a bound: the length is
# `P.min3(P.len(xs), P.len(ys), P.len(zs))`, all three of which step together in
# the cons case, so the step case is one use of the hypothesis and nothing else.
# The constant body `Nil{}` fails it, since the left-hand side is `0n` and the
# right-hand side is stuck; a body that padded the short lists out to the long
# one, or stopped at the longest of the three, fails it too.
law zip3_len:
  for xs: List<Nat>
  for ys: List<Nat>
  for zs: List<Nat>
  {P.len(S.zip3(xs, ys, zs)) == P.min3(P.len(xs), P.len(ys), P.len(zs)) : Nat}

# LAW: the step of `zip3`, with all three elements spelled out. The laws above
# fix the empty cases and the *count*, and none of them looks at what happens to
# a head: a body that answered `(h1 + h1 + h1) <> zip3(t1, t2, t3)` -- reading
# only the first of the three elements -- has the right length everywhere and
# leaves the two sides here unconvertible. Both sides compute, so this costs one
# `{==}`.
law zip3_cons:
  for h1: Nat
  for t1: List<Nat>
  for h2: Nat
  for t2: List<Nat>
  for h3: Nat
  for t3: List<Nat>
  {S.zip3(h1 <> t1, h2 <> t2, h3 <> t3) == (h1 + h2 + h3) <> S.zip3(t1, t2, t3) : List<Nat>}
