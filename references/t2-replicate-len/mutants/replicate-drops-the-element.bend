import Base
import ./prelude.bend as P

# The step recurses but never places the element, so the count is consumed and
# the answer is always empty. `replicate_succ` rejects it -- at `n = 0n` the law
# wants `x <> Nil{}` where the body answers `Nil{}` -- and `replicate_len`
# rejects it too, since it asks for `n` elements.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      replicate(k, x)
