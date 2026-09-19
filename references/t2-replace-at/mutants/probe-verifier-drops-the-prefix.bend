import Base
import ./prelude.bend as P

# PROBE. `replace_at` walks the count into the list and replaces the element it
# lands on, but it forgets to rebuild the prefix it walked past: the successor
# case answers the recursion instead of the head consed onto it. It is a whole,
# plausible walk over the count, and it is right whenever the count is `0n` --
# which is exactly the answer arm a step rewrite in the generated corpus never
# reaches.
def replace_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          y <> t
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          replace_at(p, t, y)
