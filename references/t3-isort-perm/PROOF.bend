import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it, and
# the credit path does not count it, so helpers are free -- but every law below
# has to be reachable without them, which is why none of them cites a law.

# `+` on `Nat` is a recursion on its left argument, so these four are the
# arithmetic the reassociation below needs. `add_zero` and `add_assoc` are the
# inductions themselves; `add_succ` moves a literal one across a sum, and
# `add_comm` is the swap of two counted elements that `insert` needs when it
# leaves the element in place instead of moving it forward.

def Policy.add_zero(n: Nat) -> {n + 0n == n : Nat}:
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + 0n, p, Policy.add_zero(p)) : {1n + _ == 1n + p : Nat}
      {==}
def Policy.add_assoc(a: Nat, b: Nat, c: Nat) -> {(a + b) + c == a + (b + c) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, (p + b) + c, p + (b + c), Policy.add_assoc(p, b, c)) : {1n + _ == 1n + (p + (b + c)) : Nat}
      {==}
def Policy.add_succ(n: Nat) -> {n + 1n == 1n + n : Nat}:
  match n:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ(p) : {1n + (p + 1n) == 1n + _ : Nat}
      {==}
def Policy.add_comm(a: Nat, +b: Nat) -> {a + b == b + a : Nat}:
  match a:
    case 0n:
      %Equal.sym(Nat, b + 0n, b, Policy.add_zero(b)) : {b == _ : Nat}
      {==}
    case 1n+p:
      +q = p
      %Policy.add_assoc(b, 1n, q) : {1n + (q + b) == _ : Nat}
      %Equal.sym(Nat, b + 1n, 1n + b, Policy.add_succ(b)) : {1n + (q + b) == _ + q : Nat}
      %Policy.add_assoc(1n, b, q) : {1n + (q + b) == _ : Nat}
      %Equal.sym(Nat, q + b, b + q, Policy.add_comm(q, b)) : {1n + _ == 1n + (b + q) : Nat}
      {==}

# `count_put` against `ind` with the decision *not* forced: instantiating `b`
# with a comparison that will never compute is what lets the goal below turn a
# stuck `count_put` into a sum.
def Policy.count_put_ind(h: Nat, r: Nat, +b: Bool) -> {P.count_put(h, r, b) == P.ind(b) + r : Nat}:
  match b:
    case True{}:
      {==}
    case False{}:
      {==}
# Counting a cons, decision exposed, with the equation in the direction that puts
# the hole on the comparison itself -- so the rewrite can happen before the
# decision is matched.
def Policy.count_cons(h: Nat, t: List<&2, Nat>, +z: Nat, +b: Bool, +e: {b == P.eq(z, h) : Bool})
    -> {P.count(z, h <> t) == P.ind(b) + P.count(z, t) : Nat}:
  match b:
    case True{}:
      %e : {P.count_put(h, P.count(z, t), _) == 1n + P.count(z, t) : Nat}
      {==}
    case False{}:
      %e : {P.count_put(h, P.count(z, t), _) == 0n + P.count(z, t) : Nat}
      {==}

