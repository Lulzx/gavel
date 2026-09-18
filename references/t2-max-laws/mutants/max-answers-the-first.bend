import Base

# The projection onto the first argument, written as the reference's match with
# the `0n` / `1n+bp` case answered `0n` instead of the second argument -- the
# slip of reading "the one that is not zero" as "the first one". Rejected by
# `max_comm` as a statement: at variables `x` and `y` its two sides reduce to
# `x` and `y`, which are not the same term. `max_self` is true of this body --
# at equal arguments the projection is the argument -- and the checker rejects
# the law anyway, because the proof's step rewrites under the motive
# `1n + S.max(p, p)`, which the projection's answer does not contain.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+ap
