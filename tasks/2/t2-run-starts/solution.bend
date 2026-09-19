import Base
import ./prelude.bend as P

# TODO(policy): implement. `run_starts(xs)` is the list of positions at which a
# new run of equal elements begins, in increasing order. An empty list has no
# positions. A non-empty list always opens a run at `0n` -- without an element
# before it, its first element cannot equal one -- and the rest of the positions
# are what the walk finds in the tail, which is handed the first element as the
# one before it and `1n` as the position it starts reading at.
def run_starts(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. `run_starts_go(rest, prev, i)` walks `rest` carrying
# the element before it, `prev`, and the position `i` that `rest`'s head sits
# at. The empty list answers nothing. A cons cell compares its head with `prev`
# -- the prelude's `same` -- and hands the answer to `P.put_start` together with
# the position: the position opens a run when the answer is `False{}` and is
# passed over when it is `True{}`. Either way the walk continues on the tail at
# the next position, with the head as the element before it. The position is
# read twice in that step -- once as the position to put and once to compute the
# next one -- and the head is read twice as well, so both are declared reusable:
# `+i` and `+h`.
def run_starts_go(rest: List<&2, Nat>, prev: Nat, +i: Nat) -> List<&2, Nat>:
  ?TODO
