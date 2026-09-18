import Base

# The run has the right length and the wrong element: the cons case puts `0n`
# in instead of `x`, so the policy is a producer of zeros. `replicate_len` and
# `replicate_append` both count and both hold; `rev_replicate` holds as well,
# since a run of zeros reads the same backwards. The single law is the only one
# that pins the element, which is what its comment says it is for. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.replicate_snoc` -- the shared step the four law proofs unfold.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      0n <> replicate(k, x)
