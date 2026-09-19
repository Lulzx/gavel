import Base
import ./prelude.bend as P

# The walk. `w` is the width -- how many halvings are left to spend -- and it is
# the argument that shrinks, so it comes first and the number is carried along
# unchanged. Zero and one are both below every power of two above `1n`, so they
# stop the walk at `0n`; anything above one is halved and adds one to the walk
# below it.
def log2_go(w: Nat, +n: Nat) -> Nat:
  match w:
    case 0n:
      0n
    case 1n+p:
      0n

# The answer: the floor of the base-two logarithm of `n`. The walk is started
# with `n` itself as the width, which is always enough -- halving reaches `1n`
# within `n` steps for every `n` -- and it is a width the answer does not
# mention, so `nat_log2` is a function of `n` alone.
def nat_log2(+n: Nat) -> Nat:
  log2_go(n, n)
