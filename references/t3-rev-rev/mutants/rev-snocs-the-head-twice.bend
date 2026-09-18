import Base
import ./prelude.bend as P

# Each step puts the head down twice, so the answer is longer than the input
# whenever the input is non-empty. `h` is used twice live, hence the `+` on the
# cons pattern. The length law is stated as an equality rather than a bound, so
# it catches an over-long answer the same way it catches a short one. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.rev_snoc`.
def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.snoc(P.snoc(rev(t), h), h)
