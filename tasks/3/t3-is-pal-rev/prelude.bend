import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the policy writes `is_pal`, and the lemmas that
# compare a list with its reverse are the policy's to find.

# `snoc` adds one element on the right. `rev` is built from it, so a goal about
# a reversed cons does not reduce until the induction hypothesis moves the
# element out.
def snoc(xs: List<&2, Nat>, y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)

def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      snoc(rev(t), h)

# Equality on Nat, matching on both arguments. With a variable on either side it
# is stuck, which is why the reflexivity and symmetry facts below are inductions
# and not computations.
def eq_nat(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      match b:
        case 0n:
          True{}
        case 1n+q:
          False{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          eq_nat(p, q)

# Equality on lists, element by element. The two sides are read left to right,
# so it is not symmetric by construction -- that is a fact about it, and the
# task's proof needs it.
def eq_list(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          True{}
        case h <> t:
          False{}
    case h <> t:
      match ys:
        case Nil{}:
          False{}
        case h2 <> t2:
          Bool.and(eq_nat(h, h2), eq_list(t, t2))
