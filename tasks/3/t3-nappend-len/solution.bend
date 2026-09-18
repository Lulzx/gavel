import Base
import ./prelude.bend as P

# TODO(policy): `xs` repeated `n` times, concatenated. `n` is `0n` on the empty
# case and counts down on every step, so the recursion is structural on `n` and
# the list it repeats is carried unchanged -- which is why `xs` is `+` and `n`
# is not.
def nappend(+xs: List<&2, Nat>, n: Nat) -> List<&2, Nat>:
  ?TODO
