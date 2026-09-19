import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `longest_run_len` takes the empty case of its own match, so both sides are
# `0n` by unfolding alone.
def L.longest_run_len_nil():
  {==}

# The singleton is a cons cell whose tail is empty: the prelude's block starting
# at its first element is `1n`, the recursion on the empty tail is `0n`, and
# `Nat.max` of `1n` against `0n` computes to `1n`.
def L.longest_run_len_single(x):
  {==}

# The step of the definition written out, with both sides reducing to the same
# `Nat.max` of the prelude's block and the tail's own answer.
def L.longest_run_len_cons(h, t):
  {==}

# Two equal elements are a block of two, and the tail's own answer is the one
# element it holds: `Nat.max` of `2n` against `1n` is `2n`.
def L.longest_run_len_one_pair():
  {==}

# Three elements with no equal neighbours: every block has length one, so every
# `Nat.max` in the unfolding is against `1n` and the answer is `1n`.
def L.longest_run_len_no_pair():
  {==}
