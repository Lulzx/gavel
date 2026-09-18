import Base

# The recursion drops the head: `append(xs, ys)` is `ys` for every `xs`, which
# keeps the base case and only ever discards. It is the body that forgets to
# cons the head back on.
# Measured: `proof_tier=3 bare_tier=2`, proven ['len_cons'], first failure
# at `LAWS.len_append`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
