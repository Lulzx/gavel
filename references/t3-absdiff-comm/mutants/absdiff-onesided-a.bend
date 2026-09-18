import Base
import ./prelude.bend as P

# A body that takes only one of the two differences: plausible if the author
# thought `a - b` is the distance. Rejected by `absdiff_zero_left`:
# `sub(0n, 1n+q)` reduces to `0n` where the law wants `1n+q`. `absdiff_comm`
# fails on the same body. (Distinct from the generated `swap-args` files, which
# square the swapped difference.)
def absdiff(+a: Nat, +b: Nat) -> Nat:
  P.sub(a, b)
