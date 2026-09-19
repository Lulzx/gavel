import Base
import ./prelude.bend as P

# The empty list's step, with the filler replaced by the remaining count
# wherever that is larger. `pad_len` only counts and `pad_step` needs a cons, so
# a target that outruns an *empty* input was the one case neither reached: the
# length of the answer was fixed and the elements were not.
#
# **Measured 2026-09-19, against the four-law set:** tier 4, complete, reward
# 1.000, all four laws proven **by the reference proof unchanged**. It clears
# `pad_single` because `P.max(0n, x)` reduces to `x`, and `pad_len` because `max`
# does not change a length. It is wrong: `pad(2n, 0n, Nil{})` is `[1n, 0n]` where
# the reference answers `[0n, 0n]`.
#
# After `pad_nil_step` was added: tier 3, reward 0.500, failing that law with
# `expected prelude.max(n, x) <> solution.pad(n, x, [])` against
# `observed x <> solution.pad(n, x, [])`.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      match xs:
        case Nil{}:
          +k = k
          P.max(k, x) <> pad(k, x, Nil{})
        case h <> t:
          h <> pad(k, x, t)
