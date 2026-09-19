import Base
import ./prelude.bend as P

# TODO(policy): implement. `rotate(n, xs)` moves the first `n` elements of `xs`
# to the back, one at a time. Recurse on `n`: `0n` answers `xs` itself, and
# `1n + p` takes the head off the list and recurses on `p` with that head
# appended to the tail -- so the head comes round to the end and no element is
# lost, however large `n` gets. The empty list is the one input with nothing to
# move, and it answers `Nil{}` at every `n`; that is why the successor case has
# to look at `xs` before it recurses. `P.append(xs, ys)` is the prelude's
# append.
def rotate(n: Nat, +xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
