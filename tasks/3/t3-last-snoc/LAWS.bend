import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list answers the default. Both sides compute, so this one is
# definitional, and it is the weak half: it fixes what `last` answers when there
# is nothing to answer with, and a body that ignored the list entirely would
# satisfy it.
law last_nil:
  for d: Nat
  {S.last(Nil{}, d) == d : Nat}

# LAW: one step of the descent. Both sides compute, so this is definitional too,
# and it is the law that says the answer comes from the *tail*: a body that read
# the head and stopped -- `last(h <> t, d) == h` -- agrees with every value law
# below and leaves the two sides here unconvertible. The head becomes the new
# default, which is the whole of how `last` remembers what it has seen.
law last_cons:
  for h: Nat
  for t: List<&2, Nat>
  for d: Nat
  {S.last(h <> t, d) == S.last(t, h) : Nat}

# LAW: the last element of `xs` with `h` on the end is `h`, whatever the default
# is. This is the work, and the induction that suggests itself does not go
# through: its step case leaves the hypothesis at the *original* default while
# the goal has moved to `a`, because the head of the list became the default on
# the way down. Carrying `d` as a variable is what makes the hypothesis land,
# and that generalized statement is not asked for.
law last_snoc:
  for +xs: List<&2, Nat>
  for h: Nat
  for d: Nat
  {S.last(P.snoc(xs, h), d) == h : Nat}
