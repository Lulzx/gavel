import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing is rotated by nothing. Both sides compute, so this is
# definitional, and it is a pin: the step law below is stated at `1n + n`, so it
# never reaches the input where no rotation happens, and a body whose `0n` case
# dropped the list -- answering `Nil{}` or a rotation of the tail -- is caught
# only here.
law rotate_zero:
  for xs: List<&2, Nat>
  {S.rotate(0n, xs) == xs : List<&2, Nat>}

# LAW: the step. One rotation cuts the head off and appends it to the tail, and
# the remaining `n` rotations carry on from there. Both sides compute, so this
# is definitional, and it is the law that says where the elements go: a body
# that appended the head to the *front*, or that recursed on `t` -- dropping the
# head and with it an element -- leaves the two sides unconvertible. The list is
# named as `x <> t` rather than left as a variable, because a rotation of a
# variable list has no first element to move.
law rotate_succ:
  for n: Nat
  for x: Nat
  for t: List<&2, Nat>
  {S.rotate(1n + n, x <> t) == S.rotate(n, P.append(t, x <> Nil{})) : List<&2, Nat>}

# LAW: there is nothing to rotate out of the empty list, so no number of
# rotations produces anything. This is the law that is not definitional: `n` is
# a variable, so `rotate` cannot take a step, and the induction on `n` is the
# proof. It is the law that pins the one input the laws above cannot reach --
# the step law is stated at `x <> t`, so it constrains only non-empty lists, and
# a body whose empty answer grew an element satisfies every law above and this
# one is what separates it.
law rotate_nil:
  for n: Nat
  {S.rotate(n, Nil{}) == Nil{} : List<&2, Nat>}
