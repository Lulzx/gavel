import Base

# A body a person would plausibly write: stepping into the tail forgets to
# decrement, so the count never comes back down to zero and the walk runs off
# the end of the list. Rejected by `at_succ`, whose two sides are then
# `at(xs, 1n+k)` and `at(xs, k)`: both are stuck on a variable list, and the
# body offers nothing that makes them equal. `at_len_append` fails as well --
# its induction asks for `y` at the end of `xs <> [y]`, and this body walks off
# the end and answers `0n`.
def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          at(t, 1n + k)
