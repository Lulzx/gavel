import Base
import ./prelude.bend as P

# TODO(policy): implement. `replicate_each(xs, n)` repeats every element of `xs`
# `n` times in place, keeping the order of the elements and the order within each
# run of copies:
#
#   replicate_each([1n, 2n], 3n)  ==  [1n, 1n, 1n, 2n, 2n, 2n]
#   replicate_each([5n], 2n)      ==  [5n, 5n]
#   replicate_each([1n, 2n], 0n)  ==  []
#   replicate_each([], 3n)        ==  []
#
# The match is on the list, so that each element is repeated where it stands: an
# empty list answers the empty list, and a cons repeats its head `n` times and
# puts the copies of its tail after them. The prelude has `P.rep(x, k)`, which is
# `k` copies of one number, and `P.append(xs, ys)`, which is one list after
# another -- the answer is the first of those at the head, and the second to
# attach it to the answer for the tail.
#
# The list is the argument the recursion shrinks, so it comes first: the checker
# reads a recursive call's arguments left to right and asks that each be passed
# on unchanged until one shrinks. `n` does not change at all, and it is read
# twice on the non-empty path -- once for the head's copies and once for the
# tail's -- so it is declared reusable, `+n`, in the reference.
def replicate_each(xs: List<&2, Nat>, +n: Nat) -> List<&2, Nat>:
  ?TODO
