import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has nothing to repeat, so the answer is the empty list
# whatever `n` is. Both sides compute, and the right-hand side calls no target --
# this is the absolute anchor. It is the only law that reaches the empty input
# through `replicate_each` itself, and it is read at a variable `n`, so a body
# that answered a copy of something for nothing, or that answered a cell for the
# empty list, is caught here and nowhere else.
law replicate_each_nil:
  for n: Nat
  {S.replicate_each(Nil{}, n) == Nil{} : List<&2, Nat>}

# LAW: repeating every element zero times leaves nothing behind, whatever the
# list is. This is the law with content: the list is a variable, so the match
# does not reduce on its own and the induction is the proof. It is also the law
# that pins the *count* rather than the arrangement: a body that emitted one copy
# per element, or a copy per element regardless of `n`, satisfies the step law
# below -- which is stated at a variable `n` and cannot see what `0n` does -- and
# is separated here.
law replicate_each_zero:
  for +xs: List<&2, Nat>
  {S.replicate_each(xs, 0n) == Nil{} : List<&2, Nat>}

# LAW: the hand-off from the answer to the copies of one element. A non-empty
# list repeats its head `n` times and puts the copies of its tail after them.
# Both sides compute, so this is definitional, and it is the law that says the
# element's copies come *before* the rest and that the rest is the answer for the
# tail with the same `n`: a body that put the tail first, or that recursed with a
# different `n`, leaves the two sides unconvertible here.
law replicate_each_cons:
  for +n: Nat
  for +x: Nat
  for +t: List<&2, Nat>
  {S.replicate_each(x <> t, n) == P.append(P.rep(x, n), S.replicate_each(t, n)) : List<&2, Nat>}

# LAW: repeating every element once is the list itself, whatever the list is.
# The list is a variable, so nothing reduces and the induction is the proof. It
# is the second law that reads the count rather than the arrangement: a body that
# repeated each element some fixed number of times other than `n`, or that put
# the copies of each element on the wrong side of the answer, is separated here
# even where the values still line up.
law replicate_each_one:
  for +xs: List<&2, Nat>
  {S.replicate_each(xs, 1n) == xs : List<&2, Nat>}

# LAW: one closed list, read element by element. `[1n, 2n]` with `2n` repeats is
# `[1n, 1n, 2n, 2n]`: the copies of the first element, then the copies of the
# second. Both sides are closed, so every match reduces. A body that repeated the
# whole list `n` times -- `[1n, 2n, 1n, 2n]` -- or that emitted the copies of the
# last element first, satisfies several of the laws above and is separated here.
law replicate_each_two:
  {S.replicate_each(1n <> (2n <> Nil{}), 2n) == 1n <> (1n <> (2n <> (2n <> Nil{}))) : List<&2, Nat>}
