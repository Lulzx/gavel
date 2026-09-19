import Base
import ./prelude.bend as P
import ./solution.bend as S

# The two laws that say what the halves of the answer are reach the answer
# through the prelude's accessors, `P.zfst` and `P.zsnd`, because a record is
# not a constructor a law can take apart. The law about the empty list spells
# the record out instead, since at `Nil{}` there is nothing left to reach
# through.

# LAW: unzipping no pairs gives two empty lists. The left-hand side is a ground
# term and both sides compute, so this is definitional: it fixes the answer the
# recursion reaches when there is nothing left to unzip, and a body that
# answered a pair or an element there would satisfy both cons laws at every
# non-empty input. An empty case is an answer a stopped match gives rather than
# a step, so nothing else in this file looks at it.
law unzip_nil:
  {S.unzip(Nil{}) == P.MkZ{Nil{}, Nil{}} : P.ZP}

# LAW: the first list of the answer starts with the first component of the head
# pair and continues with the first list of the unzipped tail. Both sides
# compute, so this is definitional, and it is the law that fixes *which half
# goes where*: a body that put the second components in the first list leaves
# the two sides unconvertible.
law unzip_cons_fst:
  for a: Nat
  for b: Nat
  for +t: List<&2, P.Pair>
  {P.zfst(S.unzip(P.Mk{a, b} <> t)) == a <> P.zfst(S.unzip(t)) : List<&2, Nat>}

# LAW: the same law for the second list. It is separate because a body that
# returned the two halves swapped satisfies the first one exactly as well as the
# right one does, and this is the law that does not.
law unzip_cons_snd:
  for a: Nat
  for b: Nat
  for +t: List<&2, P.Pair>
  {P.zsnd(S.unzip(P.Mk{a, b} <> t)) == b <> P.zsnd(S.unzip(t)) : List<&2, Nat>}

# LAW: the first list has as many elements as the input had pairs. Nothing above
# this fixes the *length* of the halves -- the two cons laws say how each half
# grows by one at a step, which a body that dropped the last pair, or that
# stopped early, can satisfy on the prefix it does produce. This law is not
# definitional: with the input a variable, neither side reduces, and the step is
# the induction hypothesis.
law unzip_len_fst:
  for ps: List<&2, P.Pair>
  {P.llen(P.zfst(S.unzip(ps))) == P.plen(ps) : Nat}

# LAW: the second list has as many elements as the input had pairs, for the same
# reason. Both length laws are stated against `P.plen`, which counts the input
# the policy did not write, so neither of them is satisfied by a body that
# counted its own answer.
law unzip_len_snd:
  for ps: List<&2, P.Pair>
  {P.llen(P.zsnd(S.unzip(ps))) == P.plen(ps) : Nat}
