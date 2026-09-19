import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list of lists concatenates to the empty list. The base the step
# below needs, and it was missing -- the same defect as `t1-rev-append`'s, in the
# same shape, found in the same sweep.
#
# **Measured 2026-09-19: without this law the task pays a wrong body full
# reward.** `concat(xss) = 0n <> Policy.flat(xss)` -- the reference with a
# constant prefix, which is not the reference at any list of lists -- reached
# **tier 4, complete, reward 1.000, `concat_append` proven** under a
# hand-written proof (probe `/tmp/esc/t1con/`). The comment that used to sit here
# argued that `concat_append` pinned `concat` because the only body that ignores
# `xss` is `Nil{}`. That is true and it is the wrong question: a body does not
# have to ignore its argument to disagree with the reference, it can wrap its
# result, and the relative law is blind to any wrapper that cancels on both
# sides. `append(A, flat(xss))` satisfies it for every constant `A`.
#
# With the anchor the pair is a complete recursion at the last element, exactly
# as `rev_nil`/`rev_append` is for `reverse`.
law concat_nil:
  {S.concat(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: concatenating a list of lists that ends in one more list is the same as
# appending that list to the concatenation. `append_ll` matches on its first
# argument, so with a variable `xss` the goal does not reduce on its own: this
# one is inductive in `xss`.
#
# This is the step half of the recursion; `concat_nil` above is the base half.
# It also fixes the order: a `concat` that flattens the outer list backwards
# fails it.
law concat_append:
  for xss: List<&2, List<&2, Nat>>
  for ys: List<&2, Nat>
  {S.concat(P.append_ll(xss, ys)) == P.append(S.concat(xss), ys) : List<&2, Nat>}
