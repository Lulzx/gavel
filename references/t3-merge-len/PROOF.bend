import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The facts about `+` that the counting needs. None of them is in the prelude,
# and none may be a law: a law that cited one would make an isolated law depend
# on a law that has not been credited yet.
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

def Policy.add_one_right(a: Nat) -> {a + 1n == 1n + a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_one_right(p) : {1n + (p + 1n) == 1n + _ : Nat}
      {==}

# The counting, generalized over both lists and over the decision: the step of
# `merge` moves past the heads the law was stated with, so the hypothesis has to
# be available at the two tails the body recurses on. The recursion mirrors
# `merge_go` branch for branch, and `k` -- the decision, which no side of the
# statement mentions -- is what the four middle cases split on.
def Policy.merge_go_len(+tx: List<&2, Nat>, +hx: Nat, +ty: List<&2, Nat>, +hy: Nat, k: Bool)
    -> {P.len(S.merge_go(tx, hx, ty, hy, k)) == (1n + P.len(tx)) + (1n + P.len(ty)) : Nat}:
  match tx:
    case Nil{}:
      match ty:
        case Nil{}:
          match k:
            case True{}:
              {==}
            case False{}:
              {==}
        case +hy2 <> ty2:
          match k:
            case True{}:
              {==}
            case False{}:
              %Equal.sym(Nat, P.len(S.merge_go(Nil{}, hx, ty2, hy2, P.le(hx, hy2))),
                         (1n + P.len(Nil{})) + (1n + P.len(ty2)),
                         Policy.merge_go_len(Nil{}, hx, ty2, hy2, P.le(hx, hy2)))
                  : {1n + _ == 1n + (1n + (1n + P.len(ty2))) : Nat}
              {==}
    case +hx2 <> tx2:
      match ty:
        case Nil{}:
          match k:
            case True{}:
              %Equal.sym(Nat, P.len(S.merge_go(tx2, hx2, ty, hy, P.le(hx2, hy))),
                         (1n + P.len(tx2)) + (1n + P.len(ty)),
                         Policy.merge_go_len(tx2, hx2, ty, hy, P.le(hx2, hy)))
                  : {1n + _ == (1n + (1n + P.len(tx2))) + 1n : Nat}
              {==}
            case False{}:
              %Policy.add_one_right(1n + P.len(tx2))
                  : {1n + _ == (1n + (1n + P.len(tx2))) + 1n : Nat}
              {==}
        case +hy2 <> ty2:
          match k:
            case True{}:
              %Equal.sym(Nat, P.len(S.merge_go(tx2, hx2, ty, hy, P.le(hx2, hy))),
                         (1n + P.len(tx2)) + (1n + P.len(ty)),
                         Policy.merge_go_len(tx2, hx2, ty, hy, P.le(hx2, hy)))
                  : {1n + _ == (1n + (1n + P.len(tx2))) + (1n + (1n + P.len(ty2))) : Nat}
              {==}
            case False{}:
              %Equal.sym(Nat, P.len(S.merge_go(tx, hx, ty2, hy2, P.le(hx, hy2))),
                         (1n + P.len(tx)) + P.len(ty),
                         Policy.merge_go_len(tx, hx, ty2, hy2, P.le(hx, hy2)))
                  : {1n + _ == (1n + P.len(tx)) + (1n + P.len(ty)) : Nat}
              %Policy.add_succ_right(1n + P.len(tx), P.len(ty))
                  : {_ == (1n + P.len(tx)) + (1n + P.len(ty)) : Nat}
              {==}

def L.merge_nil_l(ys):
  {==}

def L.merge_nil_r(xs):
  match xs:
    case Nil{}:
      {==}
    case hx <> tx:
      {==}

def L.merge_go_true(a, b):
  {==}

def L.merge_go_false(a, b):
  {==}

def L.merge_len(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case +hx <> tx:
      match ys:
        case Nil{}:
          %Policy.add_zero_right(1n + P.len(tx)) : {1n + P.len(tx) == _ : Nat}
          {==}
        case +hy <> ty:
          %Policy.merge_go_len(tx, hx, ty, hy, P.le(hx, hy))
              : {P.len(S.merge(hx <> tx, hy <> ty)) == _ : Nat}
          {==}

def L.merge_le_head(hx, tx, hy, ty, e):
  match tx:
    case Nil{}:
      match ty:
        case Nil{}:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(Nil{}, hx, Nil{}, hy, k), P.le(hx, hy), True{}, e)
              : {S.merge_go(Nil{}, hx, Nil{}, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
        case hy2 <> ty2:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(Nil{}, hx, hy2 <> ty2, hy, k), P.le(hx, hy), True{}, e)
              : {S.merge_go(Nil{}, hx, hy2 <> ty2, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
    case hx2 <> tx2:
      match ty:
        case Nil{}:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(hx2 <> tx2, hx, Nil{}, hy, k), P.le(hx, hy), True{}, e)
              : {S.merge_go(hx2 <> tx2, hx, Nil{}, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
        case hy2 <> ty2:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(hx2 <> tx2, hx, hy2 <> ty2, hy, k), P.le(hx, hy), True{}, e)
              : {S.merge_go(hx2 <> tx2, hx, hy2 <> ty2, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}

def L.merge_gt_head(hx, tx, hy, ty, e):
  match tx:
    case Nil{}:
      match ty:
        case Nil{}:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(Nil{}, hx, Nil{}, hy, k), P.le(hx, hy), False{}, e)
              : {S.merge_go(Nil{}, hx, Nil{}, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
        case hy2 <> ty2:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(Nil{}, hx, hy2 <> ty2, hy, k), P.le(hx, hy), False{}, e)
              : {S.merge_go(Nil{}, hx, hy2 <> ty2, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
    case hx2 <> tx2:
      match ty:
        case Nil{}:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(hx2 <> tx2, hx, Nil{}, hy, k), P.le(hx, hy), False{}, e)
              : {S.merge_go(hx2 <> tx2, hx, Nil{}, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
        case hy2 <> ty2:
          %Equal.cong(Bool, List<&2, Nat>, k => S.merge_go(hx2 <> tx2, hx, hy2 <> ty2, hy, k), P.le(hx, hy), False{}, e)
              : {S.merge_go(hx2 <> tx2, hx, hy2 <> ty2, hy, P.le(hx, hy)) == _ : List<&2, Nat>}
          {==}
