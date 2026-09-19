import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has nothing to pack, so the answer is the empty list,
# whatever the constant is. Both sides compute, so this is definitional, and it
# is a pin: it fixes the answer on the empty input, which the step law below
# never reaches, and it is the only law here whose left-hand side is a closed
# list.
law zip_with_const_nil:
  for k: Nat
  {S.zip_with_const(Nil{}, k) == Nil{} : List<&2, P.Pair>}

# LAW: the step. A cons cell is packed with the constant in front of the tail's
# answer. Both sides compute, so this is definitional, and it is the law that
# says which number goes in which component and which list is recursed on: a
# body that built `P.MkPair{k, h}`, or that recursed on the whole list, leaves
# the two sides here unconvertible. `P.MkPair` is the prelude's record, so the
# law reaches into the pair rather than taking one apart.
law zip_with_const_step:
  for h: Nat
  for +k: Nat
  for t: List<Nat>
  {S.zip_with_const(h <> t, k) == P.MkPair{h, k} <> S.zip_with_const(t, k) : List<&2, P.Pair>}

# LAW: the first components of the answer are the input, element for element, in
# order. This is the law with content, and the one that pins the component the
# pairs are keyed on: a body that packed each element with its neighbour, or
# that dropped the last element, satisfies the two laws above on the prefix it
# does produce and leaves the two sides here unconvertible. Its right-hand side
# is the binder `xs` and calls no target. The list is a variable, so `P.fsts`
# does not reduce -- it matches on the list of pairs the recursion has not built
# yet -- and the induction on the list is the proof.
law zip_with_const_fsts:
  for xs: List<Nat>
  for k: Nat
  {P.fsts(S.zip_with_const(xs, k)) == xs : List<Nat>}

# LAW: the second components of the answer are the constant, once per element:
# nothing else is ever packed. It is stated against the prelude's `P.repeat` and
# `P.len` and not against anything the policy writes, its right-hand side calls
# no target, and it is inductive in the list for the same reason as the law
# above. A body that answered a constant in the first component and the element
# in the second leaves the two sides here unconvertible, since the input's
# elements are not the constant once the list is a variable.
law zip_with_const_snds:
  for xs: List<Nat>
  for +k: Nat
  {P.snds(S.zip_with_const(xs, k)) == P.repeat(P.len(xs), k) : List<Nat>}
