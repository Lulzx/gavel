import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the first zero numbers are none, so the answer is the empty list. The
# right-hand side calls no target, which makes this the absolute anchor, and both
# sides compute. The step law below is stated at `1n + n`, so it never reaches
# this input: a `fib_list` that answered one cell for nothing is caught here and
# nowhere else.
law fib_list_zero:
  {S.fib_list(0n) == Nil{} : List<&2, Nat>}

# LAW: the hand-off from the answer to the walk. A non-empty list starts at `0n`,
# and what follows it is the walk from the pair `(1n, 1n)` -- the numbers after
# the first, whose own first element is `1n`. Both sides compute, so this is
# definitional, and it is the law that fixes the two numbers the sequence starts
# with: a body that started the sequence at `1n` leaves the two sides
# unconvertible here and nowhere above.
law fib_list_succ:
  for +n: Nat
  {S.fib_list(1n + n) == 0n <> S.fib_go(n, 1n, 1n) : List<&2, Nat>}

# LAW: the walk's empty answer. With no numbers left to emit there is nothing to
# emit, whatever pair is in hand. The right-hand side calls no target -- the
# second absolute anchor -- and both sides compute. The step law below never
# reaches this input, so a walk that emitted the pair in hand when it ran out of
# numbers is caught only here.
law fib_go_zero:
  for a: Nat
  for b: Nat
  {S.fib_go(0n, a, b) == Nil{} : List<&2, Nat>}

# LAW: the walk's step. The number in hand is emitted, and the pair slides: the
# `b` in hand becomes the first of the remaining pair and `a + b` becomes the
# second, which is what makes the sequence Fibonacci rather than a repetition.
# Both sides compute, so this is definitional, and it is the law that says where
# the next number comes from: a walk that emitted `b`, or that slid the pair to
# `(a, a + b)` -- keeping the same first component -- has a different unfolding
# here.
law fib_go_succ:
  for +k: Nat
  for +a: Nat
  for +b: Nat
  {S.fib_go(1n + k, a, b) == a <> S.fib_go(k, b, a + b) : List<&2, Nat>}

# LAW: the walk emits exactly the numbers it was asked for, whatever pair it
# started from. This is the law with content, and the only one here whose
# variables leave both sides stuck: `k` is a variable, so nothing reduces and the
# induction is the proof. It is also the law that observes the *number* of
# elements rather than their values, so a walk that emitted a number per step but
# slid its pair in a way that dropped or repeated one is separated by the length
# even where the first few values agree. It has to be stated about the walk and
# not about `fib_list`: the walk starts from a pair the sequence does not start
# from, so a length law about `fib_list` alone would have no hypothesis to use.
law fib_go_len:
  for +k: Nat
  for +a: Nat
  for +b: Nat
  {P.len(S.fib_go(k, a, b)) == k : Nat}

# LAW: the first three numbers, read off one by one. `0n` and `1n` start the
# sequence and the third is their sum, so the answer is `[0n, 1n, 1n]`. Both
# sides are closed, so every match reduces. A walk that emitted the later half of
# its pair first, or that advanced only one component of the pair, satisfies
# several of the laws above and is separated here.
law fib_list_three:
  {S.fib_list(3n) == 0n <> (1n <> (1n <> Nil{})) : List<&2, Nat>}
