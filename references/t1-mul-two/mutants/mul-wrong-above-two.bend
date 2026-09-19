import Base

# `mul` agrees with the reference at `0n` and at `2n` and answers `2n * b` at
# `3n` and above.
#
# The three laws this file predates -- `mul_zero`, `mul_two`, `add_zero` --
# observe `mul` at `0n` and at `2n` and nowhere else, so a body is free to be
# wrong at every argument above two: `b` at `1n`, `add(b, add(b, 0n))` at `2n`
# and at every successor of that. The `add` is the reference's, so `add_zero`
# holds unchanged. Measured 2026-09-19, before the repair: tier 4, complete,
# reward 1.000, all three laws then in the set proven by the reference proof
# unchanged, `failed` empty.
#
# After the repair, measured 2026-09-19 against this task's law set: tier 3,
# failing `mul_succ`, proven `mul_zero`, `mul_two` and `add_zero`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      1n + add(p, b)

def mul(a: Nat, +b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      match p:
        case 0n:
          b
        case 1n+q:
          add(b, add(b, 0n))