# The crux: inserting into any list counts as one more `ind` of the element and
# one more of the head, in that order, whatever the decision `k` says. The
# induction is on `t`; the decision stays a parameter because neither a computed
# `le` nor a bound one can be matched, and the `False` case is where the two
# counted elements have to be swapped -- `insert` leaves `h` first there, and the
# sum has to put `y` first anyway.
def Policy.cnt_ins(+t: List<&2, Nat>, +h: Nat, +y: Nat, k: Bool, +z: Nat)
    -> {P.count(z, P.insert_put(t, h, y, k))
        == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, t)) : Nat}:
  match t:
    case Nil{}:
      match k:
        case True{}:
          # count_put(h, 0n, eq(z, h)) against ind(eq(z, h)) + 0n, in place.
          %Equal.sym(Nat, P.count_put(h, 0n, P.eq(z, h)), P.ind(P.eq(z, h)) + 0n,
                     Policy.count_put_ind(h, 0n, P.eq(z, h)))
            : {P.count_put(y, _, P.eq(z, y))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          %Equal.sym(Nat, P.count_put(y, P.ind(P.eq(z, h)) + 0n, P.eq(z, y)),
                     P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + 0n),
                     Policy.count_put_ind(y, P.ind(P.eq(z, h)) + 0n, P.eq(z, y)))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          {==}
        case False{}:
          %Equal.sym(Nat, P.count_put(y, 0n, P.eq(z, y)), P.ind(P.eq(z, y)) + 0n,
                     Policy.count_put_ind(y, 0n, P.eq(z, y)))
            : {P.count_put(h, _, P.eq(z, h))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          %Equal.sym(Nat, P.count_put(h, P.ind(P.eq(z, y)) + 0n, P.eq(z, h)),
                     P.ind(P.eq(z, h)) + (P.ind(P.eq(z, y)) + 0n),
                     Policy.count_put_ind(h, P.ind(P.eq(z, y)) + 0n, P.eq(z, h)))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          %Policy.add_assoc(P.ind(P.eq(z, h)), P.ind(P.eq(z, y)), 0n)
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          %Equal.sym(Nat, P.ind(P.eq(z, h)) + P.ind(P.eq(z, y)),
                     P.ind(P.eq(z, y)) + P.ind(P.eq(z, h)),
                     Policy.add_comm(P.ind(P.eq(z, h)), P.ind(P.eq(z, y))))
            : {(_ + 0n) == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          %Equal.sym(Nat, (P.ind(P.eq(z, y)) + P.ind(P.eq(z, h))) + 0n,
                     P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + 0n),
                     Policy.add_assoc(P.ind(P.eq(z, y)), P.ind(P.eq(z, h)), 0n))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, Nil{})) : Nat}
          {==}
    case +h2 <> t2:
      match k:
        case True{}:
          +d = P.eq(z, h2)
          +r = P.count(z, t2)
          %Equal.sym(Nat, P.count_put(h2, r, d), P.ind(d) + r,
                     Policy.count_put_ind(h2, r, d))
            : {P.count_put(y, P.count_put(h, _, P.eq(z, h)), P.eq(z, y))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, h2 <> t2)) : Nat}
          %Equal.sym(Nat, P.count_put(h, P.ind(d) + r, P.eq(z, h)), P.ind(P.eq(z, h)) + (P.ind(d) + r),
                     Policy.count_put_ind(h, P.ind(d) + r, P.eq(z, h)))
            : {P.count_put(y, _, P.eq(z, y))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, h2 <> t2)) : Nat}
          %Equal.sym(Nat, P.count(z, h2 <> t2), P.ind(d) + r,
                     Policy.count_cons(h2, t2, z, P.eq(z, h2), {==}))
            : {P.count_put(y, P.ind(P.eq(z, h)) + (P.ind(d) + r), P.eq(z, y))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + _) : Nat}
          %Equal.sym(Nat, P.count_put(y, P.ind(P.eq(z, h)) + (P.ind(d) + r), P.eq(z, y)),
                     P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)),
                     Policy.count_put_ind(y, P.ind(P.eq(z, h)) + (P.ind(d) + r), P.eq(z, y)))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)) : Nat}
          {==}
        case False{}:
          +d = P.eq(z, h2)
          +r = P.count(z, t2)
          %Equal.sym(Nat, P.count_put(h, P.count(z, P.insert_put(t2, h2, y, P.le(y, h2))), P.eq(z, h)),
                     P.ind(P.eq(z, h)) + P.count(z, P.insert_put(t2, h2, y, P.le(y, h2))),
                     Policy.count_put_ind(h, P.count(z, P.insert_put(t2, h2, y, P.le(y, h2))), P.eq(z, h)))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, h2 <> t2)) : Nat}
          %Equal.sym(Nat, P.count(z, P.insert_put(t2, h2, y, P.le(y, h2))),
                     P.ind(P.eq(z, y)) + (P.ind(d) + r), Policy.cnt_ins(t2, h2, y, P.le(y, h2), z))
            : {P.ind(P.eq(z, h)) + _
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, h2 <> t2)) : Nat}
          %Equal.sym(Nat, P.count(z, h2 <> t2), P.ind(d) + r,
                     Policy.count_cons(h2, t2, z, P.eq(z, h2), {==}))
            : {P.ind(P.eq(z, h)) + (P.ind(P.eq(z, y)) + (P.ind(d) + r))
               == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + _) : Nat}
          %Policy.add_assoc(P.ind(P.eq(z, h)), P.ind(P.eq(z, y)), P.ind(d) + r)
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)) : Nat}
          %Equal.sym(Nat, P.ind(P.eq(z, h)) + P.ind(P.eq(z, y)),
                     P.ind(P.eq(z, y)) + P.ind(P.eq(z, h)),
                     Policy.add_comm(P.ind(P.eq(z, h)), P.ind(P.eq(z, y))))
            : {(_ + (P.ind(d) + r)) == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)) : Nat}
          %Equal.sym(Nat, (P.ind(P.eq(z, y)) + P.ind(P.eq(z, h))) + (P.ind(d) + r),
                     P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)),
                     Policy.add_assoc(P.ind(P.eq(z, y)), P.ind(P.eq(z, h)), P.ind(d) + r))
            : {_ == P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + (P.ind(d) + r)) : Nat}
          {==}

