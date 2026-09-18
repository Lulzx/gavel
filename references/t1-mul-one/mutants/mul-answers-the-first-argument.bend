import Base

# `mul` answers its first argument, so `mul_one`'s goal becomes `x == x` -- a
# statement the body satisfies -- and `mul_succ` is the law whose two sides the
# body separates (`1n+x` against `S.add(y, x)`). The recursion is present and
# unused, and the second argument is read by neither branch. The refusal below
# is reported against `mul_one` rather than `mul_succ` because the body does not
# follow the reference's step, so the per-law proofs stop at their shared
# unfolding before either law's statement is decided.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.mul_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + p
