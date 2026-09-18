import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helpers. `Policy.` is the reserved namespace: the gate ignores it, so helpers
# are free -- but none of them may cite a law.

# `drop` matches on its count, so with a variable count and a `Nil{}` list the
# goal is stuck on the count even though both branches return `Nil{}`. The fact
# needs its own induction on `m`; `m` is the live one and the list is the fixed
# `Nil{}`.
def Policy.drop_nil(m: Nat) -> {S.drop(m, Nil{}) == Nil{} : List<Nat>}:
  match m:
    case 0n:
      {==}
    case 1n+k:
      {==}

# Both sides unfold to a cons of the head: `take` keeps it, `append` splits on
# it, and the hypothesis replaces the tail. The single use of `t` is the
# hypothesis; the occurrence it rewrites is the `t` on the right of the goal.
def L.take_drop(n, xs):
  match n:
    case 0n:
      {==}
    case 1n+k:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          %L.take_drop(k, t) : {h <> P.append(S.take(k, t), S.drop(k, t)) == h <> _ : List<Nat>}
          {==}

# The second count rides along as a parameter. The zero case is definitional
# because `0n + m` reduces to `m`; the successor case needs the reassociation
# `(1n + k) + m` to `1n + (k + m)` before `drop` will step, and that one is also
# definitional since `+` matches on its left argument.
def L.drop_drop(n, m, xs):
  match n:
    case 0n:
      {==}
    case 1n+k:
      match xs:
        case Nil{}:
          %Equal.sym(List<Nat>, S.drop(m, Nil{}), Nil{}, Policy.drop_nil(m)) : {_ == Nil{} : List<Nat>}
          {==}
        case h <> t:
          %L.drop_drop(k, m, t) : {S.drop(m, S.drop(k, t)) == _ : List<Nat>}
          {==}

# `len`, `take` and `min` all step on a successor count and then look at the
# list, so one induction on the count covers everything: the step exposes a
# `1n +` on both sides and the hypothesis replaces the tails. The single use of
# `t` is the hypothesis.
def L.take_len(n, xs):
  match n:
    case 0n:
      {==}
    case 1n+k:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          %Equal.sym(Nat, P.len(S.take(k, t)), P.min(k, P.len(t)), L.take_len(k, t)) : {1n + _ == 1n + P.min(k, P.len(t)) : Nat}
          {==}
