import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `take` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own: this one is inductive in `xs`, and the `n` case splits
# inside the step. Neither side reduces further in the base case or at `0n`,
# because both `take` and `drop` return the empty list and the whole list.
def L.take_drop(xs, n):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      match n:
        case 0n:
          {==}
        case 1n+p:
          # Both sides are the head in front of the decomposed tail.
          %L.take_drop(t, p) : {h <> P.append(S.take(t, p), P.drop(t, p)) == h <> _ : List<Nat>}
          {==}
