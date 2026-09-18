import Base

# The projection onto the second argument: the mirror of the sibling body, with
# the `1n+ap` / `0n` case answered `0n`. Rejected by `max_comm` as a statement --
# at variables `x` and `y` its two sides reduce to `y` and `x`. `max_self` is
# true of the body, since the projection of two equal arguments is the argument,
# and the checker rejects the law anyway: the proof's step rewrites under the
# motive `1n + S.max(p, p)`, which the projection's answer does not contain.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+bp
