import Base
import ./prelude.bend as P

# TODO(policy): implement. `nat_sqrt(n)` is the largest `k` whose square is at
# most `n`, so the answer is the number of squares `1n, 4n, 9n, ...` that still
# fit under `n`:
#
#   nat_sqrt(0n)  ==  0n
#   nat_sqrt(4n)  ==  2n
#   nat_sqrt(9n)  ==  3n
#   nat_sqrt(8n)  ==  2n
#
# The walk is on `n`: nothing below `1n` has a square under it, so `0n` answers
# `0n`. For a successor, adding one to `n` raises the square root by at most one,
# so the answer is the answer for `n - 1` plus one exactly when the square of the
# *next* number still fits under this `n` -- which is the answer for `n - 1` plus
# the decision `P.le_ind(a, b)` makes, `1n` when `a` is at most `b` and `0n`
# otherwise. `Nat.mul` builds the square and `Nat.add` adds the decision; there is
# no other arithmetic in the task.
#
# The successor argument is the one the recursion shrinks, and the answer for
# `n - 1` is read more than once on that path -- it is the base of the sum and it
# is squared to test the next square -- so bind it once and reuse the name, rather
# than calling `nat_sqrt` once per read: a second call would double the work at
# every step and the reference is measured against a latency budget.
def nat_sqrt(n: Nat) -> Nat:
  ?TODO
