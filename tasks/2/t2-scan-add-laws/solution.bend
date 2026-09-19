import Base
import ./prelude.bend as P

# TODO(policy): implement. `scan_add(xs, acc)` is the running totals of `xs`
# starting from `acc`: the empty list produces no totals, and a cons cell emits
# the accumulator with its head added, then continues from that same value.
def scan_add(xs: List<Nat>, +acc: Nat) -> List<Nat>:
  ?TODO
