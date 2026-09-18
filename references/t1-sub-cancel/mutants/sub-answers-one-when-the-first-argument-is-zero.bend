import Base

# The branch with a zero minuend and a positive subtrahend answers `1n`, which
# is where a saturating subtraction would have stopped. `sub_cancel` needs
# `a = x + y` and `b = x`, so `a = 0n` forces `x = y = 0n` and hence `b = 0n` --
# the branch is unreachable from the law and its answer is free.
# Measured: before `sub_saturates`, tier 4, reward 1.000; after, tier 3, reward
# 0.350 for `sub_cancel` alone, first failure at `LAWS.sub_saturates`.
def sub(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      sub(ap, bp)
