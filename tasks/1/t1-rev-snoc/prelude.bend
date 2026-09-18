import Base

# Immutable, and owned by the task rather than the policy. The law speaks about
# `snoc` alone, so the `reverse` it is stated in terms of -- and the `append`
# that `reverse` recurses through -- are fixed here.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

def reverse(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      append(reverse(t), h <> Nil{})
