Implement `lex_le` on two lists of `Nat`, then prove the five laws about it.

`lex_le(xs, ys)` answers whether `xs` comes at or before `ys` in
lexicographic order: the empty list is at or before anything, a non-empty list
against the empty one is not, and two cons cells are decided by their heads --
when the first head is strictly below the second the answer is yes, and only
when the two heads are equal does the comparison fall through to the tails,
whose own answer is the result. A shorter list that is a prefix of a longer one
is the smaller of the two. The answer is a `Bool`, not a list and not a count.

Both lists are `List<&2, Nat>`, which is `Data` so a binder may be marked
reusable. The prelude is immutable and carries the vocabulary the laws are
stated in: `P.eq(a, b)` is `True{}` exactly when the two numbers are equal,
`P.lt(a, b)` is `True{}` exactly when the first is strictly below the second,
and `P.append(xs, ys)` is `xs` followed by `ys`. Neither comparison reduces on
a pair of variables, so no number is below or unequal to itself by unfolding.

Step on the first list, and step the second alongside it: `Nil{}` on the left
answers `True{}`, a cons cell against `Nil{}` answers `False{}`, and two cons
cells answer the `Bool.or` of the heads' `P.lt` with the `Bool.and` of their
`P.eq` and the tails' own comparison.

`lex_le_nil_left` and `lex_le_nil_right` fix the two ways the walk can run out;
both are definitional and both are absolute anchors, since their right-hand
sides are the constants `True{}` and `False{}` and call no target.
`lex_le_nil_right` is the only law whose left-hand side is ground in *both*
arguments, and the step law never reaches `Nil{}` on the right, so it alone
fixes what a list running out on the right answers. `lex_le_cons` writes the
walk out, with both heads and both tails named.

`lex_le_self` is the law with content: a list is at or before itself, at every
list, so its right-hand side is `True{}`. A body that answered `False{}` on a
tie, or that treated a tie as a decision instead of falling through to the
tails, satisfies the three laws above and is separated here. `lex_le_append`
says a list is at or before its own extension, at every `ys` -- which is what
makes a shorter prefix the smaller -- and its second argument is what separates
a body that stops before the tails. Both are inductive in `xs`, because the
walk and `P.append` both match on `xs` and a variable does not reduce.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.lex_le_nil_left(ys)`, `def L.lex_le_nil_right(h, t)`,
`def L.lex_le_cons(h, t, k, u)`, `def L.lex_le_self(xs)` and
`def L.lex_le_append(xs, ys)`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
