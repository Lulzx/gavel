import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.bool_ite(b: Bool, x: Bool) -> Bool:
  match b:
    case True{}:
      True{}
    case False{}:
      x

# From `False == True` nothing survives: transport along the absurd equation.
def Policy.absurd_true(x: Bool, e: {False{} == True{} : Bool}) -> {x == True{} : Bool}:
  Equal.cong(Bool, Bool, b => Policy.bool_ite(b, x), False{}, True{}, e)

# The three ways out of a conjunction of Bools whose equation is known.
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

# `Nat.add` matches on its left argument, so the arithmetic facts this task
# needs are not definitional: `a + 0n` is stuck on a variable `a`.
def Policy.add_zero_right(a: Nat) -> {a == a + 0n : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero_right(p) : {1n + p == 1n + _ : Nat}
      {==}

# `1n + b` reduces, `b + 1n` does not: to commute the two there is no way around
# a lemma that steps the successor through the right-hand side.
def Policy.add_succ_right(b: Nat, -p: Nat) -> {b + (1n + p) == 1n + (b + p) : Nat}:
  match b:
    case 0n:
      {==}
    case 1n+q:
      %Equal.sym(Nat, q + (1n + p), 1n + (q + p), Policy.add_succ_right(q, p))
          : {1n + _ == 1n + (1n + (q + p)) : Nat}
      {==}

def Policy.add_comm(a: Nat, +b: Nat) -> {a + b == b + a : Nat}:
  match a:
    case 0n:
      %Policy.add_zero_right(b) : {b == _ : Nat}
      {==}
    case 1n+p:
      %Equal.sym(Nat, b + (1n + p), 1n + (b + p), Policy.add_succ_right(b, p))
          : {1n + (p + b) == _ : Nat}
      %Equal.sym(Nat, p + b, b + p, Policy.add_comm(p, b)) : {1n + _ == 1n + (b + p) : Nat}
      {==}

def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# `P.is_eq(x, x)` is `1n`: both branches unfold to the hypothesis.
def Policy.is_eq_refl(x: Nat) -> {P.is_eq(x, x) == 1n : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_eq_refl(p) : {P.is_eq(p, p) == _ : Nat}
      {==}

def Policy.and_i(a: Bool, b: Bool, +ea: {a == True{} : Bool},
                 +eb: {b == True{} : Bool}) -> {Bool.and(a, b) == True{} : Bool}:
  match a:
    case True{}:
      eb
    case False{}:
      ea

# The upper bound survives an insertion, as long as the key being inserted is
# itself under the bound. This is the lemma `ordered` needs at its step, and it
# cannot be reached from the definitions alone: `all_le` on a variable tree is
# stuck, so the bound is only visible once the tree is matched, which is what
# the induction does.
def Policy.all_le_ins(+t: P.Tree, c: Bool, +k: Nat, +b: Nat,
                      +e_c: {c == P.le(k, P.root_key(t)) : Bool},
                      +e_t: {P.all_le(t, b) == True{} : Bool},
                      +e_kb: {P.le(k, b) == True{} : Bool})
    -> {P.all_le(S.ins_at(t, c, k), b) == True{} : Bool}:
  match t:
    case P.Tip{}:
      Policy.and_i(P.le(k, b), Bool.and(P.all_le(P.Tip{}, b), P.all_le(P.Tip{}, b)), e_kb, {==})
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          Policy.and_i(
            P.le(key, b),
            Bool.and(P.all_le(S.ins_at(l, P.le(k, P.root_key(l)), k), b), P.all_le(r, b)),
            Policy.and_l(P.le(key, b), Bool.and(P.all_le(l, b), P.all_le(r, b)), e_t),
            Policy.and_i(
              P.all_le(S.ins_at(l, P.le(k, P.root_key(l)), k), b),
              P.all_le(r, b),
              Policy.all_le_ins(l, P.le(k, P.root_key(l)), k, b, {==},
                                Policy.and_l(P.all_le(l, b), P.all_le(r, b),
                                             Policy.and_r(P.le(key, b),
                                                          Bool.and(P.all_le(l, b), P.all_le(r, b)),
                                                          e_t)),
                                e_kb),
              Policy.and_r(P.all_le(l, b), P.all_le(r, b),
                           Policy.and_r(P.le(key, b), Bool.and(P.all_le(l, b), P.all_le(r, b)), e_t))))
        case False{}:
          Policy.and_i(
            P.le(key, b),
            Bool.and(P.all_le(l, b), P.all_le(S.ins_at(r, P.le(k, P.root_key(r)), k), b)),
            Policy.and_l(P.le(key, b), Bool.and(P.all_le(l, b), P.all_le(r, b)), e_t),
            Policy.and_i(
              P.all_le(l, b),
              P.all_le(S.ins_at(r, P.le(k, P.root_key(r)), k), b),
              Policy.and_l(P.all_le(l, b), P.all_le(r, b),
                           Policy.and_r(P.le(key, b), Bool.and(P.all_le(l, b), P.all_le(r, b)), e_t)),
              Policy.all_le_ins(r, P.le(k, P.root_key(r)), k, b, {==},
                                Policy.and_r(P.all_le(l, b), P.all_le(r, b),
                                             Policy.and_r(P.le(key, b),
                                                          Bool.and(P.all_le(l, b), P.all_le(r, b)),
                                                          e_t)),
                                e_kb)))

# And the same for the lower bound, mirrored.
def Policy.all_ge_ins(+t: P.Tree, c: Bool, +k: Nat, +b: Nat,
                      +e_c: {c == P.le(k, P.root_key(t)) : Bool},
                      +e_t: {P.all_ge(t, b) == True{} : Bool},
                      +e_kb: {P.le(b, k) == True{} : Bool})
    -> {P.all_ge(S.ins_at(t, c, k), b) == True{} : Bool}:
  match t:
    case P.Tip{}:
      Policy.and_i(P.le(b, k), Bool.and(P.all_ge(P.Tip{}, b), P.all_ge(P.Tip{}, b)), e_kb, {==})
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          Policy.and_i(
            P.le(b, key),
            Bool.and(P.all_ge(S.ins_at(l, P.le(k, P.root_key(l)), k), b), P.all_ge(r, b)),
            Policy.and_l(P.le(b, key), Bool.and(P.all_ge(l, b), P.all_ge(r, b)), e_t),
            Policy.and_i(
              P.all_ge(S.ins_at(l, P.le(k, P.root_key(l)), k), b),
              P.all_ge(r, b),
              Policy.all_ge_ins(l, P.le(k, P.root_key(l)), k, b, {==},
                                Policy.and_l(P.all_ge(l, b), P.all_ge(r, b),
                                             Policy.and_r(P.le(b, key),
                                                          Bool.and(P.all_ge(l, b), P.all_ge(r, b)),
                                                          e_t)),
                                e_kb),
              Policy.and_r(P.all_ge(l, b), P.all_ge(r, b),
                           Policy.and_r(P.le(b, key), Bool.and(P.all_ge(l, b), P.all_ge(r, b)), e_t))))
        case False{}:
          Policy.and_i(
            P.le(b, key),
            Bool.and(P.all_ge(l, b), P.all_ge(S.ins_at(r, P.le(k, P.root_key(r)), k), b)),
            Policy.and_l(P.le(b, key), Bool.and(P.all_ge(l, b), P.all_ge(r, b)), e_t),
            Policy.and_i(
              P.all_ge(l, b),
              P.all_ge(S.ins_at(r, P.le(k, P.root_key(r)), k), b),
              Policy.and_l(P.all_ge(l, b), P.all_ge(r, b),
                           Policy.and_r(P.le(b, key), Bool.and(P.all_ge(l, b), P.all_ge(r, b)), e_t)),
              Policy.all_ge_ins(r, P.le(k, P.root_key(r)), k, b, {==},
                                Policy.and_r(P.all_ge(l, b), P.all_ge(r, b),
                                             Policy.and_r(P.le(b, key),
                                                          Bool.and(P.all_ge(l, b), P.all_ge(r, b)),
                                                          e_t)),
                                e_kb)))

# The invariant itself. At a node the two subtree facts are what the induction
# is applied to, and the two bound facts are what the previous two lemmas are
# applied to; the branch is the decision `ins_at` was handed.
def Policy.ord_ins(+t: P.Tree, c: Bool, +k: Nat,
                   +e_c: {c == P.le(k, P.root_key(t)) : Bool},
                   +e_t: {P.ordered(t) == True{} : Bool})
    -> {P.ordered(S.ins_at(t, c, k)) == True{} : Bool}:
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          Policy.and_i(
            P.all_le(S.ins_at(l, P.le(k, P.root_key(l)), k), key),
            Bool.and(P.all_ge(r, key),
                     Bool.and(P.ordered(S.ins_at(l, P.le(k, P.root_key(l)), k)), P.ordered(r))),
            Policy.all_le_ins(l, P.le(k, P.root_key(l)), k, key, {==},
                              Policy.and_l(P.all_le(l, key),
                                           Bool.and(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r))),
                                           e_t),
                              Equal.sym(Bool, True{}, P.le(k, key), e_c)),
            Policy.and_i(
              P.all_ge(r, key),
              Bool.and(P.ordered(S.ins_at(l, P.le(k, P.root_key(l)), k)), P.ordered(r)),
              Policy.and_l(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                           Policy.and_r(P.all_le(l, key),
                                        Bool.and(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r))),
                                        e_t)),
              Policy.and_i(
                P.ordered(S.ins_at(l, P.le(k, P.root_key(l)), k)),
                P.ordered(r),
                Policy.ord_ins(l, P.le(k, P.root_key(l)), k, {==},
                               Policy.and_l(P.ordered(l), P.ordered(r),
                                            Policy.and_r(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                                                         Policy.and_r(P.all_le(l, key),
                                                                      Bool.and(P.all_ge(r, key),
                                                                               Bool.and(P.ordered(l), P.ordered(r))),
                                                                      e_t)))),
                Policy.and_r(P.ordered(l), P.ordered(r),
                             Policy.and_r(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                                          Policy.and_r(P.all_le(l, key),
                                                       Bool.and(P.all_ge(r, key),
                                                                Bool.and(P.ordered(l), P.ordered(r))),
                                                       e_t))))))
        case False{}:
          Policy.and_i(
            P.all_le(l, key),
            Bool.and(P.all_ge(S.ins_at(r, P.le(k, P.root_key(r)), k), key),
                     Bool.and(P.ordered(l), P.ordered(S.ins_at(r, P.le(k, P.root_key(r)), k)))),
            Policy.and_l(P.all_le(l, key),
                         Bool.and(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r))),
                         e_t),
            Policy.and_i(
              P.all_ge(S.ins_at(r, P.le(k, P.root_key(r)), k), key),
              Bool.and(P.ordered(l), P.ordered(S.ins_at(r, P.le(k, P.root_key(r)), k))),
              Policy.all_ge_ins(r, P.le(k, P.root_key(r)), k, key, {==},
                                Policy.and_l(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                                             Policy.and_r(P.all_le(l, key),
                                                          Bool.and(P.all_ge(r, key),
                                                                   Bool.and(P.ordered(l), P.ordered(r))),
                                                          e_t)),
                                Policy.le_flip(k, key, Equal.sym(Bool, False{}, P.le(k, key), e_c))),
              Policy.and_i(
                P.ordered(l),
                P.ordered(S.ins_at(r, P.le(k, P.root_key(r)), k)),
                Policy.and_l(P.ordered(l), P.ordered(r),
                             Policy.and_r(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                                          Policy.and_r(P.all_le(l, key),
                                                       Bool.and(P.all_ge(r, key),
                                                                Bool.and(P.ordered(l), P.ordered(r))),
                                                       e_t))),
                Policy.ord_ins(r, P.le(k, P.root_key(r)), k, {==},
                               Policy.and_r(P.ordered(l), P.ordered(r),
                                            Policy.and_r(P.all_ge(r, key), Bool.and(P.ordered(l), P.ordered(r)),
                                                         Policy.and_r(P.all_le(l, key),
                                                                      Bool.and(P.all_ge(r, key),
                                                                               Bool.and(P.ordered(l), P.ordered(r))),
                                                                      e_t)))))))

