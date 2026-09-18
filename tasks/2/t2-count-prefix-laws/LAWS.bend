import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty count holds no odd numbers. This is the weak half: the constant
# body `0n` satisfies it, and so does a body that ignores the list and hands
# back its count.
law count_odd_prefix_zero:
  for xs: List<Nat>
  {S.count_odd_prefix(0n, xs) == 0n : Nat}

# LAW: counting the odd numbers among as many elements as the list has is
# counting the odd numbers in the list. `len` and `count_odd` both match on
# their first argument, so with a variable `xs` the left-hand side does not
# reduce on its own: this one is inductive in `xs`. It is the law that pins
# `count_odd_prefix` -- with the base law in hand, a body that ignored the count
# would have to be `0n` for every list and `count_odd(xs)` for every list at
# once.
law count_odd_prefix_len:
  for xs: List<Nat>
  {S.count_odd_prefix(P.len(xs), xs) == P.count_odd(xs) : Nat}

# LAW: an exhausted count holds no odd numbers, whatever the count. The two laws
# above reach the inner `Nil{}` case only through `count_odd_prefix(len(xs), xs)`
# and `len(xs) >= 1` forces the list non-empty there, so without this one the
# inner empty case is unconstrained and a body answering `1n` in it proves every
# law in the set. Like the base law this one is definitional in both cases of the
# count; it is here for coverage of the case no other law reaches.
law count_odd_prefix_nil:
  for k: Nat
  {S.count_odd_prefix(k, Nil{}) == 0n : Nat}
