import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a list with no pair of positions has no rise to measure, so the best gain
# over it is zero. Both sides compute, so this one is definitional, and it is
# the anchor: the step law below names its argument as a cons cell, so a body
# that answered anything but `0n` here is caught only by this one.
law best_gain_nil:
  {S.best_gain(Nil{}) == 0n : Nat}

# LAW: a one-element list has no later element, so it has no rise either. It is
# the other half of the anchor -- the smallest input the step law can build is a
# cons cell with a variable tail, so the singleton is where the step's answer
# first has to agree with the empty case's -- and both sides compute, so this
# one is definitional too.
law best_gain_single:
  for x: Nat
  {S.best_gain(x <> Nil{}) == 0n : Nat}

# LAW: the step. The best gain over a cons cell is the better of two things: the
# best rise from the head into the tail, which the prelude's `P.max_sub` takes
# in one pass, and the best gain among the tail's own pairs. Every pair either
# has the head as its earlier element or it does not. This is the law that says
# what is being maximised and which direction the subtraction points, and it is
# the one a body that measured a drop, or that stopped at the head, fails.
law best_gain_cons:
  for h: Nat
  for +t: List<&2, Nat>
  {S.best_gain(h <> t) == Nat.max(P.max_sub(h, t), S.best_gain(t)) : Nat}

# LAW: over two elements the answer is exactly the rise from the first to the
# second. This is the smallest input with a pair in it, and the law that pins
# the shape of the answer rather than one step of the recursion: the answer is
# the later element minus the earlier one, and the truncated subtraction is what
# makes a fall answer `0n` with no separate case. A body that answered the empty
# and one-element inputs correctly and agreed with the step law is a single
# function; this law writes that function's value on a pair out with no `max` in
# the way.
law best_gain_pair:
  for +a: Nat
  for +b: Nat
  {S.best_gain(a <> (b <> Nil{})) == Nat.sub(b, a) : Nat}
