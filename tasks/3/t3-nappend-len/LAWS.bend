import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing at all. Both sides compute, so this one is definitional, and it
# is the weak half: it fixes what repeating a list zero times means, and a body
# that ignored `n` entirely would satisfy it.
law nappend_zero:
  for xs: List<&2, Nat>
  {S.nappend(xs, 0n) == Nil{} : List<&2, Nat>}

# LAW: one step of the repetition. Both sides compute, so this is definitional
# too, and it is the law that says the answer is built by *concatenating*: a
# body that answered `xs` on every successor -- which agrees with the value law
# below on a one-element list -- leaves the two sides here unconvertible.
law nappend_succ:
  for xs: List<&2, Nat>
  for p: Nat
  {S.nappend(xs, 1n + p) == P.append(xs, S.nappend(xs, p)) : List<&2, Nat>}

# LAW: the length of `n` copies is `n` times the length. This is the work. Its
# step needs the length of an `append`, which the prelude does not have and
# which is an induction of its own: `append` matches on its first argument, so
# the goal is stuck on a variable until something inducts on that list too.
law nappend_len:
  for +xs: List<&2, Nat>
  for n: Nat
  {P.len(S.nappend(xs, n)) == n * P.len(xs) : Nat}