# The same fact at the top of `insert`, which is the recursion the laws are
# written against: `insert` on a cons is exactly `insert_put` with the decision
# `P.le(y, h)`, and the tail's count is the cons step of `count`.
def Policy.count_ins(+xs: List<&2, Nat>, +y: Nat, +z: Nat)
    -> {P.count(z, S.insert(xs, y)) == P.ind(P.eq(z, y)) + P.count(z, xs) : Nat}:
  match xs:
    case Nil{}:
      %Equal.sym(Nat, P.count_put(y, 0n, P.eq(z, y)), P.ind(P.eq(z, y)) + 0n,
                 Policy.count_put_ind(y, 0n, P.eq(z, y)))
        : {_ == P.ind(P.eq(z, y)) + P.count(z, Nil{}) : Nat}
      {==}
    case +h <> t:
      %Equal.sym(Nat, P.count(z, P.insert_put(t, h, y, P.le(y, h))),
                 P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, t)),
                 Policy.cnt_ins(t, h, y, P.le(y, h), z))
        : {_ == P.ind(P.eq(z, y)) + P.count(z, h <> t) : Nat}
      %Equal.sym(Nat, P.count(z, h <> t), P.ind(P.eq(z, h)) + P.count(z, t),
                 Policy.count_cons(h, t, z, P.eq(z, h), {==}))
        : {P.ind(P.eq(z, y)) + (P.ind(P.eq(z, h)) + P.count(z, t))
           == P.ind(P.eq(z, y)) + _ : Nat}
      {==}

# The count of an insert, restated so that the goal is the sum the induction
# step needs: `xs` is counted, not matched.
def L.insert_count(xs, y, z):
  Policy.count_ins(xs, y, z)

# The permutation law. The base case is `0n == 0n`; the step computes both sides
# one turn, counts the inserted element and the head at the front, and closes the
# two `count`s against the induction hypothesis.
def L.isort_count(xs, z):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.count(z, S.insert(S.isort(t), h)),
                 P.ind(P.eq(z, h)) + P.count(z, S.isort(t)),
                 Policy.count_ins(S.isort(t), h, z))
        : {_ == P.count(z, h <> t) : Nat}
      %Equal.sym(Nat, P.count(z, S.isort(t)), P.count(z, t), L.isort_count(t, z))
        : {P.ind(P.eq(z, h)) + _ == P.count(z, h <> t) : Nat}
      %Equal.sym(Nat, P.count(z, h <> t), P.ind(P.eq(z, h)) + P.count(z, t),
                 Policy.count_cons(h, t, z, P.eq(z, h), {==}))
        : {P.ind(P.eq(z, h)) + P.count(z, t) == _ : Nat}
      {==}

# Both directions for two elements are a single rewrite each: the list is a
# literal, so `isort` computes down to `insert_put` on `Nil{}` and the decision
# is the only thing left. `Equal.sym` is the direction that matters: a
# `%e : P` rewrites the goal's `B` to `e`'s left side.
def L.isort_swap(x, y, e):
  %Equal.sym(Bool, P.le(x, y), False{}, e) : {P.insert_put(Nil{}, y, x, _) == y <> x <> Nil{} : List<&2, Nat>}
  {==}

def L.isort_keep(x, y, e):
  %Equal.sym(Bool, P.le(x, y), True{}, e) : {P.insert_put(Nil{}, y, x, _) == x <> y <> Nil{} : List<&2, Nat>}
  {==}
