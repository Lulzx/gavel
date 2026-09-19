import Base
import ./prelude.bend as P

# TODO(policy): implement. `insert_at(n, xs, y)` puts `y` into `xs` at position
# `n`, counting from the front, and leaves `xs` alone otherwise. Recurse on the
# count: `0n` puts `y` in front of the whole list, and `1n + p` walks one step
# into the list and keeps the head it passed. When the count runs past the end
# of the list there is no element to stand in front of, so `y` goes on the end.
def insert_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  ?TODO
