import Base
import ./prelude.bend as P

# TODO(policy): implement the cascade. `clamp(x, lo, hi, klo, khi)` answers `x`
# held inside the range from `lo` up to `hi`: `lo` when the first decision is
# `True{}` (the value is at or below the lower bound), and otherwise `hi` when
# the second decision is `True{}` (the value is above the upper bound) and `x`
# when it is not. The two decisions are the caller's -- `P.le(x, lo)` and
# `P.le(hi, x)` -- because a `match` cannot take a computed comparison as its
# scrutinee, so they arrive as arguments and the body case-splits on those.
def clamp(x: Nat, lo: Nat, hi: Nat, klo: Bool, khi: Bool) -> Nat:
  ?TODO
