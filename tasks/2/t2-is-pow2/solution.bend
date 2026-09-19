import Base
import ./prelude.bend as P

# TODO(policy): implement. `is_pow2(w, n)` says whether `n` is a power of two,
# looking at at most `w` halvings. The outer match is on the width, because the
# argument that shrinks has to come first and `n` is halved rather than taken
# apart. `0n` of width is `False{}` whatever the number is: it has run out of
# halvings without reaching `1n`. Above zero, match the number -- zero is
# `False{}`, one is `True{}`, and anything else is `P.is_even_b(n)` and the same
# question at half of `n`, one unit of width shorter. `n` is read twice in that
# branch, so it is declared reusable: `+n`. The width has to be at least
# `log2(n) + 1n` to reach the `1n` case; the laws state the width they mean.
def is_pow2(w: Nat, +n: Nat) -> Bool:
  ?TODO
