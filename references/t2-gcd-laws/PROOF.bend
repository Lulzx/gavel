import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The budget is a literal `0n`, which is the first arm of the match, so the left
# side is `a` on the nose.
def L.gcd_no_fuel(a, b):
  {==}

# Inductive in `f`. The empty case reduces on the budget arm, and the step
# reduces on the `0n` arm of the divisor, which is the arm
# `gcd_zero_divisor` is about; both sides are `a` afterwards.
def L.gcd_zero_divisor(f, a):
  match f:
    case 0n:
      {==}
    case 1n++k:
      {==}

# `1n + f` is a successor, so the match takes the step arm, and `1n + b` is a
# successor, so the inner match does too. Both sides are the same self-call.
def L.gcd_step(f, a, b):
  {==}

# Both sides are numerals, so the checker computes them. This is the law that
# would report a wrong recurrence whose two pins still held.
def L.gcd_twelve_eighteen():
  {==}
