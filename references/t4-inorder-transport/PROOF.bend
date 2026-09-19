import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# --- conjunction and absurdity, verbatim from references/t4-bst-insert ---------

def Policy.bool_ite(b: Bool, x: Bool) -> Bool:
  match b:
    case True{}:
      True{}
    case False{}:
      x

def Policy.absurd_true(x: Bool, e: {False{} == True{} : Bool}) -> {x == True{} : Bool}:
  Equal.cong(Bool, Bool, b => Policy.bool_ite(b, x), False{}, True{}, e)

def Policy.and_l(a: Bool, b: Bool, e: {Bool.and(a, b) == True{} : Bool}) -> {a == True{} : Bool}:
  match a:
    case True{}:
      {==}
    case False{}:
      e

def Policy.and_r(a: Bool, b: Bool, e: {Bool.and(a, b) == True{} : Bool}) -> {b == True{} : Bool}:
  match a:
    case True{}:
      e
    case False{}:
      Policy.absurd_true(b, e)

def Policy.and_i(a: Bool, b: Bool, +ea: {a == True{} : Bool},
                 +eb: {b == True{} : Bool}) -> {Bool.and(a, b) == True{} : Bool}:
  match a:
    case True{}:
      eb
    case False{}:
      ea

def Policy.and_assoc(a: Bool, b: Bool, c: Bool)
    -> {Bool.and(Bool.and(a, b), c) == Bool.and(a, Bool.and(b, c)) : Bool}:
  match a:
    case True{}:
      {==}
    case False{}:
      {==}

# --- the bound transports (left-threading folds) -------------------------------

def Policy.all_le_list_put_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +b: Nat, +k: Bool)
    -> {P.all_le_list_put(P.append(xs, ys), b, k) == P.all_le_list_put(ys, b, P.all_le_list_put(xs, b, k)) : Bool}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.all_le_list_put_append(t, ys, b, Bool.and(k, P.le(h, b)))

def Policy.all_le_put_transport(+t: P.Tree, +b: Nat, +k: Bool)
    -> {P.all_le_list_put(S.inorder(t), b, k) == S.all_le_put(t, b, k) : Bool}:
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, +key, +r}:
      %Equal.sym(Bool, P.all_le_list_put(P.append(S.inorder(l), key <> S.inorder(r)), b, k),
                 P.all_le_list_put(key <> S.inorder(r), b, P.all_le_list_put(S.inorder(l), b, k)),
                 Policy.all_le_list_put_append(S.inorder(l), key <> S.inorder(r), b, k)) : {_ == S.all_le_put(r, b, Bool.and(S.all_le_put(l, b, k), P.le(key, b))) : Bool}
      %Equal.sym(Bool, P.all_le_list_put(S.inorder(r), b, Bool.and(P.all_le_list_put(S.inorder(l), b, k), P.le(key, b))),
                 S.all_le_put(r, b, Bool.and(P.all_le_list_put(S.inorder(l), b, k), P.le(key, b))),
                 Policy.all_le_put_transport(r, b, Bool.and(P.all_le_list_put(S.inorder(l), b, k), P.le(key, b)))) : {_ == S.all_le_put(r, b, Bool.and(S.all_le_put(l, b, k), P.le(key, b))) : Bool}
      %Equal.sym(Bool, P.all_le_list_put(S.inorder(l), b, k), S.all_le_put(l, b, k),
                 Policy.all_le_put_transport(l, b, k)) : {S.all_le_put(r, b, Bool.and(_, P.le(key, b))) == S.all_le_put(r, b, Bool.and(S.all_le_put(l, b, k), P.le(key, b))) : Bool}
      {==}

def Policy.all_ge_list_put_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +b: Nat, +k: Bool)
    -> {P.all_ge_list_put(P.append(xs, ys), b, k) == P.all_ge_list_put(ys, b, P.all_ge_list_put(xs, b, k)) : Bool}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      Policy.all_ge_list_put_append(t, ys, b, Bool.and(k, P.le(b, h)))

