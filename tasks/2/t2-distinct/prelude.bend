import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the membership test the walk decides on, the
# decision it takes there, and the list of equal elements the last two laws are
# about.

# Equality on `Nat`. It steps one successor off each side at once, so it is
# stuck on a variable: `eq(k, k)` at a variable `k` is a fact *about* `k` rather
# than an unfolding, which is what the laws about equal elements turn on.
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

# Whether the list holds the element. It tests the head, and on a miss asks the
# tail -- the decision is taken by `or_if`, which matches on the value it is
# handed, because a match cannot scrutinise a computed value in place.
def or_if(b: Bool, c: Bool) -> Bool:
  match b:
    case True{}:
      True{}
    case False{}:
      c

def mem(xs: List<&2, Nat>, +x: Nat) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      or_if(eq(h, x), mem(t, x))

# The decision the walk takes on that test: an element already seen is left out,
# and an element not yet seen is kept. It matches on its *parameter*, and on the
# kept branch the test's own answer is what tells the two apart.
def skip_if(b: Bool, x: Nat, ys: List<Nat>) -> List<Nat>:
  match b:
    case True{}:
      ys
    case False{}:
      x <> ys

# A list of `n` copies of `k`. It is what the last two laws are stated over:
# every element of it is a duplicate of every other, so all of them after the
# first must be left out. It is not used by the policy -- only by those laws and
# their proofs.
def same(n: Nat, +k: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+np:
      k <> same(np, k)
