import Base
import ./prelude.bend as P

# The reference solution: the list is built by a walk that carries the pair the
# next number comes from, so that each step emits one number and slides the pair
# along. `k` is the number of numbers left to emit, so it is the walk's first
# parameter and the one the recursion shrinks; `a` and `b` are read again after
# the step -- `a` where it is emitted and again in the sum, `b` where the pair
# slides -- so they are declared reusably.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  match k:
    case 1n:
      Nil{}
    case 1n+kp:
      a <> fib_go(kp, b, a + b)

# The first `n` numbers, which is the walk started from the pair `(0n, 1n)`.
def fib_list(n: Nat) -> List<&2, Nat>:
  fib_go(n, 0n, 1n)
