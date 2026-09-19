import Base
import ./prelude.bend as P

# TODO(policy): implement. `nondesc_run(xs)` answers the length of the longest
# prefix of `xs` whose elements do not decrease: how far a walk from the front
# gets before two neighbouring elements are out of order. Recurse on `xs`:
# `Nil{}` answers `0n`, and a cons cell hands the head, the tail and the tail's
# own answer to `P.rl_step`, which is where the comparison lives. `P.le`,
# `P.len`, `P.rl_put` and `P.rl_step` are the prelude's and are immutable.
def nondesc_run(xs: List<&2, Nat>) -> Nat:
  ?TODO
