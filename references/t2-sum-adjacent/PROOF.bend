import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `Nil{}` is the walk's first case, whatever the tail of the list it was handed.
def L.sum_adjacent_nil():
  {==}

# The single element reaches the outer cons case and its tail meets the inner
# match's empty case, which answers `Nil{}`.
def L.sum_adjacent_single(x):
  {==}

# Both sides are the same sum in front of the same call on the same tail: the
# element after the front one is the second half of this pair and the first half
# of the next.
def L.sum_adjacent_cons(h, k, u):
  {==}

# The pair is added and then the walk meets the one-element tail, whose own
# answer is `Nil{}`; both sides compute to the same single cell.
def L.sum_adjacent_pair(x, y):
  {==}

# An induction on the tail. The empty tail is the walk's own empty case on both
# sides, and in the cons case the answer is one cell in front of the walk on the
# shorter tail, so the hypothesis says the same fact one element along and the
# `1n +` that `P.len` puts in front of it is the same on both sides. Both sides
# of the goal do reduce to that shape before the hypothesis is applied, because
# the walk is stuck on the two variables of the pair and not on the list.
def L.sum_adjacent_len(xs, x):
  match xs:
    case Nil{}:
      {==}
    case +k <> +u:
      %L.sum_adjacent_len(u, k) : {1n + P.len(S.sum_adjacent(k <> u)) == 1n + _ : Nat}
      {==}

# Both sides are closed, so every match steps and every recursion terminates:
# the walk reads the two pairs off the list and stops at the one-element tail.
def L.sum_adjacent_three():
  {==}
