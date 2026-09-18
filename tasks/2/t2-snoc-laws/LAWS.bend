import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: putting `x` at the end of the empty list is the one-element list. Alone
# it does not pin `snoc`: a body that ignores the list and answers `x <> Nil{}`
# satisfies it.
law snoc_nil:
  for x: Nat
  {S.snoc(Nil{}, x) == x <> Nil{} : List<Nat>}

# LAW: `snoc` on a concatenation is `snoc` of the second half, with the first
# half left as it was. `append` matches on its first argument, so with a
# variable `xs` the left-hand side does not reduce on its own: this one is
# inductive in `xs`. It is the law that pins `snoc` -- the constant body and a
# body that puts `x` at the front both fail it.
law snoc_append:
  for xs: List<Nat>
  for ys: List<Nat>
  for x: Nat
  {S.snoc(P.append(xs, ys), x) == P.append(xs, S.snoc(ys, x)) : List<Nat>}
