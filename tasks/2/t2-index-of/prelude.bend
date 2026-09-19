import Base

# Immutable, and owned by the task rather than the policy. `index_of` is what
# the policy implements; `eq` is the comparison it searches with, `at_if` is the
# decision taken on that comparison, and `len` and `inc_all` are what the two
# laws that are not definitional are stated in terms of.

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

# One of two answers, taken on a decision. It matches on its *parameter*, which
# is why the search can be written without matching on a computed value: the
# comparison is handed to this function rather than scrutinised where it is
# made.
def at_if(b: Bool, x: Nat, y: Nat) -> Nat:
  match b:
    case True{}:
      x
    case False{}:
      y

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# Every element stepped up by one: the list the not-found law searches, in which
# no element is `0n`, so the answer there is the sentinel and nothing else.
def inc_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n + h) <> inc_all(t)
