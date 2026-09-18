import Base
import ./prelude.bend as P

# Answers whether the first two elements are equal, and `True{}` for the lists
# that do not have two. Every pin holds: the empty and the one-element list are
# `True{}`, and `0n <> 1n` is `False{}` because its first two elements differ.
# What is left is the work law, and it is the only law that can see this one:
# `0n <> 1n <> 1n` answers `False{}` while its reverse `1n <> 1n <> 0n`
# answers `True{}`.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      match t:
        case Nil{}:
          True{}
        case h2 <> t2:
          P.eq_nat(h, h2)
