import Base

# Immutable, and owned by the task rather than the policy. `concat_map` is what
# the policy implements; everything here is what the laws are stated in terms
# of -- the list one element expands to, the two functions the composition law
# compares a single pass against, and the count the measure law counts with.

# Appending two lists. It matches on its first argument, so with a variable list
# on the left the goal does not reduce, and that is what leaves the composition
# and measure laws below to the induction rather than to the unfolding.
def append(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The list one element expands to: the element, then its successor. Fixed here
# rather than asked for, so that this task's laws pin `concat_map` rather than
# delegating the per-element list to the policy.
def expand(+x: Nat) -> List<&2, Nat>:
  x <> ((x + 1n) <> Nil{})

# Flattening a list of lists. The composition law says one pass over the input
# is this applied to the input mapped with `expand`.
def concat(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      append(h, concat(t))

# `expand` at every element: the map half of the composition law, and the only
# place a list of lists is built in this task.
def map_expand(xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      expand(h) <> map_expand(t)

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The length every answer must have: two elements for every element of the
# input. It is stated without mentioning `concat_map`, so a body that emitted
# one element per input element -- or three -- is caught by the measure law even
# when the composition law is satisfied. The recurrence is written out here
# rather than as `2n * len(xs)` because the multiplication would put a second
# induction into the proof of a law that is otherwise one.
def elen(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      2n + elen(t)