def Policy.all_ge_put_transport(+t: P.Tree, +b: Nat, +k: Bool)
    -> {P.all_ge_list_put(S.inorder(t), b, k) == S.all_ge_put(t, b, k) : Bool}:
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, +key, +r}:
      %Equal.sym(Bool, P.all_ge_list_put(P.append(S.inorder(l), key <> S.inorder(r)), b, k),
                 P.all_ge_list_put(key <> S.inorder(r), b, P.all_ge_list_put(S.inorder(l), b, k)),
                 Policy.all_ge_list_put_append(S.inorder(l), key <> S.inorder(r), b, k)) : {_ == S.all_ge_put(r, b, Bool.and(S.all_ge_put(l, b, k), P.le(b, key))) : Bool}
      %Equal.sym(Bool, P.all_ge_list_put(S.inorder(r), b, Bool.and(P.all_ge_list_put(S.inorder(l), b, k), P.le(b, key))),
                 S.all_ge_put(r, b, Bool.and(P.all_ge_list_put(S.inorder(l), b, k), P.le(b, key))),
                 Policy.all_ge_put_transport(r, b, Bool.and(P.all_ge_list_put(S.inorder(l), b, k), P.le(b, key)))) : {_ == S.all_ge_put(r, b, Bool.and(S.all_ge_put(l, b, k), P.le(b, key))) : Bool}
      %Equal.sym(Bool, P.all_ge_list_put(S.inorder(l), b, k), S.all_ge_put(l, b, k),
                 Policy.all_ge_put_transport(l, b, k)) : {S.all_ge_put(r, b, Bool.and(_, P.le(b, key))) == S.all_ge_put(r, b, Bool.and(S.all_ge_put(l, b, k), P.le(b, key))) : Bool}
      {==}

# --- the measure ---------------------------------------------------------------

def Policy.len_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>)
    -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys), Policy.len_append(t, ys)) : {1n + _ == 1n + (P.len(t) + P.len(ys)) : Nat}
      {==}

def Policy.add_succ_right(a: Nat, +b: Nat) -> {a + (1n + b) == 1n + (a + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + (1n + b), 1n + (p + b), Policy.add_succ_right(p, b)) : {1n + _ == 1n + (1n + (p + b)) : Nat}
      {==}

def Policy.inorder_size(+t: P.Tree) -> {P.len(S.inorder(t)) == P.size(t) : Nat}:
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{l, +key, +r}:
      %Equal.sym(Nat, P.len(P.append(S.inorder(l), key <> S.inorder(r))), P.len(S.inorder(l)) + P.len(key <> S.inorder(r)), Policy.len_append(S.inorder(l), key <> S.inorder(r))) : {_ == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.len(S.inorder(l)), P.size(l), Policy.inorder_size(l)) : {_ + P.len(key <> S.inorder(r)) == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.len(S.inorder(r)), P.size(r), Policy.inorder_size(r)) : {P.size(l) + (1n + _) == P.size(P.Bin{l, key, r}) : Nat}
      %Equal.sym(Nat, P.size(l) + (1n + P.size(r)), 1n + (P.size(l) + P.size(r)), Policy.add_succ_right(P.size(l), P.size(r))) : {_ == 1n + (P.size(l) + P.size(r)) : Nat}
      {==}

# --- the sortedness half -------------------------------------------------------

# `X ++ [key] ++ Y` is sorted, given:
#   * X's own sortedness continuation from `p` under the decision `k`,
#   * the decision `le(p, key)` that settles the bottom case, where the walk over
#     X has run out and `p` is still the element before the junction,
#   * the fact that every element of X is at most `key`,
#   * Y's own sortedness continuation from `key`,
#   * (carried for the caller) the lower bound on Y.
def Policy.between(+X: List<&2, Nat>, +Y: List<&2, Nat>, +key: Nat, +p: Nat, k: Bool,
                   +e_sorted: {P.sorted_put(X, p, k) == True{} : Bool},
                   +e_pkey: {P.le(p, key) == True{} : Bool},
                   +e_bound: {P.all_le_list(X, key) == True{} : Bool},
                   +e_ge: {P.all_ge_list(Y, key) == True{} : Bool},
                   +e_ysorted: {P.sorted_put(Y, key, True{}) == True{} : Bool})
    -> {P.sorted_put(P.append(X, key <> Y), p, k) == True{} : Bool}:
  match X:
    case Nil{}:
      match k:
        case True{}:
          %Equal.sym(Bool, P.le(p, key), True{}, e_pkey) : {P.sorted_put(Y, key, _) == True{} : Bool}
          e_ysorted
        case False{}:
          e_sorted
    case h <> t:
      match k:
        case True{}:
          Policy.between(t, Y, key, h, P.le(p, h), e_sorted,
                         Policy.and_l(P.le(h, key), P.all_le_list(t, key), e_bound),
                         Policy.and_r(P.le(h, key), P.all_le_list(t, key), e_bound),
                         e_ge, e_ysorted)
        case False{}:
          e_sorted

def Policy.all_le_list_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +b: Nat)
    -> {P.all_le_list(P.append(xs, ys), b) == Bool.and(P.all_le_list(xs, b), P.all_le_list(ys, b)) : Bool}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(Bool, P.all_le_list(P.append(t, ys), b),
                 Bool.and(P.all_le_list(t, b), P.all_le_list(ys, b)),
                 Policy.all_le_list_append(t, ys, b)) : {Bool.and(P.le(h, b), _) == Bool.and(Bool.and(P.le(h, b), P.all_le_list(t, b)), P.all_le_list(ys, b)) : Bool}
      %Policy.and_assoc(P.le(h, b), P.all_le_list(t, b), P.all_le_list(ys, b)) : {_ == Bool.and(Bool.and(P.le(h, b), P.all_le_list(t, b)), P.all_le_list(ys, b)) : Bool}
      {==}

