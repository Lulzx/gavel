import Base

# `append` recurses on its *second* argument, so it computes `ys <> xs`. Every
# law in the pre-repair set was about `len`, and a permutation has the same
# length as the concatenation, so all of them held of this body at every input.
#
# **Measured tier 4, complete, reward 1.000** on 2026-09-19, with a hand-written
# proof of the pre-repair laws. That is the finding: the set then in place
# mentioned order nowhere, so `len_cons` and `len_append` were provable of a
# function that puts the two lists in the other order. A cardinality cannot see
# a permutation.
#
# Re-measured as a corpus entry -- same body, the *reference* proof:
#
#   tier 3 (partial), 4 laws, proven: len_cons,
#   failed: len_append, append_cons, append_nil_left
#
# Re-measured again, unchanged body, now against the *escape's own* hand-written
# proof from the first measurement:
#
#   tier 3 (partial), reward 0.350, proven: len_cons, len_append,
#   failed: append_cons, append_nil_left
#
# That second pair is the evidence that the repair works: the same submission
# and the same proof that read 1.000 now read 0.350, and the two laws it cannot
# prove are exactly the two that were added.
#
# Which of the three failures are semantic and which are proof shape: only
# **`append_cons`** is a semantic catch. `ys <> (h <> t)` and `h <> (ys <> t)`
# are different lists, so at a variable `ys` the statement is false of this body
# and no proof exists. The other two fail at the `{==}` steps of the reference
# proof, which are definitional only for a body that matches on its *first*
# argument; this body matches on its second, so the goals are stuck rather than
# false. Whether `len_append` and `append_nil_left` are *true* of this body is
# not settled by these runs, and the corpus entry should not be read as settling
# it -- `len_append` was proven of it above.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match ys:
    case Nil{}:
      xs
    case h <> t:
      h <> append(xs, t)

def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
