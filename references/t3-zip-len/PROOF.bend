import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The counting, generalized over both lists. The recursion mirrors `zip` itself:
# both lists shrink together, so the hypothesis is needed at the two tails.
def Policy.zip_len_general(+xs: List<&2, Nat>, +ys: List<&2, Nat>)
    -> {P.zlen(S.zip(xs, ys)) == P.min(P.len(xs), P.len(ys)) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case hx <> tx:
      match ys:
        case Nil{}:
          {==}
        case hy <> ty:
          %Policy.zip_len_general(tx, ty)
              : {1n + P.zlen(S.zip(tx, ty)) == 1n + _ : Nat}
          {==}

def L.zip_nil_l(ys):
  {==}

def L.zip_nil_r(xs):
  match xs:
    case Nil{}:
      {==}
    case hx <> tx:
      {==}

def L.zip_len(xs, ys):
  %Policy.zip_len_general(xs, ys) : {P.zlen(S.zip(xs, ys)) == _ : Nat}
  {==}
