import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: adding one element on the right adds `is_zero(x)` to the count. `append`
# matches on its first argument, so with a variable `xs` the goal does not
# reduce on its own: this one is inductive in `xs`.
#
# This law pins `count_zeros` on its own, and it pins what is counted rather
# than only how many elements there are. A body that ignores `xs` is a constant
# `k`, and the right-hand side is then `k + is_zero(x)`, which is stuck on a
# variable `x`; only `k = 0n` makes the left-hand side `0n`, and `1n` is not
# `is_zero(x)`. A body that returned the length would give `len(xs) + 1n` on the
# left against `len(xs) + is_zero(x)` on the right.
law count_zeros_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.count_zeros(P.append(xs, x <> Nil{})) == S.count_zeros(xs) + P.is_zero(x) : Nat}

# LAW: the empty list has no zeros. The recurrence above is *relative* -- it
# compares `count_zeros` with itself at a longer list -- so a constant offset is
# invisible to it: a body answering `1n` at `Nil{}` and adding `is_zero(h)` per
# cons satisfies the law at every `xs`, because the offset appears on both
# sides and cancels. Measured at tier 4, reward 1.000, with a hand-built proof
# (`match x` in the empty branch, `Policy.add_zero` for the residual `1n + 0n`).
# This closed equation is the anchor that sees it.
law count_zeros_nil:
  {S.count_zeros(Nil{}) == 0n : Nat}
