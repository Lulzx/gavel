import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `append` matches on its first argument, so appending `Nil{}` on the right is
# not definitional: the goal is stuck on a variable list until the induction
# hypothesis rewrites it.
def Policy.append_nil(xs: List<&2, Nat>) -> {P.append(xs, Nil{}) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_nil(t) : {h <> P.append(t, Nil{}) == h <> _ : List<&2, Nat>}
      {==}

# `len` of a `snoc` is one more than the length: the appended element becomes
# the head of the cons cell `len` steps on, so the succ is exposed by the match
# and the induction hypothesis carries the tail.
def Policy.len_snoc(xs: List<&2, Nat>, y: Nat) -> {P.len(P.snoc(xs, y)) == 1n + P.len(xs) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.snoc(t, y)), 1n + P.len(t), Policy.len_snoc(t, y)) : {1n + _ == 1n + (1n + P.len(t)) : Nat}
      {==}

# `snoc` and `append` reassociate: pushing an element onto the right of an
# append is appending onto the already-snocced tail.
def Policy.snoc_append(xs: List<&2, Nat>, ys: List<&2, Nat>, y: Nat) -> {P.snoc(P.append(xs, ys), y) == P.append(xs, P.snoc(ys, y)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.snoc_append(t, ys, y) : {h <> P.snoc(P.append(t, ys), y) == h <> _ : List<&2, Nat>}
      {==}

# Reversing a `snoc` puts the element in front. The induction hypothesis moves
# the outer element out, and the remaining `snoc` has a cons scrutinee, so it
# computes.
def Policy.rev_snoc(xs: List<&2, Nat>, y: Nat) -> {S.rev(P.snoc(xs, y)) == y <> S.rev(xs) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, S.rev(P.snoc(t, y)), y <> S.rev(t), Policy.rev_snoc(t, y)) : {P.snoc(_, h) == y <> P.snoc(S.rev(t), h) : List<&2, Nat>}
      {==}

# Reversing a list does not change its length. The step unfolds `rev` once and
# folds the `snoc` back into a succ with `len_snoc`, then the induction
# hypothesis replaces the tail. `t` is live twice here -- inside `len_snoc` and
# as the argument of the recursive call -- and the `+xs` binder on the law, on a
# `Data`-kinded list, is what allows it.
def L.rev_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.snoc(S.rev(t), h)), 1n + P.len(S.rev(t)), Policy.len_snoc(S.rev(t), h)) : {_ == 1n + P.len(t) : Nat}
      %Equal.sym(Nat, P.len(S.rev(t)), P.len(t), L.rev_len(t)) : {1n + _ == 1n + P.len(t) : Nat}
      {==}

# Reversal turns an append around. The step needs the `snoc`/`append`
# reassociation to move the outer element in front of the appended tails.
def L.rev_append(xs, ys):
  match xs:
    case Nil{}:
      %Equal.sym(List<&2, Nat>, P.append(S.rev(ys), Nil{}), S.rev(ys), Policy.append_nil(S.rev(ys))) : {S.rev(ys) == _ : List<&2, Nat>}
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, S.rev(P.append(t, ys)), P.append(S.rev(ys), S.rev(t)), L.rev_append(t, ys)) : {P.snoc(_, h) == P.append(S.rev(ys), P.snoc(S.rev(t), h)) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, P.snoc(P.append(S.rev(ys), S.rev(t)), h), P.append(S.rev(ys), P.snoc(S.rev(t), h)), Policy.snoc_append(S.rev(ys), S.rev(t), h)) : {_ == P.append(S.rev(ys), P.snoc(S.rev(t), h)) : List<&2, Nat>}
      {==}

# Reversing twice is the identity. The step reverses the `snoc` back into an
# element in front, then the induction hypothesis collapses the double reversal
# of the tail.
def L.rev_rev(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, S.rev(P.snoc(S.rev(t), h)), h <> S.rev(S.rev(t)), Policy.rev_snoc(S.rev(t), h)) : {_ == h <> t : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, S.rev(S.rev(t)), t, L.rev_rev(t)) : {h <> _ == h <> t : List<&2, Nat>}
      {==}

# The singleton law is `rev`'s own unfolding: the empty list reverses to itself,
# so the step answers `P.snoc(Nil{}, x)`, which computes to `x <> Nil{}`.
def L.rev_singleton(x):
  {==}
