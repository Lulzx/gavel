import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `split_at` steps on the count, so a count of `0n` reduces on its own and both
# sides are the whole list in the second half.
def L.split_at_zero(xs):
  {==}

# The count is a variable, so the goal does not reduce until it is split: at
# `0n` the body answers two empty halves, and at a successor the body matches on
# the empty list, which answers the same. Neither side reduces further.
def L.split_at_nil(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      {==}

# Definitional: the left side reduces to the pair the body builds, and the
# projection of its first field is the head in front of the tail's first half.
def L.split_at_cons_left(n, x, xs):
  {==}

# Definitional for the same reason, and the projection is of the second field.
def L.split_at_cons_right(n, x, xs):
  {==}

# Inductive in the count: `split_at` matches on it, so with a variable `n`
# neither side reduces. The step case leaves `append` of the head in front of
# the halves of the tail's pair, which is the hypothesis at the count below it.
def L.split_at_decomp(n, xs):
  match n:
    case 0n:
      {==}
    case 1n+p:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          %L.split_at_decomp(p, t) : {h <> P.append(P.left_half(S.split_at(p, t)), P.right_half(S.split_at(p, t))) == h <> _ : List<&2, Nat>}
          {==}
