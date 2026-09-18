import Base
import ./prelude.bend as P

# An asymmetric body: the zero case reads the *other* argument, so the function
# is not symmetric in its two arguments. The zero laws are intentionally
# insensitive to this -- `absdiff(0n, b)` is `b` and `absdiff(a, 0n)` is `a`
# both hold -- and even `absdiff_self` holds. `absdiff_comm` is the law that
# sees it: the right-hand side still matches on `b`, which is opaque, so the
# commutativity rewrite has nothing to act on.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      P.sub(a, b) + P.sub(b, a)
