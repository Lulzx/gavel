import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the single parameter: `0n` answers `1n`,
# and a successor answers itself times the factorial of its predecessor. The
# parameter is read twice in the step -- once as the scrutinee of the match and
# once as the number being multiplied -- so it is marked reusable.
def fact(+n: Nat) -> Nat:
  ?TODO
