import Base

# The successor is applied twice where once was asked for: the step counts the
# element twice, a plausible slip at the boundary of a unary encoding.
# Rejected by `map_cons`, whose left-hand side reduces to
# `(1n+1n+h) <> map(t)` where its right-hand side is `(1n+h) <> map(t)`.
# `len_map_cons` holds of the body and its helper still checks -- a map that
# replaces one element with one element leaves the length alone -- so the law
# that names the function is the one that rejects this body.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def map(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n+1n+h) <> map(t)
