import Base
import ./prelude.bend as P

# `nat_sqrt` descends on `n`. Adding one to `n` raises the square root by at most
# one, so the answer for `1n + np` is the answer for `np` plus one exactly when
# the square of the next number still fits under `1n + np`: the answer below is
# the answer for `np`, and `le_ind` adds the one when the next square fits. The
# `np`-answer is bound once and reused so the step is a single recursive call.
def nat_sqrt(n: Nat) -> Nat:
  match n:
    case 0n:
      +k = nat_sqrt(np)
      Nat.add(k, P.le_ind(Nat.mul(1n + k, 1n + k), 1n + np))

    case 1n+np:
      0n
