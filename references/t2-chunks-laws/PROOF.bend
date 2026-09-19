import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The entry point looks at the list first and the list is `Nil{}`, so the left
# side is `Nil{}` without the size being consulted.
def L.chunks_nil(n):
  {==}

# Inductive in `xs`. The empty case is the same first arm; the step reaches the
# `0n` arm of the size and answers `Nil{}` there.
def L.chunks_zero(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# `x <> Nil{}` is a cons cell and the size is the literal `1n`, so the first
# element opens a block, the list is empty behind it, and the block is closed.
def L.chunks_single(x):
  {==}

# Both sides are literals, so the checker computes them.
def L.chunks_three_by_two():
  {==}

# `x <> xs` is a cons cell and `1n + k` is a successor, so the worker takes the
# arm that adds the element to the block being built. Both sides are that same
# self-call.
def L.chunks_go_fill(x, xs, n, k, cur, out):
  {==}

# `x <> xs` is a cons cell and the slot count is the literal `0n`, so the worker
# takes the arm that closes the block and opens a new one. The size below it is
# what the new block has left.
def L.chunks_go_close(x, xs, n, cur, out):
  {==}
