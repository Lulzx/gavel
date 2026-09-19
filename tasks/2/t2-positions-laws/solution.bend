import Base
import ./prelude.bend as P

# TODO(policy): implement. `positions(x, xs)` collects the *positions* at which
# `x` occurs in `xs`, counting from `0n` and in the order they occur:
# `positions(5n, [5n, 4n, 5n])` is `[0n, 2n]`. Recurse on the list: the empty
# list has no positions, and a cons cell either has its head at position `0n` --
# followed by the positions of the tail, each shifted along by one -- or has
# nothing at `0n` and is only the shifted positions of the tail.
#
# The comparison is `P.eq(h, x)` and the decision is *taken* by `P.at_if`, which
# matches on the value it is given: a match cannot scrutinise a computed value
# in place, so the comparison is passed on rather than taken here. The target is
# read twice in the step, once into the comparison and once into the recursive
# call, so it is declared reusably (`+x`), and the tail is read twice as well --
# it is what the recursion runs on, and the shifted positions are one of the two
# answers -- so it carries a `+` in the pattern. `P.inc_all` shifts a list of
# positions by one.
def positions(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
