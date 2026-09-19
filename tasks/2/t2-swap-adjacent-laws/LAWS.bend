import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing to exchange on the empty list. Both sides compute, so this one is
# definitional, and it is the pin on an answer generated mutants reach least:
# the step law names two elements or more, so a body that answered a non-empty
# list at `Nil{}` is caught here and nowhere else.
law swap_adjacent_nil:
  {S.swap_adjacent(Nil{}) == Nil{} : List<Nat>}

# LAW: a lone element has no neighbour and is *kept*. Both sides compute, so
# this is definitional too, and it is the only law that says the odd tail
# survives: `swap_adjacent_cons` names lists of two or more, so a body that
# dropped the element, or that answered the empty list there, satisfies it and
# contradicts this one.
law swap_adjacent_single:
  for x: Nat
  {S.swap_adjacent(x <> Nil{}) == x <> Nil{} : List<Nat>}

# LAW: the step, and the law that says which element goes where. Both sides
# compute, so this is definitional: two elements or more answer the second in
# front of the first, in front of the swaps of everything from the *third*
# element on. A body that recursed on `y <> t` instead of on `t` answers a
# longer list here, and a body that left the pair alone never converts.
law swap_adjacent_cons:
  for x: Nat
  for y: Nat
  for t: List<Nat>
  {S.swap_adjacent(x <> (y <> t)) == y <> (x <> S.swap_adjacent(t)) : List<Nat>}

# LAW: the result has as many elements as the input. `len` matches on its first
# argument, so with a variable list the goal does not reduce on its own: this one
# is inductive, and it is the law that pins the count, which the step law leaves
# open -- a body that dropped an element of a pair, or that dropped the odd tail
# and answered the empty list instead, satisfies the step law and fails here.
law swap_adjacent_len:
  for xs: List<Nat>
  {P.len(S.swap_adjacent(xs)) == P.len(xs) : Nat}

# LAW: swapping twice is the identity. This is the work, and it is inductive:
# with a variable list neither side computes, since `swap_adjacent` is stuck
# until its argument is a cons. It is the law that pins the shape of the answer
# rather than its contents -- a body that reversed the list agrees with the step
# law on the first two elements and disagrees here -- and it is not implied by
# `swap_adjacent_cons`, which says nothing about the swaps of the rest.
law swap_adjacent_involutive:
  for xs: List<Nat>
  {S.swap_adjacent(S.swap_adjacent(xs)) == xs : List<Nat>}
