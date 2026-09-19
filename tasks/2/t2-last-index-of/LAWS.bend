import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list holds no occurrence of anything, so the answer there is the
# sentinel, `0n` -- its own length. Both sides compute, so this is definitional,
# and it is a pin: it is the only law here whose left-hand side is a closed list,
# and it is the one input the step law below never reaches.
law last_index_of_nil:
  for k: Nat
  {S.last_index_of(Nil{}, k) == 0n : Nat}

# LAW: the step. A cons cell answers from the tail's side, because it is the
# *last* occurrence that is wanted: `P.has_k(t, k)` says whether the target
# still occurs in the tail, and when it does the tail's answer -- the last
# position in the tail -- is stepped on by one. When it does not, the head is
# the last chance: `0n` when the head is the target, and otherwise the tail's
# answer stepped on by one, which is the sentinel. Both sides compute, so this
# is definitional as well, and it is the law that says the head is compared and
# that the answer counts positions.
law last_index_of_step:
  for h: Nat
  for k: Nat
  for t: List<&2, Nat>
  {S.last_index_of(h <> t, k) == P.at_if(P.has_k(t, k), 1n + S.last_index_of(t, k), P.at_if(P.eq(h, k), 0n, 1n + S.last_index_of(t, k))) : Nat}

# LAW: nothing found is the length. The list searched is `P.inc_all(xs)`, in
# which nothing is `0n`, so no element is the target and the answer is the
# sentinel: one step per element over the empty list's `0n`, which is exactly
# `P.len(xs)`. It is the induction here, and it is what fixes the sentinel's
# value -- the step law leaves the empty list's answer free, and a body that
# answered any constant there agrees with the two laws above and fails this one.
law last_index_of_miss:
  for xs: List<&2, Nat>
  {S.last_index_of(P.inc_all(xs), 0n) == P.len(xs) : Nat}

# LAW: a hit at the head with nothing behind it is `0n`, whatever the rest of
# the list is. The step law is stated for a `+k` -- and the law above for a
# target that occurs nowhere in the list -- so neither of them unfolds the case
# where the head is the target and the tail holds nothing: `P.has_k` is stuck on
# the shifted tail, and `P.eq(k, k)` is stuck at a variable. This law says the
# head's own occurrence is recorded at `0n` when it is the last one, and it
# fixes the position the answer counts from.
law last_index_of_hit:
  for xs: List<&2, Nat>
  {S.last_index_of(0n <> P.inc_all(xs), 0n) == 0n : Nat}

# LAW: a later occurrence wins. When the head is the target *and* the target
# occurs again in the tail, the answer is the tail's answer stepped on by one --
# the head is not the last occurrence. This is the law that says *last* and not
# first: a body that answered the head's own position as soon as the head
# matched satisfies every law above and fails this one, since its answer is `0n`
# while the tail still holds the target.
law last_index_of_last_wins:
  for k: Nat
  for t: List<&2, Nat>
  {S.last_index_of(k <> t, k) == P.at_if(P.has_k(t, k), 1n + S.last_index_of(t, k), 0n) : Nat}
