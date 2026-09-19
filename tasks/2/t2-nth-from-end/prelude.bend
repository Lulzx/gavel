import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws: the comparison the walk decides on, the decision it
# takes there, the length it measures the tail with, and the two list shapes the
# laws about distant elements are written over.

# Equality on `Nat`. It steps one successor off each side at once, so it is stuck
# on a variable: `eq(k, k)` at a variable `k` is a fact *about* `k` rather than an
# unfolding, which is what the laws about a hit turn on.
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

# The decision the walk takes on that comparison: the head when the test holds,
# and the recursive answer when it does not. It matches on its *parameter*, which
# is what lets a computed test be passed to it -- a match cannot scrutinise a
# computed value where it is written.
def pick_if(b: Bool, x: Nat, y: Nat) -> Nat:
  match b:
    case True{}:
      x
    case False{}:
      y

# The number of elements in a list. The walk measures the *tail* with it: the
# head of a list whose tail has `k` elements is the element `k` positions from
# the end, since the last element is `0` positions from the end.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The list with `x` appended at the end. A variable list cannot be written to the
# left of a cons -- `xs <> x` is a cons of a *list* onto a list -- so an element
# at the end of a list of unknown length has to be put there by a function, and
# this is it. The laws about the last element are stated over it, and so is the
# induction below them.
def snoc(xs: List<&2, Nat>, +x: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      x <> Nil{}
    case h <> t:
      h <> snoc(t, x)

# A list of `n` copies of `k`. The induction is stated over a run of equal
# elements in front of a distinguishing one, which is what a list of unknown
# length with a known element at its end looks like.
def same(n: Nat, +k: Nat) -> List<&2, Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      k <> same(p, k)
