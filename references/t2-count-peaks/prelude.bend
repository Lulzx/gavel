import Base

# Immutable, and owned by the task rather than the policy. `count_peaks` and its
# walk are what the policy writes; what is here is the comparison the walk
# branches on, which is not an argument of any function and so has to be a def
# of its own.

# `gt(a, b)` is `1n` when `a` is strictly greater than `b` and `0n` otherwise,
# by structural descent on both at once. It returns a `Nat` rather than a `Bool`
# because the walk adds these up, and because the answer of a comparison is not
# something a `match` may scrutinise.
def gt(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match b:
        case 0n:
          1n
        case 1n+q:
          gt(p, q)

# `peak_at(prev, h, next)` is `1n` when `h` is strictly greater than both of its
# neighbours and `0n` otherwise. `Nat.min` of the two indicators is their
# conjunction, and `Nat.min` is `Base`'s. The answer is a function of the three
# elements rather than a branch on a computed value, which is what lets the walk
# add it without a `match`. `h` is read twice -- it is compared against each
# neighbour in turn -- so it is declared reusable (`+h`). Both neighbours are
# consulted, so an element with only one of them is not answered for here: the
# caller decides that.
def peak_at(prev: Nat, +h: Nat, next: Nat) -> Nat:
  Nat.min(gt(h, prev), gt(h, next))