# `ins_at`'s definition, one case per constructor and per decision. Each goal
# fixes a closed constructor, so the body reduces to the case that matches it
# and `{==}` closes the goal outright.
def L.ins_at_tip(c, k):
  {==}

def L.ins_at_left(l, key, r, k):
  {==}

def L.ins_at_right(l, key, r, k):
  {==}

def L.insert_leaf(k):
  {==}

def L.insert_le(x, y, e):
  %Equal.sym(Bool, P.le(y, x), True{}, e) : {S.ins_at(P.Bin{P.Tip{}, x, P.Tip{}}, _, y) == P.Bin{P.Bin{P.Tip{}, y, P.Tip{}}, x, P.Tip{}} : P.Tree}
  {==}

def L.insert_gt(x, y, e):
  %Equal.sym(Bool, P.le(y, x), False{}, e) : {S.ins_at(P.Bin{P.Tip{}, x, P.Tip{}}, _, y) == P.Bin{P.Tip{}, x, P.Bin{P.Tip{}, y, P.Tip{}}} : P.Tree}
  {==}

# The invariant law, filled by the induction above. `insert` on a node reduces to
# `ins_at` at that node with the root comparison as its decision, which is the
# shape `Policy.ord_ins` is stated over.
def L.insert_ordered(t, k, e):
  match t:
    case P.Tip{}:
      {==}
    case P.Bin{+l, +key, +r}:
      Policy.ord_ins(P.Bin{l, key, r}, P.le(k, key), k, {==}, e)

