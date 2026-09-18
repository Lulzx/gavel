import Base

# Wrong: adds the head's value instead of one, so `len` answers the sum. Both
# laws see it: `len_cons` says the increment is `1n` whatever the element is,
# and `len_single` is the closed anchor (`len([x])` comes back `x`).
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + len(t)
