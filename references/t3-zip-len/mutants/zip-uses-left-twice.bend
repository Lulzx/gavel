import Base
import ./prelude.bend as P

# Both components come from the left list, so the result is the right length and
# every element of `ys` is thrown away. `hx` is used twice live, which is why the
# cons pattern carries `+`. The two nil laws and the length law all hold -- the
# left list is the one that runs out first here and the count is still `min` --
# and the pairing law fails at its own cons case, where the second component is
# a variable. Measured: `proof_tier=3 bare_tier=2`, first failure at
# `LAWS.zip_cons`.
def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  match xs:
    case Nil{}:
      Nil{}
    case +hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.Mk{hx, hx} <> zip(tx, ty)
