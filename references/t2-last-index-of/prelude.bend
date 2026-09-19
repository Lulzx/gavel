import Base

# Immutable, and owned by the task rather than the policy. `last_index_of` is
# what the policy implements; `eq` is the comparison it searches with, `at_if`
# is the decision taken on that comparison, `has_k` is whether the target occurs
# at all, and `len` and `inc_all` are what the two laws that are not
# definitional are stated in terms of. The list is a shared one, `List<&2, Nat>`
# -- the tail of a cons cell is read twice in the step, once into the walk and
# once into the recursive call -- and that is what the `+t` there is about.

# Equality on `Nat`. It steps one successor off each side at once, so it is
# stuck on a variable: `eq(k, k)` at a variable `k` is a fact *about* `k` rather
# than an unfolding, which is what the last-occurrence law below turns on.
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

# Whether `k` occurs anywhere in `xs`. This has to be a def rather than a
# `match`: a match cannot scrutinise a computed value where it is written, so
# the comparison is handed to `Bool.or` and the walk of the list is the
# recursion. The target is read twice in the step, once into the comparison and
# once into the walk of the tail, so it is declared reusably (`+k`).
def has_k(xs: List<&2, Nat>, +k: Nat) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.or(eq(h, k), has_k(t, k))

# The length of a list, which is where the sentinel lands: finding nothing means
# the answer counted one per element from `0n`, and that is the length.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# Every element stepped up by one: the list the two laws below that are not the
# step search, in which no element is `0n`, so what the answer there records is
# the head's own position or the sentinel and nothing else.
def inc_all(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n + h) <> inc_all(t)
