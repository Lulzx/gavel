import Base
import ./prelude.bend as P

# TODO(policy): implement. `replace_at(n, xs, y)` puts `y` at position `n` of
# `xs`, counting from the front, and answers `xs` unchanged when `n` is past the
# last position. Recurse on the count: at `0n` the head is dropped and `y` takes
# its place, and at `1n + p` the head survives and the recursion goes to the
# element behind it. Where the count runs out the empty list is the answer, so
# everything the walk already passed comes back unchanged. The prelude adds
# nothing: the laws speak in `List<Nat>` terms only.
def replace_at(n: Nat, xs: List<Nat>, y: Nat) -> List<Nat>:
  ?TODO
