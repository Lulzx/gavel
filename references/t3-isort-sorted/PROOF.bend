import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and
# the credit path does not count it, so helpers are free -- but none of them
# may cite a law.

def Policy.bool_ite(b: Bool, x: Bool) -> Bool:
  match b:
    case True{}:
      True{}
    case False{}:
      x

# From `False == True` nothing survives: transport along the absurd equation.
def Policy.absurd_true(x: Bool, e: {False{} == True{} : Bool}) -> {x == True{} : Bool}:
  Equal.cong(Bool, Bool, b => Policy.bool_ite(b, x), False{}, True{}, e)

# `P.le` decided `False` in one direction is `True` in the other.
def Policy.le_flip(a: Nat, b: Nat, +e: {P.le(a, b) == False{} : Bool})
    -> {P.le(b, a) == True{} : Bool}:
  match a:
    case 0n:
      Policy.absurd_true(P.le(b, 0n), Equal.sym(Bool, True{}, False{}, e))
    case 1n+p:
      match b:
        case 0n:
          {==}
        case 1n+q:
          Policy.le_flip(p, q, e)

# The insert step: `t` is sorted with head `h` and decision `c`, and `p` is a
# lower bound on `h`. The result is sorted with lower bound `p`.
def Policy.H(t: List<&2, Nat>, +h: Nat, +y: Nat, k: Bool, +p: Nat, c: Bool,
             +e_k: {k == P.le(y, h) : Bool},
             +e_c: {c == P.le(p, h) : Bool},
             +e_py: {P.le(p, y) == True{} : Bool},
             +es: {P.sorted_put(t, h, c) == True{} : Bool})
    -> {P.sorted_put(P.insert_put(t, h, y, k), p, True{}) == True{} : Bool}:
  match t:
    case Nil{}:
      match k:
        case True{}:
          %Equal.sym(Bool, P.le(p, y), True{}, e_py) : {P.sorted_put(h <> Nil{}, y, _) == True{} : Bool}
          %e_k : {P.sorted_put(Nil{}, h, _) == True{} : Bool}
          {==}
        case False{}:
          match c:
            case True{}:
              %e_c : {P.sorted_put(y <> Nil{}, h, _) == True{} : Bool}
              %Equal.sym(Bool, P.le(h, y), True{}, Policy.le_flip(y, h, Equal.sym(Bool, False{}, P.le(y, h), e_k))) : {P.sorted_put(Nil{}, y, _) == True{} : Bool}
              {==}
            case False{}:
              Policy.absurd_true(P.sorted_put(P.insert_put(Nil{}, h, y, k), p, True{}), es)
    case +h2 <> t2:
      match k:
        case True{}:
          match c:
            case True{}:
              %Equal.sym(Bool, P.le(p, y), True{}, e_py) : {P.sorted_put(h <> h2 <> t2, y, _) == True{} : Bool}
              %e_k : {P.sorted_put(h2 <> t2, h, _) == True{} : Bool}
              es
            case False{}:
              Policy.absurd_true(P.sorted_put(P.insert_put(h2 <> t2, h, y, k), p, True{}), es)
        case False{}:
          match c:
            case True{}:
              %e_c : {P.sorted_put(P.insert_put(t2, h2, y, P.le(y, h2)), h, _) == True{} : Bool}
              Policy.H(t2, h2, y, P.le(y, h2), h, P.le(h, h2), {==}, {==}, Policy.le_flip(y, h, Equal.sym(Bool, False{}, P.le(y, h), e_k)), es)
            case False{}:
              Policy.absurd_true(P.sorted_put(P.insert_put(h2 <> t2, h, y, k), p, True{}), es)

# `X` is the sorted tail; `insert` puts `y` into it.
def Policy.ins_top(X: List<&2, Nat>, +y: Nat, +es: {P.sorted_put(X, 0n, True{}) == True{} : Bool})
    -> {P.sorted_put(S.insert(X, y), 0n, True{}) == True{} : Bool}:
  match X:
    case Nil{}:
      {==}
    case +h <> t:
      Policy.H(t, h, y, P.le(y, h), 0n, P.le(0n, h), {==}, {==}, {==}, es)

def L.isort_sorted(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.ins_top(S.isort(t), h, L.isort_sorted(t))

def L.insert_sorted(xs, y, e):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      Policy.H(t, h, y, P.le(y, h), 0n, P.le(0n, h), {==}, {==}, {==}, e)

def L.insert_le(x, y, e):
  %Equal.sym(Bool, P.le(y, x), True{}, e) : {P.insert_put(Nil{}, x, y, _) == y <> x <> Nil{} : List<&2, Nat>}
  {==}

def L.insert_gt(x, y, e):
  %Equal.sym(Bool, P.le(y, x), False{}, e) : {P.insert_put(Nil{}, x, y, _) == x <> y <> Nil{} : List<&2, Nat>}
  {==}

def L.isort_swap(x, y, e):
  %Equal.sym(Bool, P.le(x, y), False{}, e) : {P.insert_put(Nil{}, y, x, _) == y <> x <> Nil{} : List<&2, Nat>}
  {==}

# `insert_put` adds exactly two elements to its list argument, whatever the
# decision: each leaf is a two-element list on the empty list, and the recursive
# leaf keeps the head and recurses. `h` and `y` are live because the leaves use
# them; the decision is the argument the four cases split on.
def Policy.insert_put_len(t: List<&2, Nat>, +h: Nat, +y: Nat, k: Bool)
    -> {P.len(P.insert_put(t, h, y, k)) == 1n + (1n + P.len(t)) : Nat}:
  match t:
    case Nil{}:
      match k:
        case True{}:
          {==}
        case False{}:
          {==}
    case +h2 <> t2:
      match k:
        case True{}:
          {==}
        case False{}:
          %Equal.sym(Nat, P.len(P.insert_put(t2, h2, y, P.le(y, h2))),
                     1n + (1n + P.len(t2)),
                     Policy.insert_put_len(t2, h2, y, P.le(y, h2)))
              : {1n + _ == 1n + (1n + (1n + P.len(t2))) : Nat}
          {==}

# `insert` is `insert_put` on the tail, so the count follows from just above.
def L.insert_len(xs, y):
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Policy.insert_put_len(t, h, y, P.le(y, h)) : {P.len(S.insert(h <> t, y)) == _ : Nat}
      {==}
