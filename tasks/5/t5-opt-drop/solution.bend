import Base
import ./prelude.bend as P

# TODO(policy): the accumulator after running `prog` from `s`. A program is
# read left to right, so the first instruction is applied first.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  ?TODO

# TODO(policy): `prog` with the instructions that cannot change its meaning
# removed. `z` is what the caller knows about the accumulator where `prog`
# starts -- true when it holds zero -- and a caller that knows nothing passes
# `False{}`.
def opt(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  ?TODO
