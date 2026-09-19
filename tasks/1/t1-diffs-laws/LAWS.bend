import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has no successive pairs to subtract. Both sides compute,
# so this one is definitional, and it is a pin: it fixes the answer on the empty
# input, which neither of the two laws below reaches.
law diffs_nil:
  {S.diffs(Nil{}) == Nil{} : List<Nat>}

# LAW: a one-element list has no successive pair either. Both sides compute, so
# this is definitional too. The step law below constrains only lists of two or
# more elements -- it names `a <> (b <> t)` -- so without this one a body that
# answered a non-empty list here would satisfy it, and without the step law this
# one would say nothing about any longer list.
law diffs_single:
  for x: Nat
  {S.diffs(x <> Nil{}) == Nil{} : List<Nat>}

# LAW: the step. Two or more elements answer the difference of the first two in
# front of the differences of everything from the second on. Both sides compute,
# so this is definitional, and it is the law that says *which* differences: a
# body that dropped the first element instead -- answering `S.diffs(b <> t)` --
# leaves the two sides unconvertible here, and agrees with the two laws above.
law diffs_cons:
  for a: Nat
  for b: Nat
  for t: List<Nat>
  {S.diffs(a <> (b <> t)) == P.sub(b, a) <> S.diffs(b <> t) : List<Nat>}

# LAW: the answer is exactly one element shorter than the input -- the first
# element is the one that has nothing before it to be subtracted from. This is
# the law that is not definitional: `diffs` is stuck on a variable `x` on the
# front, so with a variable `xs` the two sides do not compute, and the induction
# is the proof. It is the length half of the pair above, which is about which
# numbers come out; this one is about how many there are.
law diffs_len:
  for xs: List<Nat>
  for x: Nat
  {P.len(S.diffs(x <> xs)) == P.len(xs) : Nat}
