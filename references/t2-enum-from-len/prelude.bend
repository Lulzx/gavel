import Base

# Immutable, and owned by the task rather than the policy: the third law is
# stated in terms of `len`, so the policy's `enum_from` may lean on this one.
# It matches on its first argument, which is what makes that law's left-hand
# side stuck for a variable count -- the run `enum_from(n, a)` does not reduce
# until `n` is a successor, so the induction is the proof.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
