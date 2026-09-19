import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The match on `n` steps on `0n` and answers `Nil{}` without looking at the two
# numbers.
def L.alternate_zero(a, b):
  {==}

# Both sides are the first number in front of the same recursive call, with the
# other number swapped: the match on `1n + n` puts it there.
def L.alternate_cons(n, a, b):
  {==}

# `2n` is a literal, so the match steps twice and the swap at the first step
# decides which number lands second.
def L.alternate_two(a, b):
  {==}

# An induction in `n`. The step reduces to one more than the length of the
# answer at one fewer to go, with the two numbers swapped -- which is exactly
# the hypothesis, taken at the swapped arguments. `len` and the match inside
# `alternate` both step on their first argument, so neither side reduces past
# this point on its own.
def L.alternate_len(n, a, b):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.len(S.alternate(p, b, a)), p, L.alternate_len(p, b, a)) : {1n + _ == 1n + p : Nat}
      {==}
