import Base

# Immutable, and owned by the task rather than the policy. `replace_first` is
# what the policy implements; everything here is the vocabulary the laws are
# stated in -- the comparison the walk decides on, the step with its decision
# exposed as an argument, and the measure the length law is written in.

# Whether two numbers are the same. It steps one successor off each side at
# once, so with a variable on either side the answer does not reduce: that a
# number is the same as itself is an induction and not an unfolding, which is
# what the law about replacing the head turns on.
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

# The step of the walk with its decision exposed as an argument: `h` is dropped
# and `y` takes its place when the decision is `True{}`, and the head survives
# with the rest of the walk behind it when it is `False{}`. `t` is the tail the
# walk was handed, so on a replacement the whole of it comes back untouched --
# that is what leaves the *later* occurrences of `k` alone. A `match` in Bend
# cannot scrutinise the result of a call, so the comparison cannot be made where
# the two answers are told apart and has to be passed in. Both lists are read
# once -- `t` by one branch and `r` by the other -- and both are spelled
# `List<&2, Nat>` so that the two answers have one type; the tail a caller holds
# under a `+` is reusable, and a list that may be read twice may be read once.
def rp_branch(b: Bool, h: Nat, y: Nat, t: List<&2, Nat>, r: List<&2, Nat>) -> List<&2, Nat>:
  match b:
    case True{}:
      y <> t
    case False{}:
      h <> r

# How many elements a list has. The length law is stated in terms of it.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
