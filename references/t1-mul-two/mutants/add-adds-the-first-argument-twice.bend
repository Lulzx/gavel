import Base

# The `a + a` body of the law's comment: `add` doubles its first argument, so
# `S.add(x, 0n)` is `x + x` and `add_zero` fails. The law's comment records that
# this body was measured at tier 4 against the weak step law before `add_zero`
# was added; the first argument is used twice, so the signature marks it `+`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.add_plus`.
def add(+a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      +p = p
      (1n + p) + (1n + p)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      add(b, mul(p, b))
