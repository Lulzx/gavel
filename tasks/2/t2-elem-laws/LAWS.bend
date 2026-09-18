import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list holds no zero. It is definitional, and it is the weak
# half: the constant body `False{}` satisfies it.
law elem_zero_nil:
  {S.elem_zero(Nil{}) == False{} : Bool}

# LAW: adding one element on the right ors in that element's zero test.
# `append` matches on its first argument, so with a variable `xs` the goal does
# not reduce on its own: this one is inductive in `xs`, and it is the law that
# pins `elem_zero`. Alone it is satisfied by the constant body `True{}`, because
# `or` absorbs `True{}` on either side; the base law is what rules that body
# out. The constant body `False{}` fails it: the right-hand side is then
# `is_zero_b(x)`, which is stuck on a variable `x`.
law elem_zero_snoc:
  for xs: List<Nat>
  for x: Nat
  {S.elem_zero(P.append(xs, x <> Nil{})) == Bool.or(S.elem_zero(xs), P.is_zero_b(x)) : Bool}
