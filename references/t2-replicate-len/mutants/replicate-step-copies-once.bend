import Base
import ./prelude.bend as P

# The step places one copy and stops recursing, so the answer has at most one
# element whatever the count. `replicate_succ` rejects it -- at `n = 0n` the law
# wants `x <> Nil{}` where the body answers `Nil{}`, and at larger `n` it wants
# the element repeated -- and `replicate_len` rejects it too.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      x <> Nil{}
