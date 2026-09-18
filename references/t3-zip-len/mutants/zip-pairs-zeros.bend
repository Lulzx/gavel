import Base
import ./prelude.bend as P

# The pairing is by position but the values are discarded: every pair is
# `{0n, 0n}`, so the result has exactly the right length and none of the input.
# The two nil laws hold and the length law counts, which is why the pairing law
# is the one that has to look inside a pair. Measured: `proof_tier=3
# bare_tier=2`, first failure at `LAWS.zip_cons`.
def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  match xs:
    case Nil{}:
      Nil{}
    case hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.Mk{0n, 0n} <> zip(tx, ty)
