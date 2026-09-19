import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The width is the literal `0n`, so the outer match takes its empty case and
# both sides are `0n`.
def L.log2_go_no_fuel(n):
  {==}

# The width is a variable, so the outer match is stuck and the law needs the
# induction. At zero the outer match takes the empty case. At `1n + w` it steps
# to the successor case and the inner match reads the literal `0n`, which is its
# zero case; both land on `0n` without recursing, so neither arm calls the
# hypothesis.
def L.log2_go_zero(w):
  match w:
    case 0n:
      {==}
    case 1n+wp:
      {==}

# The width is `1n + w`, which the outer match steps into its successor case
# with `p` bound to `w`; the inner match then reads `1n`, which is `1n + 0n`,
# its own case. Both sides are `0n`. No induction: the successor is a term, not
# a variable.
def L.log2_go_one(w):
  {==}

# The outer match steps on `1n + w` and the inner match steps on `1n + 1n + q`,
# so the two sides are the same one added to the same halved argument.
def L.log2_go_step(w, q):
  {==}

# `nat_log2` has no match of its own, so it unfolds to the walk started at `n`
# whatever `n` is.
def L.nat_log2_handoff(n):
  {==}

# Both sides are numerals, so the checker walks them out.
def L.nat_log2_zero():
  {==}

# Both sides are numerals, so the checker walks them out.
def L.nat_log2_one():
  {==}

# Both sides are numerals, so the checker walks them out.
def L.nat_log2_two():
  {==}

# Both sides are numerals, so the checker walks them out.
def L.nat_log2_seven():
  {==}

# Both sides are numerals, so the checker walks them out.
def L.nat_log2_eight():
  {==}
