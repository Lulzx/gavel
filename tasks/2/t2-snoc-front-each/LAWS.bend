import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing to append to. Both sides compute, so this one is definitional, and
# it is a pin: it fixes the answer on the empty list of rows, which no other law
# here reaches.
law snoc_each_nil:
  for y: Nat
  {S.snoc_each(Nil{}, y) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the step. Appending to every row puts the element on the end of the first
# row and appends to the rest. Both sides compute, so this is definitional, and
# it is the law that says the element goes on the *end*: a body that prepended it
# has the right shape everywhere else and fails here. It is also what says the
# recursion is on the tail -- a body that recursed on the row it just extended
# does not have this left-hand side at all.
law snoc_each_cons:
  for l: List<&2, Nat>
  for +y: Nat
  for t: List<&2, List<&2, Nat>>
  {S.snoc_each(l <> t, y) == P.snoc(l, y) <> S.snoc_each(t, y) : List<&2, List<&2, Nat>>}

# LAW: nothing to put in front of. Both sides compute, so this is definitional,
# and it is the pin on `front_each`'s empty case.
law front_each_nil:
  for y: Nat
  {S.front_each(Nil{}, y) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the step the other way. Putting the element in front of every row puts it
# in front of the first row and recurses on the rest. Definitional as well, and
# it is the law that says the element goes on the *front*, so it is not the same
# law as the one above with the rows reversed.
law front_each_cons:
  for l: List<&2, Nat>
  for +y: Nat
  for t: List<&2, List<&2, Nat>>
  {S.front_each(l <> t, y) == (y <> l) <> S.front_each(t, y) : List<&2, List<&2, Nat>>}

# LAW: the interaction, and the reason the two functions are one task. Doing one
# and then the other gives the same rows whichever order they are done in: every
# row ends up with `y` at the front and `z` at the end. Neither side computes on
# a variable `xss` -- both are stuck on the list of rows they are handed -- so
# the two sides are not convertible and the induction is the proof. It is the
# only law here that mentions both functions, so it is what pins them against
# each other rather than one at a time: a `snoc_each` that appended to the first
# row alone and a `front_each` that prepended to the last row alone agree with
# every law above at their own step and disagree here.
law snoc_front_commute:
  for +xss: List<&2, List<&2, Nat>>
  for +y: Nat
  for +z: Nat
  {S.snoc_each(S.front_each(xss, y), z) == S.front_each(S.snoc_each(xss, z), y) : List<&2, List<&2, Nat>>}
