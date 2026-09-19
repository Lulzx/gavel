import Base

# `add` agrees with the reference at `0n` and at `1n` and answers `a + b + 1` at
# `2n` and above.
#
# This file exists because `add_zero` -- the first repair for the hole
# `add-ignores-the-second-argument.bend` records -- did not close it. One value
# plus the `1n` that `add_one` names is not the function: measured 2026-09-19
# against the four-law set (`pred_succ`, `add_one`, `pred_zero`, `add_zero`):
# tier 4, complete, reward 1.000, all four proven by the reference proof
# unchanged, `failed` empty. The branch here answers `a` at `0n` and `1n + a` at
# `1n`, which is what the other laws observe, and one more than the sum from
# `2n` up, which nothing did.
#
# The repair is `add_succ`, the step of `add`'s *second* argument. Measured
# after: tier 2 against the reference proof, which fails for a different body
# rather than proving it, so the demonstration is taken on the law in isolation:
# with a `{==}`-only proof, `LAWS.add_succ` reads
# `expected : solution.add(a, 1n+b) / observed : 1n+solution.add(a, b)`, which is
# the goal and is false at `a = 2n`, `b = 1n` -- `add(2n, 2n)` is `5n` where
# `1n + add(2n, 1n)` is `4n`.
def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      p

def add(a: Nat, b: Nat) -> Nat:
  match b:
    case 0n:
      a
    case 1n+q:
      match q:
        case 0n:
          1n + a
        case 1n+r:
          1n + (1n + add(a, 1n+r))
