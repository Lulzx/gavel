import Base

# The recursive case answers the second argument instead of recursing, so `max`
# is the second argument whenever both are successors. `max_self` is true of the
# body -- at equal arguments `1n+bp` is the argument -- and the checker rejects
# the law anyway, because the proof's step rewrites under the motive
# `1n + S.max(p, p)`, which this answer does not contain. `max_comm` is false of
# the body outright: `max(2n, 3n)` is `3n` and `max(3n, 2n)` is `2n`.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+bp
