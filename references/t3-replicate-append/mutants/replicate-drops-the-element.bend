import Base

# The cons case recurses without putting the element down first, so the run is
# always empty. `replicate_len` fails at every non-zero count; `replicate_single`
# fails too. Same family as the generated constant body, but written as a
# recursion that is present and never used, which is the mistake a policy
# actually makes when the head is dropped from a cons step. Measured:
# `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `Policy.replicate_snoc`.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+k:
      replicate(k, x)
