import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty number increments to one. Both sides compute, so this one is
# definitional: it fixes what `inc_bin` answers when there is nothing to carry
# into, and a body that answered `Nil{}` everywhere would satisfy it.
law inc_bin_nil:
  {S.inc_bin(Nil{}) == P.I{} <> Nil{} : List<&2, P.Bit>}

# LAW: a low bit of `O{}` is set. Both sides compute, so this is definitional
# too, and it is what says the increment touches the *low* bit: a body that
# answered `O{} <> t` -- or that carried into the wrong end -- leaves the two
# sides of this unconvertible.
law inc_bin_zero:
  for t: List<&2, P.Bit>
  {S.inc_bin(P.O{} <> t) == P.I{} <> t : List<&2, P.Bit>}

# LAW: the number one more than `bs` reads as one more than `bs`. This is the
# work. The `I{}` case is where the carry goes: the answer is `O{}` with a
# carried increment on the tail, so the goal is about `to_nat` of a *recursive*
# `inc_bin`, and the induction hypothesis is the only thing that can rewrite it.
# What is left over is arithmetic the prelude does not have -- `x + (1n + x)` is
# `1n + (x + x)`, which is a fact about `+` matching on its left argument.
law to_nat_inc:
  for +bs: List<&2, P.Bit>
  {P.to_nat(S.inc_bin(bs)) == 1n + P.to_nat(bs) : Nat}
