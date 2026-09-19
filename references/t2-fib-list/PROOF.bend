import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The first argument is the literal `0n`, so the match takes its empty case and
# the walk answers the empty list: both sides are `Nil{}`.
def L.fib_list_zero():
  {==}

# The first argument is `1n + n`, which the match steps into its successor case:
# the number in hand is `0n` and the walk continues from the pair `(1n, 1n)`.
# Both sides are that same term.
def L.fib_list_succ(n):
  {==}

# The pair in hand is never read when there is nothing to emit, so both sides are
# `Nil{}`.
def L.fib_go_zero(a, b):
  {==}

# The count is `1n + k`, so the match steps into its successor case: the number
# in hand is emitted and the pair slides to `(b, a + b)`. Both sides are that
# same term.
def L.fib_go_succ(k, a, b):
  {==}

# The count is a variable, so the case split is on it. At `0n` the walk answers
# the empty list, whose length is `0n`. At `1n + kp` the number in hand is
# emitted in front of the walk one number along, so the length is one more than
# the length of the rest; the hypothesis at `kp`, with the pair slid to
# `(b, a + b)`, is that the rest holds `kp` numbers, and one more than `kp` is
# `1n + kp`.
def L.fib_go_len(k, a, b):
  match k:
    case 0n:
      {==}
    case 1n+kp:
      %L.fib_go_len(kp, b, a + b) : {1n + P.len(S.fib_go(kp, b, a + b)) == 1n + _ : Nat}
      {==}

# Every term is closed, so every match reduces: the walk emits `0n`, then `1n`,
# then the sum of the two, and what is left is `[0n, 1n, 1n]` against itself.
def L.fib_list_three():
  {==}
