import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; `zip3` is what the policy writes.

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The smallest of three counts. It steps one successor off all three at once,
# and it matches them one at a time, so a goal whose three arguments are not all
# successors computes: the first argument that is `0n` picks an `0n` answer
# without the others being looked at. Three inputs of different lengths end
# where the shortest of them ends, and this is the function that says which one
# that was.
def min3(a: Nat, b: Nat, c: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+ap:
      match b:
        case 0n:
          0n
        case 1n+bp:
          match c:
            case 0n:
              0n
            case 1n+cp:
              1n + min3(ap, bp, cp)
