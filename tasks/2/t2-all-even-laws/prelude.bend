import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of what counts as even, so the policy's `all_even`
# may lean on these. `is_even_b` is `Bool`-valued, so the law's right-hand
# side is a conjunction.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def is_even_b(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      match p:
        case 0n:
          False{}
        case 1n+q:
          is_even_b(q)
