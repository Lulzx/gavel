import Base
import ./prelude.bend as P

# TODO(policy): implement. `fib_list(n)` is the list of the first `n` Fibonacci
# numbers, in order and starting at `0n`:
#
#   fib_list(0n)  ==  Nil{}
#   fib_list(1n)  ==  [0n]
#   fib_list(3n)  ==  [0n, 1n, 1n]
#   fib_list(6n)  ==  [0n, 1n, 1n, 2n, 3n, 5n]
#
# Each number after the first two is the sum of the two before it, so a walk that
# emits one number at a time has to carry both of them. `fib_go(k, a, b)` is that
# walk: it emits `k` numbers, the first of which is `a`, and the pair it carries
# slides to `(b, a + b)` after each one. `fib_list(n)` is the walk started from
# the pair `(0n, 1n)`.
#
# `k` -- the number of numbers still to emit -- is the walk's first parameter and
# the one the recursion shrinks: the checker reads a recursive call's arguments
# left to right and asks that each be passed on unchanged until one shrinks, and
# here that one has to be handed over first. `a` and `b` come after it because
# they change at every step, which is allowed of the arguments a shrinking call
# passes on.
#
# `a` is read twice in the step -- once where it is emitted and once in `a + b`,
# which is the number after it -- and `b` is read twice as well, once where the
# pair slides and once in that sum. Both are therefore declared reusable, `+a`
# and `+b`, in the reference.
def fib_go(k: Nat, +a: Nat, +b: Nat) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. `fib_list(n)` is the walk above started from the pair
# the sequence begins with: `0n` first, `1n` after it. There is nothing else in
# it -- the `n` numbers, the pair, and the slide all belong to the walk.
def fib_list(n: Nat) -> List<&2, Nat>:
  ?TODO
