import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has no element, so it has no run to measure. Both sides
# compute, so this one is definitional, and it is the anchor: the step law below
# names its argument as a cons cell, so a body that answered anything but `0n`
# here is caught only by this one.
law longest_run_len_nil:
  {S.longest_run_len(Nil{}) == 0n : Nat}

# LAW: a one-element list is one block of one, so its longest run is `1n`. It is
# the other half of the anchor -- it says that a list with no equal neighbours
# at all still answers `1n` rather than `0n`, which is the reading of "run" this
# task uses -- and both sides compute.
law longest_run_len_single:
  for x: Nat
  {S.longest_run_len(x <> Nil{}) == 1n : Nat}

# LAW: the step. A run is either the block that starts at the first element or
# it lies inside the tail, and the longest one is the better of the two: the
# prelude's `P.run_len` measures the block that starts at the head in one pass,
# and the recursion measures the rest. This is the law that says what is being
# maximised, and it is the one a body that stopped at the first block, or that
# forgot the earlier positions, fails.
law longest_run_len_cons:
  for h: Nat
  for +t: List<&2, Nat>
  {S.longest_run_len(h <> t) == Nat.max(P.run_len(h <> t), S.longest_run_len(t)) : Nat}

# LAW: two equal elements are a run of two. This is the smallest input with a
# run in it that is longer than one element, and the law that pins the
# comparison as *equality of neighbours*: a body that counted positions rather
# than blocks, or that let a different pair count, answers something else here.
# Both sides compute.
law longest_run_len_one_pair:
  {S.longest_run_len(1n <> (1n <> Nil{})) == 2n : Nat}

# LAW: three elements with no two equal neighbours have no run longer than one,
# so the answer is `1n`. It is the other reading of the semantics, written with
# no variables: the block that starts at the first element ends immediately, and
# so does every block after it. Together with the pair law above it fixes both
# sides of the comparison -- equal neighbours extend a block, different ones end
# it -- on inputs where nothing has to be unfolded to see it. Both sides
# compute.
law longest_run_len_no_pair:
  {S.longest_run_len(1n <> (2n <> (3n <> Nil{}))) == 1n : Nat}
