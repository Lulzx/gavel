import Base
import ./prelude.bend as P

# TODO(policy): implement. `delete(x, xs)` removes the *first* element of `xs`
# that is `x` and keeps everything else, in the order it was in; if `x` does not
# occur at all the whole list comes back. Recurse on the list: the empty list
# has nothing to remove, and a cons cell is compared with `x` and either answers
# its tail -- dropping itself -- or keeps its head and removes from the tail.
#
# The comparison is `P.eq(h, x)` and the decision is *taken* by `P.at_if`, which
# matches on the value it is given: a match cannot scrutinise a computed value
# in place, so the comparison is passed on rather than taken here. The target is
# read twice in the step, once into the comparison and once into the recursive
# call, so it is declared reusably (`+x`), and the tail is read twice as well --
# it is one of the two answers to the decision and it is what the recursion
# runs on -- so it carries a `+` in the pattern.
def delete(+x: Nat, xs: List<Nat>) -> List<Nat>:
  ?TODO
