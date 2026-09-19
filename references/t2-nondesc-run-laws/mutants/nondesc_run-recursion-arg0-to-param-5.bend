import Base
import ./prelude.bend as P

def nondesc_run(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +x <> +t:
      P.rl_step(x, t, nondesc_run(xs))
