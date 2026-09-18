import Base
import ./prelude.bend as P

# The head is added as its own value rather than as its oddness, so the answer
# is the sum of the elements. It agrees with the reference on lists of `0n`s
# and `1n`s, and `count_odd_snoc` refuses it at a variable head, where the
# left-hand side is `P.is_odd(x)` and the right is `x`.
# Measured: `proof_tier=3 bare_tier=2`, proven ['count_odd_nil'], first
# failure at `LAWS.count_odd_snoc`.
def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + count_odd(t)
