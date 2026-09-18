import Base

# The head is put back in front of the recursive call instead of onto the
# accumulator, so nothing is reversed: the body is `xs <> ys`, which the
# singleton law cannot see and the append law refuses.
# Measured: `proof_tier=3 bare_tier=2`, proven ['rev_append_single'], first
# failure at `LAWS.rev_append_append`.
def rev_append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> rev_append(t, ys)
