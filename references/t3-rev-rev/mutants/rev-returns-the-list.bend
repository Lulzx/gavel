import Base
import ./prelude.bend as P

# PROBE: the identity body, which both `rev_len` and `rev_rev` are satisfied by
# -- the laws' own comments say so. The load is on `rev_append`, where the
# identity gives `P.append(xs, ys) == P.append(P.rev(ys), P.rev(xs))` with both
# sides stuck on variables. Measured: caught -- `proof_tier=2 bare_tier=2`,
# nothing proven, first failure at `Policy.rev_snoc`. The refusal comes from
# the shared step the three law proofs unfold rather than from `rev_append`
# alone, so the identity body does not depend on that law being the weakest.
def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> t
