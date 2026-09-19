import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no extremes to answer, and the answer is empty. Both
# sides compute, so this one is definitional, and it is a pin: the two cons laws
# below name a list with at least one element, so neither reaches the empty
# case, and a body that answered a two-element list here would keep both.
law extremes_nil:
  {S.extremes(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a one-element list is its own smallest and largest element. Both sides
# compute, so this is definitional as well, and it is the law that says the walk
# starts at the head: a body that seeded the running values with `0n` answers
# `0n <> x <> Nil{}` here and keeps every other law, since the empty case is the
# only other one that reaches the seed.
law extremes_single:
  for +x: Nat
  {S.extremes(x <> Nil{}) == x <> x <> Nil{} : List<&2, Nat>}

# LAW: the step into the walk. A cons cell hands its tail and its head, twice,
# to `ext_go`, so this is the law that says `extremes` is `ext_go` started at
# the head and not, say, at the last element or at a constant.
law extremes_cons:
  for +x: Nat
  for xs: List<&2, Nat>
  {S.extremes(x <> xs) == S.ext_go(xs, x, x) : List<&2, Nat>}

# LAW: the walk's empty case is its two running values, the smaller one first.
# Definitional, and it is the pin on the walk: with the law below it fixes which
# of the two running values ends up in front, and a body that answered
# `hi <> lo <> Nil{}` fails here while keeping everything else.
law ext_go_nil:
  for lo: Nat
  for hi: Nat
  {S.ext_go(Nil{}, lo, hi) == lo <> hi <> Nil{} : List<&2, Nat>}

# LAW: the walk's step folds the head into the two running values with `P.min2`
# and `P.max2`, in that order, and recurses on the tail. Definitional, and it is
# the interaction between the head and the pair: it is the only law whose two
# sides look at the running values at all, and a body that folded both heads
# through one of the comparisons -- `P.max2` into both slots, say -- answers the
# wrong pair here while keeping the pins and the length law.
law ext_go_cons:
  for +h: Nat
  for t: List<&2, Nat>
  for lo: Nat
  for hi: Nat
  {S.ext_go(h <> t, lo, hi) == S.ext_go(t, P.min2(h, lo), P.max2(h, hi)) : List<&2, Nat>}

# LAW: the walk answers exactly two elements, whatever the list and whatever the
# running values it starts from. This is the work: with a variable list neither
# side reduces, so the induction is the proof. It is the law that says the walk
# consumes the whole tail -- a body that stopped after one element, or that
# answered the running values as they came in, has the right *shape* everywhere
# above and the wrong length here.
law ext_go_len:
  for xs: List<&2, Nat>
  for lo: Nat
  for hi: Nat
  {P.len(S.ext_go(xs, lo, hi)) == 2n : Nat}
