import Base

# The step builds one successor too many, so `max(2n, 3n)` is `5n`: an off-by-one
# in the recursive case, plausible when the unary encoding is being copied by
# hand. Rejected by `max_self` as a statement -- at `1n+p` the body answers
# `1n+1n+S.max(p, p)`, which is `2n+p`, where the law wants `1n+p`. `max_comm`
# is true of the body, since the extra successors are added on both sides, and
# the checker rejects it anyway: the proof's step rewrites under the motive
# `1n + S.max(p, q)`, which the doubled answer does not contain.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+1n+max(ap, bp)
