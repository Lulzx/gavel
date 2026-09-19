import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no rows, no lengths. Both sides compute, so this one is definitional, and
# it is a pin: it fixes the answer on the empty list of rows, which no other law
# here reaches.
law map_len_nil:
  {S.map_len(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the step. The lengths of a list of rows are the length of the first row in
# front of the lengths of the rest. Both sides compute, so this is definitional,
# and it is the law that says the lengths come out in the order the rows went in:
# a body that answered the lengths backwards has the right list of numbers and
# fails here. It is also what says the recursion is on the rows.
law map_len_cons:
  for l: List<&2, Nat>
  for t: List<&2, List<&2, Nat>>
  {S.map_len(l <> t) == P.len(l) <> S.map_len(t) : List<&2, Nat>}

# LAW: nothing to be longest. Both sides compute, so this is definitional, and
# it is the pin on `longest_row`'s empty case. `0n` is the only answer that keeps
# the interaction law true on the empty list, where `P.max_list` answers `0n` as
# well.
law longest_row_nil:
  {S.longest_row(Nil{}) == 0n : Nat}

# LAW: the step. The longest row of a non-empty list is the longer of the first
# row and the longest of the rest. Both sides compute, so this is definitional,
# and it says the answer comes from the rows rather than from the elements: a
# body that answered `P.len(l)` alone fails the pair of length laws below.
law longest_row_cons:
  for l: List<&2, Nat>
  for t: List<&2, List<&2, Nat>>
  {S.longest_row(l <> t) == P.max(P.len(l), S.longest_row(t)) : Nat}

# LAW: the interaction, and the reason the two functions are one task. The
# longest row is the largest of the row lengths, so taking the lengths first and
# the largest of those afterwards gives the same number. Neither side computes on
# a variable `xss` -- `longest_row` is stuck until its argument is a cons and so
# is `map_len`, and `P.max_list` is stuck on the list `map_len` has not produced
# -- so the two sides are not convertible and the induction is the proof. It is
# the only law here that mentions both functions, so it is what pins them against
# each other: a `map_len` that dropped a row and a `longest_row` that stopped at
# the second row can agree with every law above and still disagree here.
law longest_row_map_len:
  for +xss: List<&2, List<&2, Nat>>
  {S.longest_row(xss) == P.max_list(S.map_len(xss)) : Nat}
