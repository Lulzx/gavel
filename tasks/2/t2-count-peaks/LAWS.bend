import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are the specification of `count_peaks`. A list of fewer than three
# elements has no element with two neighbours, so it has no peaks: the empty
# list is answered `0n` and so is a one-element list, whatever the element is.
# A list of three or more is walked from its third element on, carrying the two
# elements before the one being decided, and each window contributes `P.peak_at`
# -- `1n` when the element in the middle of the window beats both of its
# neighbours and `0n` otherwise. The walk's `Nil{}` case is the last element's
# window not existing, which is why the last element of a list is never counted.

# The anchor at the bottom: the empty list has no element at all, so it has no
# element with two neighbours.
law count_peaks_nil:
  {S.count_peaks(Nil{}) == 0n : Nat}

# The anchor for a list that reaches the walk's first case with nothing behind
# it. Its one element has a single neighbour on neither side, so it is not a
# peak, and neither is anything else, there being nothing else.
law count_peaks_single:
  for x: Nat
  {S.count_peaks(x <> Nil{}) == 0n : Nat}

# The hand-off. `count_peaks` spends its two leading elements on establishing
# the first window and hands the rest of the list to the walk, whose elements
# will each be decided against the two before it. This is what ties the answer
# to the walk: it is the only law whose left-hand side reaches `peaks_go`
# through `count_peaks`.
law count_peaks_step:
  for +h: Nat
  for +j: Nat
  for +u: List<&2, Nat>
  {S.count_peaks(h <> (j <> u)) == S.peaks_go(u, h, j) : Nat}

# The walk's own anchor. Nothing is left to read, so the element in hand is the
# last one and has no second neighbour: it is not a peak and the count is over.
law peaks_go_nil:
  for prev: Nat
  for h: Nat
  {S.peaks_go(Nil{}, prev, h) == 0n : Nat}

# The walk's step, and the law that says what the walk is measuring. The front
# of the remaining list is the second neighbour of the element in hand, so it
# decides that element: `P.peak_at(prev, h, j)` is `1n` exactly when `h` beats
# both `prev` and `j`. What is left is decided the same way with `h` and `j` as
# the two elements behind it, and the two counts are added.
law peaks_go_cons:
  for +prev: Nat
  for +h: Nat
  for +j: Nat
  for +u: List<&2, Nat>
  {S.peaks_go(j <> u, prev, h) == P.peak_at(prev, h, j) + S.peaks_go(u, h, j) : Nat}

# Content, at a list long enough for each of the three elements to be decided
# against the neighbours it has. The first and the last have one neighbour each
# and so contribute nothing; the middle one contributes `P.peak_at(x, y, z)`,
# which is `1n` when it beats the other two and `0n` otherwise. A body that
# counts the first element, or the last, or that counts a plateau as a peak,
# is separated from the reference here.
law count_peaks_three:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  {S.count_peaks(x <> (y <> (z <> Nil{}))) == P.peak_at(x, y, z) : Nat}
