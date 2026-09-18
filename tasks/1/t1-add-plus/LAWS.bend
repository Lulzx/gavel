import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: `S.add` is Base's `+`.
#
# This is a single law that pins a two-argument function, which sounds like it
# should be impossible, and the reason it works here is the shape of the right
# side: it does not mention `add` at all. Every other natural law about `add`
# compares two applications of it, and a body that drops an argument satisfies
# both sides at once.
#
# The obvious counterexample is the standard step law,
# `S.add(x, 1n+y) == 1n + S.add(x, y)`. It does not pin: `add(a, b) = b`
# satisfies it, because the goal becomes `1n+y == 1n+y`. Measured at tier 4 with
# `{==}`, on this task, before it was rewritten. The four other bodies that
# ignore an argument fail here too: `a` answers `x == x + y`, `a + a` answers
# `x + x == x + y`, `b + b` answers `y + y == x + y`, and `0n` answers
# `0n == x + y`.
law add_plus:
  for x: Nat
  for y: Nat
  {S.add(x, y) == x + y : Nat}
