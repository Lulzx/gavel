import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# The lists are `List<&2, Nat>` rather than `List<Nat>` because the steps of the
# laws below use a destructured tail twice -- once for the recursive call and
# once inside a lemma -- and a variable can only be used live once unless its
# kind allows a `+` binder. A `List<Nat>` tail cannot be marked reusable: the
# second use fails with "expected : t / observed : t (consumed more than once)".

# `append` matches on its first argument, so a goal about appending two
# variable lists does not reduce on its own.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# `snoc` adds one element on the right. It matches on its first argument too,
# which is what makes the law that reverses a `snoc` inductive rather than
# definitional.
def snoc(xs: List<&2, Nat>, y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
