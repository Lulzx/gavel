import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a pad of zero leaves the list alone. Both sides compute, so this is a
# definitional companion: it fixes the empty case and rules out a body that
# extended every list it was handed.
law pad_nil:
  for x: Nat
  for xs: List<Nat>
  {S.pad(0n, x, xs) == xs : List<Nat>}

# LAW: padding one element onto nothing gives that element. Also definitional,
# and also a companion: with the length law alone, the element the pad is
# filled with could be anything.
law pad_single:
  for x: Nat
  {S.pad(1n, x, Nil{}) == x <> Nil{} : List<Nat>}

# LAW: the padded list is as long as the target length or as long as the input,
# whichever is larger. This is the induction, and it is stated exactly rather
# than as a bound. The identity body -- `pad(n, x, xs) = xs`, the first
# parameter of the return type -- fails it as soon as the target length
# outruns the list, and the constant body `Nil{}` fails it everywhere. Its
# step case is one use of the hypothesis plus a fact about `P.max` at a
# variable on the right, which is not definitional.
law pad_len:
  for n: Nat
  for x: Nat
  for xs: List<Nat>
  {P.len(S.pad(n, x, xs)) == P.max(n, P.len(xs)) : Nat}
