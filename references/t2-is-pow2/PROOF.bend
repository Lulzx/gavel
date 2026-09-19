import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The width is the literal `0n`, so the outer match takes its empty case and
# both sides are `False{}`.
def L.is_pow2_no_fuel(n):
  {==}

# The width is a variable, so the outer match is stuck and the law needs the
# induction. At zero the outer match takes the empty case. At `1n + w` it steps
# to the successor case and the inner match reads the literal `0n`, which is its
# zero case; both land on `False{}`.
def L.is_pow2_zero(w):
  match w:
    case 0n:
      {==}
    case 1n+wp:
      {==}

# The width is `1n + w`, which the outer match steps into its successor case
# with `p` bound to `w`; the inner match then reads the literal `1n`, and the
# number `1n` is `1n + 0n`, which is its own case. Both sides are `True{}`. No
# induction: the successor is a term, not a variable.
def L.is_pow2_one(w):
  {==}

# The outer match steps on `1n + w` and the inner match steps on `1n + 1n + q`,
# so the two sides are the same parity test against the same halved number.
def L.is_pow2_step(w, q):
  {==}

# Both sides are closed, so the walk computes: `4n` is even and halves to `2n`,
# which is even and halves to `1n`, which is the answer `True{}` -- three units
# of width, and the last one is spent on the `1n` case rather than recursing.
def L.is_pow2_four():
  {==}

# The same computation one step further out: `6n` halves to `3n`, which is odd,
# so the conjunction is `False{}` before the `1n` case is ever reached.
def L.is_pow2_six():
  {==}
