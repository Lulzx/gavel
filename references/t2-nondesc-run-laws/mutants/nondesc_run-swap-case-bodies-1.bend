import Base
import ./prelude.bend as P

def nondesc_run(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      P.rl_step(x, t, nondesc_run(t))

    case +x <> +t:
      0n
