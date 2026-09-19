import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Addition regroups. A rewrite goes from a helper's right to its left, so this
# is stated with the right-nested form on the right: using it turns
# `(a + b) + c` into `a + (b + c)`, which is the shape both sides of the
# interaction are brought to. Inductive in `a`, the only argument that shrinks;
# at the step both sides are the hypothesis's two sides under one more `1n`.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# One on the right is one on the left. `Nat.add` matches on its left argument,
# so `a + 1n` is stuck and this is a genuine induction. Stated with `1n + a` on
# the right, so using it turns `1n + a` into `a + 1n`.
#
# The step is where the direction matters: the goal at `1n+p` has `p + 1n` on
# the left and `1n + (1n + p)` on the right, so the hypothesis -- which states
# `p + 1n == 1n + p` -- eliminates the *left* of the two, and a plain use would
# eliminate the right. `Equal.sym` flips it, and the annotation holes out the
# `p + 1n` it replaces.
def Policy.succ_right(a: Nat) -> {a + 1n == 1n + a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, p + 1n, 1n + p, Policy.succ_right(p)) : {1n + _ == 1n + (1n + p) : Nat}
      {==}

# Both sides are the empty match case, so the two totals are definitional at
# `0n` and at `1n + k`.
def L.sum_odd_zero():
  {==}

def L.sum_odd_succ(k):
  {==}

def L.sum_even_zero():
  {==}

def L.sum_even_succ(k):
  {==}

# The induction is the proof: with `n` a variable neither side computes. After
# unfolding, the goal is
#
#     sum_odd(k) + ((k + k) + 1n) == (sum_even(k) + (k + k)) + (1n + k)
#
# The hypothesis replaces `sum_odd(k)` with `sum_even(k) + k`. The `1n` that
# `+ n` contributed is `1n + k`, and `succ_right` moves it to `k + 1n` on the
# other end of the right-hand side, so that both sides are the same four terms
# in the same order -- `sum_even(k)`, `k`, `k`, `k`, `1n` -- and only the
# grouping differs. The three `add_assoc` steps then right-nest each side and
# the two are the same term.
def L.sum_odd_sum_even(n):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Equal.sym(Nat, S.sum_odd(k), S.sum_even(k) + k, L.sum_odd_sum_even(k)) :
          {_ + (k + k + 1n) == (S.sum_even(k) + (k + k)) + (1n + k) : Nat}
      %Policy.succ_right(k) : {(S.sum_even(k) + k) + (k + k + 1n) == (S.sum_even(k) + (k + k)) + _ : Nat}
      %Policy.add_assoc(S.sum_even(k), k, k + k + 1n) : {_ == (S.sum_even(k) + (k + k)) + (k + 1n) : Nat}
      %Policy.add_assoc(S.sum_even(k), k + k, k + 1n) : {S.sum_even(k) + (k + (k + k + 1n)) == _ : Nat}
      %Policy.add_assoc(k, k, 1n) : {S.sum_even(k) + (k + _) == S.sum_even(k) + ((k + k) + (k + 1n)) : Nat}
      %Policy.add_assoc(k, k, k + 1n) : {S.sum_even(k) + (k + (k + (k + 1n))) == S.sum_even(k) + _ : Nat}
      {==}
