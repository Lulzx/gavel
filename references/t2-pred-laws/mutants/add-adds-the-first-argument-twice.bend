import Base

# Each step adds the successor twice, so `add(a, b)` is `a + a + b`: the
# addend is counted once too often per step. `add_one` asks for `1n+x` and the
# body leaves a term with two copies of `x` in it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['pred_succ'], first failure
# at `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + 1n + add(p, b)

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p
