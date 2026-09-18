import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of what counts as a zero, so the policy's
# `elem_zero` may lean on these. `is_zero_b` is `Bool`-valued, so the law's
# right-hand side is a disjunction.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def is_zero_b(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      False{}
