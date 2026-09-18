import Base
import ./prelude.bend as P
import ./solution.bend as S

law sum_to_zero:
  {S.sum_to(0n) == 0n : Nat}

law sum_to_succ:
  for p: Nat
  {S.sum_to(1n + p) == S.sum_to(p) + (1n + p) : Nat}

law sum_to_double:
  for n: Nat
  {2n * S.sum_to(n) == n * (1n + n) : Nat}
