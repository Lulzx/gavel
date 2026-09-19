import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The arithmetic the content law needs, and the only lemma the policy writes: `a`
# is at most `a + b`, so `P.le_ind` answers `1n` on that pair. The proof is an
# induction on `a`, and it needs the case split on `b` because `le_ind` reads both
# its arguments: at `0n` the first component takes the `0n` cases and the answer is
# `1n` whether the second component is `0n` or a successor, and at a successor the
# pair reduces to the smaller pair, which is the hypothesis.
def Policy.le_self_add(a: Nat, +b: Nat) -> {P.le_ind(a, a + b) == 1n : Nat}:
  match a:
    case 0n:
      match b:
        case 0n:
          {==}
        case 1n+bp:
          {==}
    case 1n+ap:
      %Policy.le_self_add(ap, b) : {P.le_ind(ap, ap + b) == _ : Nat}
      {==}

# The argument is the literal `0n`, so the outer match takes the empty case and
# answers `0n`: both sides are `0n`.
def L.nat_sqrt_zero():
  {==}

# The argument is `1n + n`, so the outer match takes the successor case and the
# answer is the bound `np`-answer plus the decision `P.le_ind` makes; the bound is
# a name for `nat_sqrt(np)` and unfolding it is the whole step. Both sides are the
# same term.
def L.nat_sqrt_succ(n):
  {==}

# The answer at `n` is at most the answer at `1n + n`, which is the answer at `n`
# plus one or nothing. The lemma above is written with the `1n` on its right, so
# the step lands on the right-hand side of this law and the two sides become the
# same term.
def L.nat_sqrt_mono(n):
  %Policy.le_self_add(S.nat_sqrt(n), P.le_ind(Nat.mul(1n + S.nat_sqrt(n), 1n + S.nat_sqrt(n)), 1n + n)) : {P.le_ind(S.nat_sqrt(n), Nat.add(S.nat_sqrt(n), P.le_ind(Nat.mul(1n + S.nat_sqrt(n), 1n + S.nat_sqrt(n)), 1n + n))) == _ : Nat}
  {==}

# The argument is closed and a square: the recursion walks down to `0n` and every
# decision along the way is a comparison of closed numbers, so the answer reduces
# to `2n` against itself.
def L.nat_sqrt_four():
  {==}

# The argument is closed and one below a square: `3n * 3n` is `9n`, which does not
# fit under `8n`, so the last decision goes the other way and the answer is `2n`
# against itself.
def L.nat_sqrt_eight():
  {==}

# The argument is closed and exactly the square of `3n`, so the last decision has
# nothing to spare: `3n * 3n` is `9n`, which fits under `9n`, and the answer is
# `3n` against itself.
def L.nat_sqrt_nine():
  {==}
