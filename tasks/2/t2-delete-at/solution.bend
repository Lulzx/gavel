import Base
import ./prelude.bend as P

# TODO(policy): implement. `delete_at(n, xs)` drops the element at position `n`
# and keeps everything else. Recurse on `n`: at `0n` the answer is the tail of
# `xs`, and at `1n + p` the head survives and the recursion goes to the tail.
# A count past the end has nothing to drop and answers `Nil{}`. `P.take` and
# `P.drop` come from the prelude.
def delete_at(n: Nat, xs: List<Nat>) -> List<Nat>:
  ?TODO
