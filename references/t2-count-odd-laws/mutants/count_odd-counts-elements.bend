import Base
import ./prelude.bend as P

# The step adds `1n` for every element instead of `P.is_odd(h)`, so `count_odd`
# is the length of the list. The empty case is right, so `count_odd_nil`
# holds and only `count_odd_snoc` -- whose right-hand side is `P.is_odd(x)`,
# stuck on a variable -- can refuse it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['count_odd_nil'], first
# failure at `LAWS.count_odd_snoc`.
def count_odd(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + count_odd(t)
