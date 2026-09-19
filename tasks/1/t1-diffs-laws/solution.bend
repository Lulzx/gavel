import Base
import ./prelude.bend as P

# TODO(policy): implement. `diffs(xs)` is the successive differences of `xs`:
# one fewer element than `xs`, each one the next element minus the one before
# it. The empty list and the one-element list have nothing to subtract, so both
# answer `Nil{}`, and a list of two or more elements answers the difference of
# its first two elements in front of the differences of its tail. `P.sub` is the
# prelude's truncated subtraction.
def diffs(xs: List<Nat>) -> List<Nat>:
  ?TODO
