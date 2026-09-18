import Base

# Immutable, and owned by the task rather than the policy: the laws are stated
# in terms of `append` and of `pred`, so the policy's `pred_all` may lean on
# both. `append` matches on its first argument, which is what makes the second
# law inductive.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p
