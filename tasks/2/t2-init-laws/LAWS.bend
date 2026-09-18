import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a one-element list has nothing before its last element. It is
# definitional, and it is the weak half: the constant body `Nil{}` satisfies it.
law init_single:
  for h: Nat
  {S.init(h <> Nil{}) == Nil{} : List<Nat>}

# LAW: dropping the last element of `xs <> [x]` gives back `xs`. `append`
# matches on its first argument, so with a variable `xs` the left-hand side does
# not reduce on its own: this one is inductive in `xs`. Together the two laws
# pin `init` -- the constant body fails this one, and the identity body, which
# hands back the list it was given, fails the base law.
law init_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.init(P.append(xs, x <> Nil{})) == xs : List<Nat>}
