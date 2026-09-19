import Base

# Immutable, and owned by the task rather than the policy. `indices_of` is what
# the policy implements; `eq` is the comparison it searches with, `cons_if` is
# the decision taken on that comparison, and `inc_all` is what a recursive
# answer is shifted by -- one step for every position the head stands in front
# of.

# Equality on `Nat`. It steps one successor off each side at once, so it is
# stuck on a variable: `eq(k, k)` at a variable `k` is a fact *about* `k` rather
# than an unfolding, which is what the found-at-head law below turns on.
def eq(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          True{}
        case 1n+bp:
          False{}
    case 1n+ap:
      match b:
        case 0n:
          False{}
        case 1n+bp:
          eq(ap, bp)

# The decision, taken on a list: `x` consed onto `ys` when the comparison held,
# and `ys` on its own when it did not. It matches on its *parameter*, which is
# why the search can be written without matching on a computed value: the
# comparison is handed to this function rather than scrutinised where it is
# made.
def cons_if(b: Bool, x: Nat, ys: List<Nat>) -> List<Nat>:
  match b:
    case True{}:
      x <> ys
    case False{}:
      ys

# Every element stepped up by one: the list the not-found law searches, in which
# no element is `0n`, so nothing in it is a hit.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n + h) <> inc_all(t)
