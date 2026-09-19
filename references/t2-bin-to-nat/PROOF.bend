import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The law has no binders: the reader matches on the empty list and answers zero,
# and the prelude's `low` at width zero answers zero too.
def L.bin_to_nat_nil():
  {==}

# The reader matches on the cons cell, so both sides are the head plus twice
# the tail.
def L.bin_to_nat_cons(h, t):
  {==}

# The induction is on the width, which is the argument the encoder matches on.
# Its successor case unfolds the encoder into a cons, so the goal is
# `Nat.mod(n, 2n) + 2n * bin_to_nat(nat_bits(p, Nat.div(n, 2n)))` against
# `Nat.mod(n, 2n) + 2n * P.low(p, Nat.div(n, 2n))` -- the two sides differ only
# in the reader applied to the encoder's tail, which is exactly the hypothesis
# at the decremented width and the halved number. The rewrite needs `Equal.sym`
# because the hypothesis points the other way: it states
# `bin_to_nat(nat_bits(...)) == low(...)`, and what has to come out of the goal
# is the `bin_to_nat(nat_bits(...))` occurrence. `Nat.mod` and `Nat.div` are
# still symbolic here, and that is why this closes without any arithmetic.
def L.bin_to_nat_nat_bits(w, n):
  match w:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, S.bin_to_nat(P.nat_bits(p, Nat.div(n, 2n))), P.low(p, Nat.div(n, 2n)), L.bin_to_nat_nat_bits(p, Nat.div(n, 2n))) :
          {Nat.mod(n, 2n) + 2n * _ == Nat.mod(n, 2n) + 2n * P.low(p, Nat.div(n, 2n)) : Nat}
      {==}
