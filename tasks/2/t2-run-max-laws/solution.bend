import Base
import ./prelude.bend as P

# TODO(policy): implement. `run_max(xs, m)` is the running maxima of `xs`
# starting from `m`: the empty list produces no entries, and a cons cell emits
# the larger of the running value and its head, then continues from that same
# value.
def run_max(xs: List<Nat>, +m: Nat) -> List<Nat>:
  ?TODO
