import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are the specification of `lcp_list`. The prefix is read off position
# by position: the empty list on either side ends it, and two cons cells keep
# the cell and go on when the two heads are equal and answer `Nil{}` when they
# are not. The answer is therefore a prefix of both inputs, and it stops at the
# first position the two lists disagree at, or where the shorter one runs out.

# The anchor on the left: nothing to compare against means no common prefix,
# whatever the second list is. The right-hand side calls no target.
law lcp_list_nil_left:
  for ys: List<&2, Nat>
  {S.lcp_list(Nil{}, ys) == Nil{} : List<&2, Nat>}

# The anchor on the right, and it is not the same law: the walk looks at the
# first list first, so this is the branch that says a list running out on the
# right ends the prefix too, and it is the one that has to be inductive in `xs`.
# The right-hand side calls no target.
law lcp_list_nil_right:
  for xs: List<&2, Nat>
  {S.lcp_list(xs, Nil{}) == Nil{} : List<&2, Nat>}

# The step, and the law that says a *matching* pair is kept rather than skipped:
# when the two heads are the same element, the answer starts with that element
# and goes on with the prefix of the two tails. The two heads are separately
# quantified -- the law holds whether or not they agree -- so a body that
# compared them the other way round, or that dropped the cell, has a different
# unfolding here.
law lcp_list_cons_heads:
  for +h: Nat
  for k: Nat
  for +t: List<&2, Nat>
  for +u: List<&2, Nat>
  {S.lcp_list(h <> t, k <> u) == P.gate_list(P.is_eq(h, k), h <> S.lcp_list(t, u)) : List<&2, Nat>}

# Content, and the law with no second list: the longest common prefix of a list
# with itself is the whole list, so nothing is dropped anywhere. A body that
# stopped one position early, or that treated the last position as a special
# case, or that answered `Nil{}` once the lists were short, is separated here --
# and this is the law that fixes the *tail* of the answer at every length, which
# no law about a mismatch can.
law lcp_list_self:
  for +xs: List<&2, Nat>
  {S.lcp_list(xs, xs) == xs : List<&2, Nat>}

# Content, at a closed pair of lists that agree at two positions and differ at
# the third: the prefix is the two elements the lists share, and the element
# they disagree at is not in it. A body that kept the differing element, or that
# answered the whole of the first list, is separated here. Both sides are closed
# and the left-hand side is a ground term.
law lcp_list_stops_at_a_mismatch:
  {S.lcp_list(1n <> (2n <> (3n <> Nil{})), 1n <> (2n <> (4n <> Nil{})))
     == 1n <> (2n <> Nil{}) : List<&2, Nat>}

# Content, at a closed pair of lists of different lengths: the prefix is the
# whole of the shorter list, and the element the longer one has over it is not
# in it. A body that walked off the end of one list, or that answered the longer
# list, is separated here, and so is a body that stopped one position early --
# which is what separates this law from the one above. Both sides are closed and
# the left-hand side is a ground term.
law lcp_list_shorter_runs_out:
  {S.lcp_list(1n <> (2n <> Nil{}), 1n <> (2n <> (3n <> Nil{})))
     == 1n <> (2n <> Nil{}) : List<&2, Nat>}
