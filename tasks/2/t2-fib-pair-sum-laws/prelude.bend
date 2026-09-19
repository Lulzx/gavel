import Base

# Immutable, and owned by the task rather than the policy. The laws look inside
# the answer `fib_pair` gives, so the pair and its accessors are stated here
# rather than left to the policy, and the pair step is supplied rather than
# asked for, so that the laws pin the numbers rather than the arithmetic on
# them.

# Two consecutive Fibonacci numbers, the earlier first. A `Nat` cannot hold
# both, so the laws are stated over a pair of them.
type Pair is Data:
  MkPair{a: Nat, b: Nat}

# The pair one step further along: the second number becomes the first, and the
# two are added for the second. This is `fib_pair`'s step, which is why it is
# the prelude's rather than the policy's.
def advance(p: Pair) -> Pair:
  match p:
    case MkPair{a, +b}:
      MkPair{b, a + b}

# The earlier of the two numbers, and the later one. The laws need to name each
# half on its own: the sum is stated over the first and the running total is
# stated over the second.
def fst(p: Pair) -> Nat:
  match p:
    case MkPair{a, b}:
      a

def snd(p: Pair) -> Nat:
  match p:
    case MkPair{a, b}:
      b
