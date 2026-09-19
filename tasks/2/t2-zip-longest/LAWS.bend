import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: padding an empty list answers the empty list, whatever the value is.
# Both sides compute, so this is definitional, and it is an absolute anchor: the
# right side calls no target. It is the pin on the left-padding walk's stopped
# answer, and it is the law that stops a body from emitting a phantom pair when
# there is nothing left to pad.
law zl_pad_left_nil:
  for d: Nat
  {S.zl_pad_left(Nil{}, d) == Nil{} : List<&2, P.Pair>}

# LAW: the left-padding step, and it is definitional. The element of the longer
# list goes in the *second* component and the padding value in the first, and
# the walk continues down the tail. A body that swapped the two components --
# which the closed laws below can see but a padded list of one element cannot --
# has a different unfolding here.
law zl_pad_left_cons:
  for h: Nat
  for t: List<&2, Nat>
  for +d: Nat
  {S.zl_pad_left(h <> t, d) == P.MkPair{d, h} <> S.zl_pad_left(t, d) : List<&2, P.Pair>}

# LAW: the right-padding walk's stopped answer, the mirror of the law above.
# Both sides compute and the right side calls no target, so it is an anchor too.
law zl_pad_right_nil:
  for d: Nat
  {S.zl_pad_right(Nil{}, d) == Nil{} : List<&2, P.Pair>}

# LAW: the right-padding step, and it is definitional. This is the mirror of
# `zl_pad_left_cons` and it is the law that fixes *which* component the padding
# goes in when it is the second list that ran out: read with the law above, it
# says the two walks are not the same function, so a body that padded both sides
# the same way is separated by the pair of them.
law zl_pad_right_cons:
  for h: Nat
  for t: List<&2, Nat>
  for +d: Nat
  {S.zl_pad_right(h <> t, d) == P.MkPair{h, d} <> S.zl_pad_right(t, d) : List<&2, P.Pair>}

# LAW: two empty lists zip to the empty list, in every padding value. Both sides
# compute, so this is definitional, and its left side is ground in both lists --
# it is the pin on the answer for the one input the outer match can decide on
# its own, before the second list is looked at. The right side calls no target.
law zip_longest_nil_nil:
  for d: Nat
  {S.zip_longest(Nil{}, Nil{}, d) == Nil{} : List<&2, P.Pair>}

# LAW: the step while both lists have elements. The two heads are packed
# together in order -- the first list's element in the first component -- and
# the walk continues on both tails. Both sides compute, so this is definitional,
# and it is the law that says which element goes where: a body that swapped the
# two components, or that recursed on one tail twice, leaves the two sides
# unconvertible.
law zip_longest_cons_cons:
  for hx: Nat
  for tx: List<&2, Nat>
  for hy: Nat
  for ty: List<&2, Nat>
  for d: Nat
  {S.zip_longest(hx <> tx, hy <> ty, d) == P.MkPair{hx, hy} <> S.zip_longest(tx, ty, d) : List<&2, P.Pair>}

# LAW: the first list runs out first, so the *second* list's remaining elements
# are padded on their left and the walk is handed to `zl_pad_left`. Both sides
# compute, so this is definitional; a body that stopped at the shorter list --
# which is what an ordinary `zip` does -- answers `Nil{}` on the right here, and
# a body that padded the wrong side names `zl_pad_right` instead.
law zip_longest_nil_cons:
  for h: Nat
  for t: List<&2, Nat>
  for +d: Nat
  {S.zip_longest(Nil{}, h <> t, d) == P.MkPair{d, h} <> S.zl_pad_left(t, d) : List<&2, P.Pair>}

# LAW: the second list runs out first, so the *first* list's remaining elements
# are padded on their right. Both sides compute, so this is definitional, and it
# is the mirror of the law above: the pair of them pins that the padding goes in
# the component belonging to the list that ran out, not to the one that is
# still going.
law zip_longest_cons_nil:
  for h: Nat
  for t: List<&2, Nat>
  for +d: Nat
  {S.zip_longest(h <> t, Nil{}, d) == P.MkPair{h, d} <> S.zl_pad_right(t, d) : List<&2, P.Pair>}

# LAW: two lists of the same length are zipped with nothing padded, and the
# padding value never appears. This is a closed value and its right side calls
# no target, so it is an absolute anchor; it is the law that separates a body
# which appends a padding pair even when both lists end together.
law zip_longest_equal_lengths:
  {S.zip_longest(1n <> 2n <> Nil{}, 10n <> 20n <> Nil{}, 9n)
     == P.MkPair{1n, 10n} <> P.MkPair{2n, 20n} <> Nil{} : List<&2, P.Pair>}

# LAW: the first list is longer, so the extra elements come out with the padding
# value in the second component and in order. The right side calls no target, so
# this is an absolute anchor, and it is the closed value that pins the direction
# of the right-hand padding and that the tail keeps its order.
law zip_longest_pads_the_right:
  {S.zip_longest(1n <> 2n <> Nil{}, 10n <> Nil{}, 9n)
     == P.MkPair{1n, 10n} <> P.MkPair{2n, 9n} <> Nil{} : List<&2, P.Pair>}

# LAW: the second list is longer, so the extra elements come out with the
# padding value in the *first* component. Read with the law above it is the pair
# that fixes which side the padding lands on; on its own it is the anchor for a
# body that padded both sides alike. The right side calls no target.
law zip_longest_pads_the_left:
  {S.zip_longest(1n <> Nil{}, 10n <> 20n <> Nil{}, 9n)
     == P.MkPair{1n, 10n} <> P.MkPair{9n, 20n} <> Nil{} : List<&2, P.Pair>}
