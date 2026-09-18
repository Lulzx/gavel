import Base

# The head is consed onto `ys` before the recursive call instead of after it,
# so the first list comes back in reverse: `append(xs, ys)` is `rev(xs) <> ys`.
# This is the escape probe for the law set. It preserves the length exactly, so
# `len_append` is true of it at every concrete list; what refuses it is that
# `len_append`'s proof inducts over `append` and this body's recursion does not
# match the induction the law is proved by -- as measured below, it fails it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['len_cons'], first failure
# at `LAWS.len_append`.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      append(t, h <> ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
