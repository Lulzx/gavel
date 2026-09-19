import Base
import ./prelude.bend as P

# TODO(policy): implement. `half(n)` is `n` divided by two, rounding down.
# Recurse on `n`: `0n` answers `0n`, `1n` answers `0n`, and any larger number
# drops two at a time -- `1n + (1n + p)` answers `1n + half(p)` -- because two
# off the input is one off the answer.
def half(n: Nat) -> Nat:
  ?TODO
