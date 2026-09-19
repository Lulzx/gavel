import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the first list running out ends the walk. Both sides compute, so this one
# is definitional, and it is the anchor no other law here duplicates: the step
# law below names its first argument as a cons cell, so a body that answered the
# empty first list with anything but `0n` is caught only by this one.
law dot_nil_left:
  for ys: List<Nat>
  {S.dot(Nil{}, ys) == 0n : Nat}

# LAW: the second list running out ends the walk too, and the answer there is
# `0n` as well. The law above fixes the answer only when it is the *first* list
# that is empty, so a body that recursed on its second list and stopped at the
# wrong one would not be touched by it. With a variable `xs` the outer match is
# stuck, so this one is the induction on `xs`.
law dot_nil_right:
  for xs: List<Nat>
  {S.dot(xs, Nil{}) == 0n : Nat}

# LAW: the step, with both elements spelled out. `dot` is a sum of pairwise
# products and not a count or a list: this law says the pair contributes
# `Nat.mul` of the two heads and that the walk carries on with both tails. Both
# sides compute here, so it costs one `{==}`, and it is the law a body that
# added instead of multiplying, or read the same list twice, fails.
law dot_cons:
  for h1: Nat
  for t1: List<Nat>
  for h2: Nat
  for t2: List<Nat>
  {S.dot(h1 <> t1, h2 <> t2) == Nat.mul(h1, h2) + S.dot(t1, t2) : Nat}

# LAW: the walk stops at the shorter list, so the elements past its end change
# nothing. Truncating the second list to the first one's length and walking that
# is walking the original: this is the law that pins the *stopping rule* rather
# than the shape of one step, and a body that read on past the end of either
# list -- padding the short one out, or walking to the longer one -- fails it.
law dot_shorter:
  for xs: List<Nat>
  for ys: List<Nat>
  {S.dot(xs, ys) == S.dot(xs, P.take(P.len(xs), ys)) : Nat}
