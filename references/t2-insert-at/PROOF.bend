import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The match steps on `0n` and answers `y <> xs` without looking at the list.
def L.insert_at_zero(xs, y):
  {==}

# The match steps on the successor count and then finds `Nil{}` where it wanted
# an element to stand in front of.
def L.insert_at_nil(n, y):
  {==}

# One step into the list keeps the head it passed: both sides are the same cons.
def L.insert_at_cons(n, h, t, y):
  {==}

# An induction in the count, with a split on the list in each of the two cases,
# because `take` and `drop` step on the count first and then on the list. At
# `0n` both sides reduce to `y <> xs` whatever `xs` is. At `1n+m` the empty
# list answers `y <> Nil{}` on both sides, and the cons case leaves the head in
# front of a tail that the hypothesis describes exactly -- it is applied at the
# predecessor and the tail, where the goal carries it.
def L.insert_at_take_drop(n, xs, y):
  match n:
    case 0n:
      {==}
    case 1n+m:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          %Equal.sym(List<Nat>, S.insert_at(m, t, y), P.append(P.take(m, t), y <> P.drop(m, t)), L.insert_at_take_drop(m, t, y)) : {h <> _ == h <> P.append(P.take(m, t), y <> P.drop(m, t)) : List<Nat>}
          {==}
