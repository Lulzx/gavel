import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The left list is empty, so the walk ends at the branch this law names and the
# answer is `0n` whatever the other side is.
def L.lcp_len_nil_left(ys):
  {==}

# The right list is empty, and the left one is a variable, so the walk does not
# reduce until the left list is known: the empty case is its own branch and a
# cons cell is decided by the inner match on the empty right side.
def L.lcp_len_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# Both sides are the same one-element list, so the outer match takes the cons
# branch, the inner one takes it too, and the equality of the two heads decides
# the gate.
def L.lcp_len_equal_singletons():
  {==}

# The step of the definition written out, with both sides reducing to the gate
# over the equality of the heads.
def L.lcp_len_cons(h, t, k, u):
  {==}

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and the
# credit path does not count it, but none of them may cite a law.

# Two equal elements compare equal, so the prelude's equality test is `1n` on a
# pair of the same value. The statement is oriented with `1n` on the left
# because a rewrite step replaces the *right* side of its equation by the left,
# and `1n` is what the goal has to end up with. The descent strips one successor
# from both sides at once, so the hypothesis is the same statement one step
# down.
def Policy.is_eq_refl(a: Nat) -> {1n == P.is_eq(a, a) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.is_eq_refl(p) : {1n == _ : Nat}
      {==}

# The prefix of a list with itself is the whole list. `Equal.sym` is there
# because the law states its equation with the target's call on the left and a
# rewrite step wants the answer on the left: the hypothesis says the tails'
# prefix is the tails' length, and the step replaces the tails' prefix by that
# length. The second step replaces the equality of the head with itself by `1n`,
# which lets the gate decide, and what is left is the definition of `P.len` on a
# cons cell.
def L.lcp_len_self(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, S.lcp_len(t, t), P.len(t), L.lcp_len_self(t)) : {P.gate(P.is_eq(h, h), 1n + _) == 1n + P.len(t) : Nat}
      %Policy.is_eq_refl(h) : {P.gate(_, 1n + P.len(t)) == 1n + P.len(t) : Nat}
      {==}
