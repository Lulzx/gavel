import Base

# `max` is the minimum. It reached tier 4 -- full reward -- before
# `max_zero_left` and `max_succ_succ` existed: `max_self` and `max_comm` are
# satisfied by the minimum too, since it is just as idempotent and just as
# symmetric as the maximum. Measured: bare tier 2, killed first at
# `LAWS.max_zero_left`.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      0n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      1n+max(ap, bp)
