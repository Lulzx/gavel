import Base

# Immutable, and owned by the task rather than the policy. The two records are
# the shapes the answer has -- a pair of `Nat`, and the pair of lists a list of
# pairs unzips into -- and the accessors are here so that a law can *look at*
# one half of the answer. Without them the only thing a law could say about
# `unzip` is that it returns some pair of lists, which is exactly the shape a
# body that ignored its input would have.
#
# The fields are `List<&2, Nat>` and not `List<Nat>`: a record is `Data`, and
# `List<Nat>` is a `Type`, so a `Data` record cannot store one.

type Pair is Data:
  Mk{a: Nat, b: Nat}

type ZP is Data:
  MkZ{as: List<&2, Nat>, bs: List<&2, Nat>}

# The first component of a pair.
def pfst(p: Pair) -> Nat:
  match p:
    case Mk{a, b}:
      a

# The second component of a pair.
def psnd(p: Pair) -> Nat:
  match p:
    case Mk{a, b}:
      b

# The first list of an unzipped pair of lists.
def zfst(z: ZP) -> List<&2, Nat>:
  match z:
    case MkZ{as, bs}:
      as

# The second list of an unzipped pair of lists.
def zsnd(z: ZP) -> List<&2, Nat>:
  match z:
    case MkZ{as, bs}:
      bs

# How many pairs the input had. The measure the two length laws are stated
# against: `unzip` does not change how many elements there are, it only moves
# them from one list of records to two lists of numbers.
def plen(ps: List<&2, Pair>) -> Nat:
  match ps:
    case Nil{}:
      0n
    case h <> t:
      1n + plen(t)

# How many elements a list of `Nat` has.
def llen(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + llen(t)
