import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `zip_with` steps on its first list, so with `Nil{}` there the first branch is
# taken no matter what the second list is: both sides are `Nil{}` by unfolding
# alone.
def L.zip_with_nil_left(ys):
  {==}

# With a variable first list the outer match is stuck, so the induction is on
# `xs`. The cons case unfolds the outer step and the inner match on the literal
# `Nil{}`, which picks the empty answer on both sides.
def L.zip_with_nil_right(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      {==}

# `len` folds over `zip_with` and `min` steps through both of its arguments, so
# the hypothesis at `(t1, t2)` -- the single live use of either tail -- leaves
# `1n + P.min(P.len(t1), P.len(t2))` on both sides: the left is exactly that
# after the rewrite, and the right is `min`'s own step through two successors.
def L.zip_with_len(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h1 <> t1:
      match ys:
        case Nil{}:
          {==}
        case h2 <> t2:
          %Equal.sym(Nat, P.len(S.zip_with(t1, t2)), P.min(P.len(t1), P.len(t2)), L.zip_with_len(t1, t2)) : {1n + _ == 1n + P.min(P.len(t1), P.len(t2)) : Nat}
          {==}

# `max` is idempotent: it steps one successor off both arguments at once, so the
# step of the induction is `1n` over the hypothesis. It is a lemma of its own,
# under the reserved `Policy.*` namespace, because `max(x, x)` is stuck where it
# is written.
def Policy.max_idem(x: Nat) -> {P.max(x, x) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.max(p, p), p, Policy.max_idem(p)) : {1n + _ == 1n + p : Nat}
      {==}

# Combining a list with itself is the list. The step unfolds both matches, which
# expose the same head on either side, and then needs the idempotence of `max`
# once and the hypothesis once: `max(h, h)` is not reducible on its own, so the
# first rewrite is the lemma above and the second is the induction at the tail,
# which is the only live mention of `t`. Both are flipped, because the goal has
# the term being rewritten on the left.
def L.zip_with_self(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.max(h, h), h, Policy.max_idem(h)) : {_ <> S.zip_with(t, t) == h <> t : List<Nat>}
      %Equal.sym(List<Nat>, S.zip_with(t, t), t, L.zip_with_self(t)) : {h <> _ == h <> t : List<Nat>}
      {==}

# Both matches unfold to a cons over the same heads, so the two sides are the
# same term.
def L.zip_with_cons(h1, t1, h2, t2):
  {==}
