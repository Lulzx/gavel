import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `enum_from` steps on the count, so the left side of the law reduces to
# `Nil{}` on `0n` and to a cons cell in front of the tail's run on a successor.
def L.enum_from_zero(a):
  {==}

# Definitional, and the only law that has to name the start twice: the left side
# reduces to `a <> enum_from(n, 1n + a)`, which is the right side.
def L.enum_from_succ(n, a):
  {==}

# Inductive in the count: `len` matches on its first argument, so with a
# variable `n` the goal does not reduce on its own. The step case leaves
# `1n + len(enum_from(j, 1n + a))` against `1n + j`, which is the hypothesis at
# the shifted start.
def L.enum_from_len(n, a):
  match n:
    case 0n:
      {==}
    case 1n+j:
      %L.enum_from_len(j, 1n + a) : {1n + P.len(S.enum_from(j, 1n + a)) == 1n + _ : Nat}
      {==}
