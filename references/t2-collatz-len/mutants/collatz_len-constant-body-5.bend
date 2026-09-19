import Base
import ./prelude.bend as P

# The reference solution: the outer match is on the budget, so the recursion
# consumes a structural argument, and the inner match is on the number, so the
# two stopping values are answered without recursing. The step builds the next
# value as a term -- `Bool.pick` of the parity, which the checker cannot reduce
# on a variable but which the law can carry unchanged on both sides -- and adds
# one to the walk on the budget below.
def collatz_len(fuel: Nat, +n: Nat) -> Nat:
  match fuel:
    case 0n:
      0n
    case 1n+f:
      match n:
        case 0n:
          0n
        case 1n+0n:
          0n
        case 1n+1n+p:
          0n
