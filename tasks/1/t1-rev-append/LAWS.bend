import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list reverses to itself. This is the base the step below needs
# to be a recursion rather than one equation, and it was missing.
#
# **Measured 2026-09-19: without this law the task pays a wrong body full
# reward.** `reverse(xs) = Policy.rev_core(xs) ++ [0n]` -- the reference with
# one extra element appended, which is not the reference at any list -- reached
# **tier 4, complete, reward 1.000, `rev_append` proven** under a hand-written
# proof (probe `/tmp/esc/t1rev/`). The comment that used to sit here argued that
# `rev_append` pinned `reverse` on its own because a body that *dropped* the
# list would differ on the right. That argument is true and it is not enough: it
# rules out bodies that ignore the argument, and says nothing about bodies that
# post-compose. Every `append(rev_core(xs), c)` satisfies the relative law for a
# constant `c`, because the law compares two applications of `reverse` and the
# constant cancels. A relative law cannot be an absolute anchor.
#
# With the anchor the pair is a complete recursion: read at the last element,
# `rev_append` reconstructs `reverse` for any non-empty list, and this law
# settles the empty one.
law rev_nil:
  {S.reverse(Nil{}) == Nil{} : List<Nat>}

# LAW: reversing a list that ends in one new element puts that element on the
# left. `append` matches on its first argument, so with a variable `xs` the goal
# does not reduce on its own: this one is inductive in `xs`.
#
# This is the step half of the recursion; `rev_nil` above is the base half. The
# general form, `reverse(append(xs, ys)) == append(reverse(ys), reverse(xs))`,
# is weaker still and is not used here.
law rev_append:
  for xs: List<Nat>
  for x: Nat
  {S.reverse(P.append(xs, x <> Nil{})) == x <> S.reverse(xs) : List<Nat>}
