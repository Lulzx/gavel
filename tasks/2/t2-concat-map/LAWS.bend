import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: an empty list has nothing to expand, so nothing comes back. Both sides
# compute, so this is definitional, and it is a pin: it fixes the answer on the
# empty input, which the step law below never reaches -- the step names
# `h <> t`, so a body that answered a non-empty list here would leave the two
# sides of that law unconvertible and would not be touched by it.
law concat_map_nil:
  {S.concat_map(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: the step. The head expands to `P.expand(h)` -- the element followed by
# its successor -- and that is appended to the concatenation of the rest, in one
# pass. Both sides compute, so this is definitional, and it is the law that says
# which list the head becomes and that the recursion is on the tail.
law concat_map_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.concat_map(h <> t) == P.append(P.expand(h), S.concat_map(t)) : List<&2, Nat>}

# LAW: one pass is the same as two. `concat_map` is `concat` after mapping
# `expand`, which is the law that relates the target to the fixed functions of
# the prelude rather than to itself. The list is a variable, so with `xs`
# neither side reduces: this one is the induction on `xs`, and its step is one
# use of the hypothesis, since both sides have `P.expand`'s head in front of a
# call on `t`.
law concat_map_concat:
  for xs: List<&2, Nat>
  {S.concat_map(xs) == P.concat(P.map_expand(xs)) : List<&2, Nat>}

# LAW: the count half, and the second law here that is not definitional. Every
# element of the input contributes exactly two to the answer, so the answer is
# as long as `P.elen` says. This is what the composition law above does not say:
# that one fixes *which* list the answer is, and this one is stated without
# mentioning `concat`, `map_expand` or `append` at all, so a body that emitted
# the wrong number of elements is caught here even when it agrees with the
# composition.
law concat_map_len:
  for xs: List<&2, Nat>
  {P.len(S.concat_map(xs)) == P.elen(xs) : Nat}
