import Base
import ./prelude.bend as P

# Every non-empty list answers `Some{0n}` at every index: the branch is right
# and the value never is, since the body does not read the list at all. It is
# the one body in the corpus that is false of every law but the domain law: the
# step law holds no more than the first-element law does, because the walk
# itself is gone, and an out-of-range index on a cons still gets `Some{0n}`.
# The domain law is the exception and it is a narrow one -- `Some{}` is the
# branch it asks for -- but its proof is a recursion on the index, and a body
# that never recurses cannot follow it, so it fails to discharge as well.
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  match k:
    case 0n:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{0n}
    case 1n+p:
      match xs:
        case Nil{}:
          None{}
        case h <> t:
          Some{0n}
