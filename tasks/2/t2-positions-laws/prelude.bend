import Base

# Immutable, and owned by the task rather than the policy. `positions` is what
# the policy implements; `eq` is the comparison it collects with, `at_if` is the
# decision taken on that comparison, and `inc_all` is what shifts a tail's
# positions along when an element in front of them is counted.

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
# is why the collection can be written without matching on a computed value: the
# comparison is handed to this function rather than scrutinised where it is
# made. Both answers are lists, so the cons step can either record its position
# or not.
def at_if(b: Bool, x: List<&2, Nat>, y: List<&2, Nat>) -> List<&2, Nat>:
  match b:
    case True{}:
      x
    case False{}:
      y

# Every element stepped up by one: what a list of positions becomes when an
# element in front of them is counted, so every index moves along one.
def inc_all(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n + h) <> inc_all(t)
