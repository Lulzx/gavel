import Base
import ./prelude.bend as P

# A "difference" that always cancels: both differences are of a number with
# itself, so the body is definitionally `0n` -- it does not use the two numbers
# as a pair at all. Rejected by `absdiff_zero_left`: `absdiff(0n, 1n+q)` is
# `0n` where the law wants `1n+q`. `absdiff_zero_right` fails on the same body.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  P.sub(a, a) + P.sub(b, b)
