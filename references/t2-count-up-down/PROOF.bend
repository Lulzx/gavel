import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The fact about `rev` and a `snoc` that the reverse law's step needs. It is not
# a law: a law that cited one would make an isolated law depend on a law that has
# not been credited yet, and the credit for both would be lost. `xs` is `+`
# because the tail is live twice in the step, once inside the recursive `rev` and
# once as the `snoc` the hypothesis is about. `snoc` and `rev` both match on
# their first argument, so this is an induction in `xs`, and the `Equal.sym` is
# there to turn the hypothesis round: the goal at the step holds
# `rev(snoc(t, y))` and the hypothesis states that term, so what has to be
# rewritten is the `snoc` of it, and the hypothesis has to be read backwards.
def Policy.rev_snoc(+xs: List<&2, Nat>, y: Nat)
    -> {P.rev(P.snoc(xs, y)) == y <> P.rev(xs) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.rev(P.snoc(t, y)), y <> P.rev(t), Policy.rev_snoc(t, y)) :
          {P.snoc(_, h) == y <> P.snoc(P.rev(t), h) : List<&2, Nat>}
      {==}

# The same for `len`, and the same induction. The step is definitional once the
# hypothesis has replaced the recursive `len`.
def Policy.len_snoc(+xs: List<&2, Nat>, y: Nat)
    -> {P.len(P.snoc(xs, y)) == 1n + P.len(xs) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.len_snoc(t, y) : {1n + P.len(P.snoc(t, y)) == 1n + _ : Nat}
      {==}

def L.count_up_zero():
  {==}

def L.count_up_succ(k):
  {==}

def L.count_down_zero():
  {==}

def L.count_down_succ(k):
  {==}

# Inductive in `n`. The step: `count_up` appends the new element and `rev` puts
# it on the front, which is exactly `count_down`'s step; the hypothesis at `k` is
# the whole of what is left. The `Equal.sym` is the fact about `rev` of a `snoc`,
# read backwards: the goal holds the `rev` of the appended list and the fact
# states it.
def L.count_up_rev_count_down(n):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Equal.sym(List<&2, Nat>, P.rev(P.snoc(S.count_up(k), k)), k <> P.rev(S.count_up(k)), Policy.rev_snoc(S.count_up(k), k)) :
          {_ == k <> S.count_down(k) : List<&2, Nat>}
      %L.count_up_rev_count_down(k) : {k <> P.rev(S.count_up(k)) == k <> _ : List<&2, Nat>}
      {==}

# Inductive in `n`. The step leaves `1n + len(count_up(k))` against `1n + k`,
# which is the hypothesis at `k` under the appended element.
def L.len_count_up(n):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Equal.sym(Nat, P.len(P.snoc(S.count_up(k), k)), 1n + P.len(S.count_up(k)), Policy.len_snoc(S.count_up(k), k)) :
          {_ == 1n + k : Nat}
      %L.len_count_up(k) : {1n + P.len(S.count_up(k)) == 1n + _ : Nat}
      {==}

# Inductive in `n`. `count_down`'s step puts the element on the front, so `len`
# steps with it and the hypothesis at `k` is what is left.
def L.len_count_down(n):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %L.len_count_down(k) : {1n + P.len(S.count_down(k)) == 1n + _ : Nat}
      {==}
