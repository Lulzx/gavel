import Base

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# Immutable, and owned by the task rather than the policy: the laws are stated in terms of `append` and
# of what counts as a multiple of three, so the policy's `all_mult3` may lean on these.
# `is_mult3_b` is `Bool`-valued, so the law's right-hand side is a conjunction.
def is_mult3_b(n: Nat) -> Bool:
  Nat.is_eq(Nat.mod(n, 3n), 0n)
