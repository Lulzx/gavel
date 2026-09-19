import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nat.add` has no zero lemma in `Base`, and the walk's last window is added to
# nothing, so the content law below meets `n + 0n` with `n` a variable. This is
# the missing lemma, in the direction the rewrite needs: the left side is the
# bare term, so a goal holding `n + 0n` can be rewritten to the bare term.
# The induction is on the left argument of `+`, which is the argument `Nat.add`
# itself matches on.
def Policy.add_zero(x: Nat) -> {x == x + 0n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + p == 1n + _ : Nat}
      {==}

# `0n` is the answer of the first case, and the empty list is the argument of
# that case.
def L.count_peaks_nil():
  {==}

# The list reaches the outer match's cons case and its tail reaches the inner
# match's empty case, which answers `0n`.
def L.count_peaks_single(x):
  {==}

# Both sides are the walk opened on the same tail with the same two elements
# behind it: the answer spends its first two elements on the first window and
# hands over the rest.
def L.count_peaks_step(h, j, u):
  {==}

# The walk's first case answers `0n` before looking at the two elements it was
# carrying.
def L.peaks_go_nil(prev, h):
  {==}

# The front of the remaining list is the second neighbour of the element in
# hand, so the walk adds that element's indicator and carries on with the two
# elements behind the new one. Both sides are the same addition in the same
# order.
def L.peaks_go_cons(prev, h, j, u):
  {==}

# Three closed strides of the walk: the last window is added to the walk's empty
# answer, so the left side is `P.peak_at(x, y, z) + 0n` with all three elements
# variables and the addition stuck. The zero lemma turns it into the bare
# indicator, which is what the right side already is.
def L.count_peaks_three(x, y, z):
  %Policy.add_zero(P.peak_at(x, y, z)) : {_ == P.peak_at(x, y, z) : Nat}
  {==}
