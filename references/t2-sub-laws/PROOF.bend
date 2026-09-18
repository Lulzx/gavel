import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# A split on `x`. Both branches are definitional: `sub(0n, 0n)` is the first
# pattern of the match, and `sub(1n+p, 0n)` is the third.
def L.sub_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      {==}

# An induction in `x`. In the `1n+p` case the goal still has `sub(p, 0n)` in it,
# which is stuck while `p` is a variable, so that case splits `p` and then `y`.
def L.sub_succ(x, y):
  match x:
    case 0n:
      match y:
        case 0n:
          {==}
        case 1n+q:
          {==}
    case 1n+p:
      match p:
        case 0n:
          match y:
            case 0n:
              {==}
            case 1n+q:
              # `sub(0n, ...)` is `0n` on paper, but the match is on both
              # arguments at once, so a variable `q` leaves it stuck: the split
              # is what lets the two sides meet.
              match q:
                case 0n:
                  {==}
                case 1n+qq:
                  {==}
        case 1n+pp:
          match y:
            case 0n:
              {==}
            case 1n+q:
              %L.sub_succ(1n+pp, q) : {S.sub(1n+pp, 1n+q) == _ : Nat}
              {==}
