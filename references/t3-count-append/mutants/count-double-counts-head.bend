import Base
import ./prelude.bend as P

# The head's indicator is added twice -- a copy-paste in the sum, the head of
# the answer written where the recursion should start. The body is the
# reference's with one term too many, so the length-style laws above it are
# unaffected and both of the laws that name a number see it: `count_self` asks
# for `1n` and gets `2n` at a singleton, and `count_cons` fails as well, since
# its right side carries one indicator and this body carries two. Note the
# `+h`: the binder is read twice, so the pattern has to say so.
def count(+x: Nat, xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case +h <> t:
      P.is_eq(x, h) + P.is_eq(x, h) + count(x, t)
