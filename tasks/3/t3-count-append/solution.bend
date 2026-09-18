import Base
import ./prelude.bend as P

# TODO(policy): how many times `x` occurs in `xs`, counting equal elements.
# `x` is used twice in the cons case -- in the indicator and in the recursion --
# so it is declared `+`.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  ?TODO