def Policy.all_ge_list_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +b: Nat)
    -> {P.all_ge_list(P.append(xs, ys), b) == Bool.and(P.all_ge_list(xs, b), P.all_ge_list(ys, b)) : Bool}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(Bool, P.all_ge_list(P.append(t, ys), b),
                 Bool.and(P.all_ge_list(t, b), P.all_ge_list(ys, b)),
                 Policy.all_ge_list_append(t, ys, b)) : {Bool.and(P.le(b, h), _) == Bool.and(Bool.and(P.le(b, h), P.all_ge_list(t, b)), P.all_ge_list(ys, b)) : Bool}
      %Policy.and_assoc(P.le(b, h), P.all_ge_list(t, b), P.all_ge_list(ys, b)) : {_ == Bool.and(Bool.and(P.le(b, h), P.all_ge_list(t, b)), P.all_ge_list(ys, b)) : Bool}
      {==}

def Policy.le_trans(a: Nat, b: Nat, c: Nat,
                    +e_ab: {P.le(a, b) == True{} : Bool},
                    +e_bc: {P.le(b, c) == True{} : Bool})
    -> {P.le(a, c) == True{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      match b:
        case 0n:
          Policy.absurd_true(P.le(1n + p, c), e_ab)
        case 1n+q:
          match c:
            case 0n:
              Policy.absurd_true(P.le(1n + p, 0n), e_bc)
            case 1n+s:
              Policy.le_trans(p, q, s, e_ab, e_bc)

def Policy.all_le_list_mono(+xs: List<&2, Nat>, +b: Nat, +c: Nat,
                            +e: {P.all_le_list(xs, b) == True{} : Bool},
                            +e_bc: {P.le(b, c) == True{} : Bool})
    -> {P.all_le_list(xs, c) == True{} : Bool}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      Policy.and_i(P.le(h, c), P.all_le_list(t, c),
                   Policy.le_trans(h, b, c,
                     Policy.and_l(P.le(h, b), P.all_le_list(t, b), e), e_bc),
                   Policy.all_le_list_mono(t, b, c,
                     Policy.and_r(P.le(h, b), P.all_le_list(t, b), e), e_bc))

def Policy.all_ge_list_mono(+xs: List<&2, Nat>, +b: Nat, +c: Nat,
                            +e: {P.all_ge_list(xs, c) == True{} : Bool},
                            +e_bc: {P.le(b, c) == True{} : Bool})
    -> {P.all_ge_list(xs, b) == True{} : Bool}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      Policy.and_i(P.le(b, h), P.all_ge_list(t, b),
                   Policy.le_trans(b, c, h, e_bc,
                     Policy.and_l(P.le(c, h), P.all_ge_list(t, c), e)),
                   Policy.all_ge_list_mono(t, b, c,
                     Policy.and_r(P.le(c, h), P.all_ge_list(t, c), e), e_bc))

def Policy.bst_ind(+t: P.Tree, +lo: Nat, +hi: Nat, +k: Bool,
                   +e: {S.bst(t, lo, hi, k) == True{} : Bool})
    -> {Bool.and(P.sorted_put(S.inorder(t), lo, k),
                 Bool.and(P.all_le_list(S.inorder(t), hi),
                          P.all_ge_list(S.inorder(t), lo))) == True{} : Bool}:
  match t:
    case P.Tip{}:
      Policy.and_i(k, Bool.and(P.all_le_list(Nil{}, hi), P.all_ge_list(Nil{}, lo)), e, {==})
    case P.Bin{l, +key, r}:
      e_bl = Policy.and_l(S.bst(l, lo, key, k),
                          Bool.and(S.bst(r, key, hi, True{}),
                                   Bool.and(P.le(lo, key), P.le(key, hi))), e)
      +rest1 = Policy.and_r(S.bst(l, lo, key, k),
                           Bool.and(S.bst(r, key, hi, True{}),
                                    Bool.and(P.le(lo, key), P.le(key, hi))), e)
      e_br = Policy.and_l(S.bst(r, key, hi, True{}),
                          Bool.and(P.le(lo, key), P.le(key, hi)), rest1)
      +rest2 = Policy.and_r(S.bst(r, key, hi, True{}),
                           Bool.and(P.le(lo, key), P.le(key, hi)), rest1)
      +e_lo = Policy.and_l(P.le(lo, key), P.le(key, hi), rest2)
      +e_hi = Policy.and_r(P.le(lo, key), P.le(key, hi), rest2)
      +ih_l = Policy.bst_ind(l, lo, key, k, e_bl)
      s_l = Policy.and_l(P.sorted_put(S.inorder(l), lo, k),
                         Bool.and(P.all_le_list(S.inorder(l), key), P.all_ge_list(S.inorder(l), lo)), ih_l)
      +rl1 = Policy.and_r(P.sorted_put(S.inorder(l), lo, k),
                         Bool.and(P.all_le_list(S.inorder(l), key), P.all_ge_list(S.inorder(l), lo)), ih_l)
      +b_l = Policy.and_l(P.all_le_list(S.inorder(l), key), P.all_ge_list(S.inorder(l), lo), rl1)
      g_l = Policy.and_r(P.all_le_list(S.inorder(l), key), P.all_ge_list(S.inorder(l), lo), rl1)
      +ih_r = Policy.bst_ind(r, key, hi, True{}, e_br)
      s_r = Policy.and_l(P.sorted_put(S.inorder(r), key, True{}),
                         Bool.and(P.all_le_list(S.inorder(r), hi), P.all_ge_list(S.inorder(r), key)), ih_r)
      +rr1 = Policy.and_r(P.sorted_put(S.inorder(r), key, True{}),
                         Bool.and(P.all_le_list(S.inorder(r), hi), P.all_ge_list(S.inorder(r), key)), ih_r)
      r_le = Policy.and_l(P.all_le_list(S.inorder(r), hi), P.all_ge_list(S.inorder(r), key), rr1)
      +r_ge = Policy.and_r(P.all_le_list(S.inorder(r), hi), P.all_ge_list(S.inorder(r), key), rr1)
      a1 = Policy.between(S.inorder(l), S.inorder(r), key, lo, k, s_l, e_lo, b_l, r_ge, s_r)
      mono_l = Policy.all_le_list_mono(S.inorder(l), key, hi, b_l, e_hi)
      n_le = Policy.and_i(P.le(key, hi), P.all_le_list(S.inorder(r), hi), e_hi, r_le)
      a2 = Equal.trans(Bool, P.all_le_list(P.append(S.inorder(l), key <> S.inorder(r)), hi),
                       Bool.and(P.all_le_list(S.inorder(l), hi), P.all_le_list(key <> S.inorder(r), hi)),
                       True{},
                       Policy.all_le_list_append(S.inorder(l), key <> S.inorder(r), hi),
                       Policy.and_i(P.all_le_list(S.inorder(l), hi), P.all_le_list(key <> S.inorder(r), hi), mono_l, n_le))
      mono_r = Policy.all_ge_list_mono(S.inorder(r), lo, key, r_ge, e_lo)
      n_ge = Policy.and_i(P.le(lo, key), P.all_ge_list(S.inorder(r), lo), e_lo, mono_r)
      a3 = Equal.trans(Bool, P.all_ge_list(P.append(S.inorder(l), key <> S.inorder(r)), lo),
                       Bool.and(P.all_ge_list(S.inorder(l), lo), P.all_ge_list(key <> S.inorder(r), lo)),
                       True{},
                       Policy.all_ge_list_append(S.inorder(l), key <> S.inorder(r), lo),
                       Policy.and_i(P.all_ge_list(S.inorder(l), lo), P.all_ge_list(key <> S.inorder(r), lo), g_l, n_ge))
      Policy.and_i(P.sorted_put(S.inorder(P.Bin{l, key, r}), lo, k),
                   Bool.and(P.all_le_list(S.inorder(P.Bin{l, key, r}), hi),
                            P.all_ge_list(S.inorder(P.Bin{l, key, r}), lo)),
                   a1,
                   Policy.and_i(P.all_le_list(S.inorder(P.Bin{l, key, r}), hi),
                                P.all_ge_list(S.inorder(P.Bin{l, key, r}), lo), a2, a3))

# --- the six laws --------------------------------------------------------------

def L.inorder_tip():
  {==}

def L.inorder_bin(l, key, r):
  {==}

def L.inorder_len(t):
  Policy.inorder_size(t)

def L.inorder_all_le(t, b, k, e):
  Equal.trans(Bool, P.all_le_list_put(S.inorder(t), b, k), S.all_le_put(t, b, k), True{},
              Policy.all_le_put_transport(t, b, k), e)

def L.inorder_all_ge(t, b, k, e):
  Equal.trans(Bool, P.all_ge_list_put(S.inorder(t), b, k), S.all_ge_put(t, b, k), True{},
              Policy.all_ge_put_transport(t, b, k), e)

def L.inorder_sorted(t, lo, hi, e):
  Policy.and_l(P.sorted_put(S.inorder(t), lo, True{}),
               Bool.and(P.all_le_list(S.inorder(t), hi), P.all_ge_list(S.inorder(t), lo)),
               Policy.bst_ind(t, lo, hi, True{}, e))
