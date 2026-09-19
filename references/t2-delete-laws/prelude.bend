import Base

# Immutable, and owned by the task rather than the policy. `delete` is what the
# policy implements; `eq` is the comparison it removes with, `at_if` is the
# decision taken on that comparison, and `inc_all` is the list the not-found law
# searches, in which nothing is `0n`.

# Equality on `Nat`. It steps one successor off each side at once, so it is
# stuck on a variable: `eq(k, k)` at a variable `k` is a fact *about* `k` rather
# than an unfolding, which is what the hit law below turns on.
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

# One of two answers, taken on a decision. It matches on its *parameter*, which
# is why the removal can be written without matching on a computed value: the
# comparison is handed to this function rather than scrutinised where it is
# made. Both answers are lists, so the cons step can either drop its head or
# keep it.
def at_if(b: Bool, x: List<&2, Nat>, y: List<&2, Nat>) -> List<&2, Nat>:
  match b:
    case True{}:
      x
    case False{}:
      y

# Every element stepped up by one: the list the not-found law searches, in which
# no element is `0n`.
def inc_all(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n + h) <> inc_all(t)
