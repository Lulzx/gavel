import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The law has no binders: the subject is the constant `0n`, the reference body
# matches on it and takes its empty case, and both sides are zero.
def L.half_zero():
  {==}

# The subject is the constant `1n`, which the reference body's second case
# answers with `0n`.
def L.half_one():
  {==}

# `1n + (1n + n)` is a number the reference body's third case matches, with `n`
# as the number it drops to; the two sides are then the same term.
def L.half_step(n):
  {==}

# The induction is on the number. Its successor case unfolds `Nat.double` into
# `1n + (1n + Nat.double(p))`, so the goal is
# `1n + half(Nat.double(p)) == 1n + p` -- the two sides differ only in the
# `half(Nat.double(p))` occurrence, which is the hypothesis at the previous
# number. Nothing is divided and nothing is left over to do arithmetic on. The
# rewrite needs `Equal.sym` because the hypothesis points the other way: it
# states `half(Nat.double(p)) == p`, and what has to come out of the goal is the
# `half(Nat.double(p))` occurrence.
def L.half_double(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.half(Nat.double(p)), p, L.half_double(p)) : {1n + _ == 1n + p : Nat}
      {==}

# The same induction with the unit in front. Its successor case unfolds
# `Nat.double` one step further out, so the third case of the match binds the
# number one double further along and the hypothesis at the previous number is
# again the only rewrite.
def L.half_double_succ(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.half(1n + Nat.double(p)), p, L.half_double_succ(p)) : {1n + _ == 1n + p : Nat}
      {==}
