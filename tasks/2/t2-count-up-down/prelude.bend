import Base

# Immutable, and owned by the task rather than the policy: the list `count_up`
# is expected to build its answer with, and the two measures the laws are stated
# over. `snoc` matches on its first argument, which is what makes a goal about
# `snoc` of a variable stuck, and `rev` is written in terms of it for the same
# reason. The element type carries `&2` -- a list whose elements can be read
# more than once -- because the step of a lemma about either function has to
# name its tail twice.
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

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
