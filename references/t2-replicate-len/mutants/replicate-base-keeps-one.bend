import Base
import ./prelude.bend as P

# An off-by-one at the base: zero copies are answered with one copy. The step is
# untouched, so `replicate_succ` holds -- `x <> replicate(k, x)` is exactly what
# the law's right-hand side asks for -- and it is `replicate_len` that rejects
# it: at `n = 0n` the body's answer has one element where the law wants none.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      x <> Nil{}
    case 1n+k:
      x <> replicate(k, x)
