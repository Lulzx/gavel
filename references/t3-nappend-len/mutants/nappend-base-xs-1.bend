import Base
import ./prelude.bend as P

# The recursion is the reference's and the zero case answers the list instead of
# nothing: repeating a list no times gives the list. It is the plausible slip of
# the pair and it type-checks, because the two branches have the same type. The
# successor law holds -- the recursive branch is untouched -- and `nappend_zero`
# is the law that fixes the bottom of the recursion, rejecting `xs` against
# `Nil{}` for a variable `xs`.
def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      P.append(xs, nappend(xs, p))
