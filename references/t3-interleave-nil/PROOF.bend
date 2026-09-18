import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The two facts about `+` that the counting needs. Neither is in the prelude, and
# neither may be a law: a law that cited one would make an isolated law depend on
# a law that has not been credited yet.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p))
          : {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

# The counting, generalized over both lists. The recursion mirrors `interleave`
# itself, and the step needs the hypothesis at the two tails -- which is why the
# statement carries `ys` rather than the law's own right list.
def Policy.interleave_len_general(+xs: List<&2, Nat>, +ys: List<&2, Nat>)
    -> {P.len(S.interleave(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case hx <> tx:
      match ys:
        case Nil{}:
          %Policy.add_zero_right(P.len(tx)) : {1n + P.len(tx) == 1n + _ : Nat}
          {==}
        case hy <> ty:
          %Equal.sym(Nat, P.len(S.interleave(tx, ty)), P.len(tx) + P.len(ty),
                     Policy.interleave_len_general(tx, ty))
              : {1n + (1n + _) == (1n + P.len(tx)) + (1n + P.len(ty)) : Nat}
          %Policy.add_assoc(1n, P.len(tx), 1n + P.len(ty))
              : {1n + (1n + (P.len(tx) + P.len(ty))) == _ : Nat}
          %Equal.sym(Nat, P.len(tx) + (1n + P.len(ty)), 1n + (P.len(tx) + P.len(ty)),
                     Policy.add_succ_right(P.len(tx), P.len(ty)))
              : {1n + (1n + (P.len(tx) + P.len(ty))) == 1n + _ : Nat}
          {==}

def L.interleave_nil_l(ys):
  {==}

def L.interleave_nil_r(xs):
  match xs:
    case Nil{}:
      {==}
    case hx <> tx:
      {==}

def L.interleave_len(xs, ys):
  %Policy.interleave_len_general(xs, ys) : {P.len(S.interleave(xs, ys)) == _ : Nat}
  {==}

# Definitional: both matches step on their cons cells, and the result is the
# right-hand side. The reordered body leaves `hy <> hx <> ...` against it.
def L.interleave_pair(x, y, tx, ty):
  {==}
