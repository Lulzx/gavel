import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there are no lists to join and so no gaps, and in particular the separator
# does not appear. Both sides compute, so this is definitional, and it is one of
# the two laws whose right-hand side does not call the target -- the anchor. It
# fixes the answer on the empty input, which the step law below never reaches.
law intercalate_nil:
  for sep: List<&2, Nat>
  {S.intercalate(sep, Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a one-element collection has no gap either, so its answer is that list and
# the separator does not appear. Both sides compute, so this is definitional too,
# and it is the half of the anchor the empty input does not cover: a body that
# emitted the separator around the only list, or that dropped it, satisfies the
# law above and is separated here. It names the input `xs <> Nil{}`, which the
# step law below does not reach.
law intercalate_single:
  for sep: List<&2, Nat>
  for xs: List<&2, Nat>
  {S.intercalate(sep, xs <> Nil{}) == xs : List<&2, Nat>}

# LAW: the step. Two or more lists answer the first, then the separator, then the
# joining of everything from the second list on. Both sides compute, so this is
# definitional, and it is the law that says where the separators go: a body that
# put the separator in front of the first list, or that recursed on the tail
# alone -- dropping the second list and with it one separator -- or that handed
# the recursive call a separator it had already spent, leaves the two sides
# unconvertible here. `P.append` is named on both sides, so the law fixes the
# placement of the gap as well as its presence.
law intercalate_cons:
  for sep: List<&2, Nat>
  for a: List<&2, Nat>
  for b: List<&2, Nat>
  for t: List<&2, List<&2, Nat>>
  {S.intercalate(sep, a <> (b <> t)) == P.append(a, P.append(sep, S.intercalate(sep, b <> t))) : List<&2, Nat>}

# LAW: with no separator the answer is the concatenation, whatever the lists are.
# This is the law with content, and the only one that is not definitional: the
# collection is a variable, so `intercalate` cannot take a step, nothing reduces,
# and the law takes an induction on `xss`. `P.concat` is an operation the body
# never calls, so the answer is read here as a concatenation of the lists rather
# than as a rearrangement of the target's own recursion, and the one-element
# branch of that induction is where the identity `P.append(xs, Nil{}) == xs` is
# needed, since a one-element collection is told apart from a longer one by
# whether its tail is empty.
law intercalate_nil_sep:
  for xss: List<&2, List<&2, Nat>>
  {S.intercalate(Nil{}, xss) == P.concat(xss) : List<&2, Nat>}
