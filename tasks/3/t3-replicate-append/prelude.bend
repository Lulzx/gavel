import Base

# Immutable, and owned by the task rather than the policy. `replicate` is what
# the policy implements; everything here is needed to *state* the laws.

# `append` matches on its first argument, so `append(replicate(..), ..)` does
# not reduce until the left list is a cons.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `snoc` adds one element on the right, and matches on its first argument too.
def snoc(xs: List<Nat>, y: Nat) -> List<Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case h <> t:
      h <> snoc(t, y)

# Reversal, fixed here rather than asked for: the last law is about `replicate`
# under `rev`, and a reversed run of one repeated element is again that run.
# This definition puts the head on the right by `snoc`, so reversing a list that
# begins with the repeated element is a `snoc` away from the next case.
def rev(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      snoc(rev(t), h)
