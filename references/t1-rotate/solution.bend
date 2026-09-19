import Base
import ./prelude.bend as P

# The reference solution: step on `n`, and in the successor case step on the
# list as well. The head is cut off and appended to the tail, so the element
# moves to the back rather than off the end, and the remaining rotations carry
# on with one fewer step. `xs` is read in the `0n` case and again in the
# successor case, so it is declared reusably (`+xs`).
def rotate(n: Nat, +xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          rotate(p, P.append(t, h <> Nil{}))
