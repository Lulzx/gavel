import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list splits into two empty lists. Both sides compute, so this
# one is definitional, and it is the weak half: it fixes what the halves are
# when there is nothing to sort into them.
law split_nil:
  {S.split(Nil{}) == P.MkL{Nil{}, Nil{}} : P.PairL}

# LAW: one step of the split. Both sides compute, so this is definitional too,
# and it is the law that says the two halves are built by *alternation*: the
# head goes on the front of the odd half of the tail, and the even half of the
# whole is the odd half of the tail. A body that put every element in one half,
# or that swapped the two, leaves the two sides here unconvertible.
law split_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.split(h <> t) == P.MkL{h <> P.odds(S.split(t)), P.evens(S.split(t))} : P.PairL}

# LAW: the two halves have between them as many elements as the input. This is
# the work. Neither half is the input, so nothing reduces on its own: the goal
# is about the lengths of the two projections of a *recursive* `split`, which is
# a computed value, and the induction hypothesis is the only thing that can
# rewrite it. What is left over is arithmetic the prelude does not have -- the
# head's `1n +` has to be carried past a variable, and the two lengths have to
# be swapped, neither of which `+` does on its own because it matches on its
# left argument.
law split_len:
  for +xs: List<&2, Nat>
  {P.len(P.evens(S.split(xs))) + P.len(P.odds(S.split(xs))) == P.len(xs) : Nat}