# The multiset half needs no invariant hypothesis -- only the arithmetic. The
# inserted key's indicator starts inside the subtree it landed in and has to end
# up as a term of the whole sum, which is the reassociation, plus one commutation
# because `Nat.add` matches on its left argument and will not do it on its own.
def Policy.count_ins(+t: P.Tree, c: Bool, +k: Nat, +x: Nat)
    -> {S.count(S.ins_at(t, c, k), x) == S.count(t, x) + P.is_eq(k, x) : Nat}:
  match t:
    case P.Tip{}:
      %Policy.add_zero_right(P.is_eq(k, x) + 0n) : {_ == P.is_eq(k, x) : Nat}
      %Policy.add_zero_right(P.is_eq(k, x)) : {_ == P.is_eq(k, x) : Nat}
      {==}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          %Equal.sym(Nat, S.count(S.ins_at(l, P.le(k, P.root_key(l)), k), x),
                      S.count(l, x) + P.is_eq(k, x),
                      Policy.count_ins(l, P.le(k, P.root_key(l)), k, x))
              : {P.is_eq(key, x) + _ + S.count(r, x) == (P.is_eq(key, x) + S.count(l, x) + S.count(r, x)) + P.is_eq(k, x) : Nat}
          %Equal.sym(Nat, P.is_eq(key, x) + (S.count(l, x) + P.is_eq(k, x)),
                      (P.is_eq(key, x) + S.count(l, x)) + P.is_eq(k, x),
                      Policy.add_assoc(P.is_eq(key, x), S.count(l, x), P.is_eq(k, x)))
              : {_ + S.count(r, x) == (P.is_eq(key, x) + S.count(l, x) + S.count(r, x)) + P.is_eq(k, x) : Nat}
          %Policy.add_assoc(P.is_eq(key, x) + S.count(l, x), P.is_eq(k, x), S.count(r, x))
              : {_ == (P.is_eq(key, x) + S.count(l, x) + S.count(r, x)) + P.is_eq(k, x) : Nat}
          %Policy.add_assoc(P.is_eq(key, x) + S.count(l, x), S.count(r, x), P.is_eq(k, x))
              : {(P.is_eq(key, x) + S.count(l, x)) + (P.is_eq(k, x) + S.count(r, x)) == _ : Nat}
          %Equal.sym(Nat, P.is_eq(k, x) + S.count(r, x), S.count(r, x) + P.is_eq(k, x),
                      Policy.add_comm(P.is_eq(k, x), S.count(r, x)))
              : {(P.is_eq(key, x) + S.count(l, x)) + _ == (P.is_eq(key, x) + S.count(l, x)) + (S.count(r, x) + P.is_eq(k, x)) : Nat}
          {==}
        case False{}:
          %Equal.sym(Nat, S.count(S.ins_at(r, P.le(k, P.root_key(r)), k), x),
                      S.count(r, x) + P.is_eq(k, x),
                      Policy.count_ins(r, P.le(k, P.root_key(r)), k, x))
              : {P.is_eq(key, x) + S.count(l, x) + _ == (P.is_eq(key, x) + S.count(l, x) + S.count(r, x)) + P.is_eq(k, x) : Nat}
          %Policy.add_assoc(P.is_eq(key, x) + S.count(l, x), S.count(r, x), P.is_eq(k, x))
              : {(P.is_eq(key, x) + S.count(l, x)) + (S.count(r, x) + P.is_eq(k, x)) == _ : Nat}
          {==}

def L.insert_count(t, k, x):
  match t:
    case P.Tip{}:
      Policy.count_ins(P.Tip{}, P.le(k, P.root_key(P.Tip{})), k, x)
    case P.Bin{+l, +key, +r}:
      Policy.count_ins(P.Bin{l, key, r}, P.le(k, key), k, x)

# The empty tree's count is `0n` by the reference body's own unfolding.
def L.count_tip(x):
  {==}
