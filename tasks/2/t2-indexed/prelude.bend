import Base

# Immutable, and owned by the task rather than the policy. `indexed` is what the
# policy implements; everything here is what the laws are stated in terms of --
# the pair an element is packed into, the two lengths, and the projection that
# drops the positions again.

# An element together with the position it was at. A `Nat` cannot hold both
# halves, so the laws are stated over a list of this instead.
type Indexed is Data:
  MkIndexed{i: Nat, x: Nat}

def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# The length of the indexed list. The laws cannot use `len` above for it: the
# elements are pairs, and a length that does not look inside them is the only
# thing the two shapes have in common.
def plen(ps: List<&2, Indexed>) -> Nat:
  match ps:
    case Nil{}:
      0n
    case h <> t:
      1n + plen(t)

# The elements with the positions thrown away, in the order they were in. This
# is the second component of the pair, so it is the function the laws use to say
# that the elements came out unscrambled.
def elems(ps: List<&2, Indexed>) -> List<&2, Nat>:
  match ps:
    case Nil{}:
      Nil{}
    case h <> t:
      match h:
        case MkIndexed{i, x}:
          x <> elems(t)
