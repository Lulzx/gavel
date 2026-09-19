import Base
import ./prelude.bend as P

def fib_pair(n: Nat) -> P.Pair:
  match n:
    case 0n:
      P.MkPair{0n, 1n}
    case 1n++k:
      P.advance(fib_pair(k))

def sum_fib(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++k:
      P.fst(fib_pair(k)) + sum_fib(k)
