import Base

# Immutable, and owned by the task rather than the policy. The pair is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the record is reached through the prelude alias, `P.MkPair{a, b}`, in
# patterns and in terms alike. The four observations are what the laws read the
# answer with: its two components apart, the length of the input, and the list
# the second components are expected to be.
type Pair is Data:
  MkPair{a: Nat, b: Nat}

# The first component of every pair, in order. It matches on its argument, so
# with a variable list of pairs it does not reduce, and that is what leaves the
# third law below to the induction rather than to an unfolding.
def fsts(ps: List<&2, Pair>) -> List<Nat>:
  match ps:
    case Nil{}:
      Nil{}
    case h <> t:
      match h:
        case MkPair{a, b}:
          a <> fsts(t)

# The second component of every pair, in the same order.
def snds(ps: List<&2, Pair>) -> List<Nat>:
  match ps:
    case Nil{}:
      Nil{}
    case h <> t:
      match h:
        case MkPair{a, b}:
          b <> snds(t)

# How many elements a list of `Nat` has.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `n` copies of `x`, one after another. It matches on its first argument, so
# with a variable count it does not reduce either.
def repeat(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+np:
      x <> repeat(np, x)
