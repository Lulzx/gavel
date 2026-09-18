import Base
import ./prelude.bend as P

# The mirror of the one-sided body: `b - a`. It survives `absdiff_zero_left`
# (`sub(b, 0n)` is `b`) and dies on `absdiff_zero_right`: `sub(0n, a)` reduces
# to `0n` where the law wants `a`, at `a = 1n+p`. `absdiff_comm` fails too.
def absdiff(+a: Nat, +b: Nat) -> Nat:
  P.sub(b, a)
