import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty left list zips to nothing. Both sides compute, so this one is
# definitional, and it is the weak half: it fixes what `zip` answers when there
# is nothing to pair with.
law zip_nil_l:
  for ys: List<&2, Nat>
  {S.zip(Nil{}, ys) == Nil{} : List<&2, P.P2>}

# LAW: an empty right list zips to nothing. The left list is a variable, so the
# match in `zip` is stuck and this one is an induction rather than an unfolding
# -- which is what makes it worth stating: a body that paired the first elements
# and stopped, or one that read `ys` first, satisfies `zip_nil_l` and leaves the
# two sides here unconvertible.
law zip_nil_r:
  for +xs: List<&2, Nat>
  {S.zip(xs, Nil{}) == Nil{} : List<&2, P.P2>}

# LAW: one step of the pairing, with both lists conses. Both sides compute, so
# this is definitional, and it is the law that says *which* element goes into
# which component of the pair. Without it the set does not pin the body at all:
# the swapped body `P.Mk{hy, hx}` satisfies both nil laws and the length law
# below, because none of them ever looks inside a pair.
law zip_cons:
  for hx: Nat
  for tx: List<&2, Nat>
  for hy: Nat
  for ty: List<&2, Nat>
  {S.zip(hx <> tx, hy <> ty) == P.Mk{hx, hy} <> S.zip(tx, ty) : List<&2, P.P2>}

# LAW: `zip` stops at whichever list runs out first, so it has as many elements
# as the shorter one. This is the work, and it is the law that says which list
# runs out: a body that dropped the shorter list's length and answered the
# longer one's -- `zlen(zip(xs, ys)) == len(xs)`, say -- satisfies both pins and
# leaves the two sides here unconvertible whenever `ys` is shorter.
law zip_len:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {P.zlen(S.zip(xs, ys)) == P.min(P.len(xs), P.len(ys)) : Nat}
