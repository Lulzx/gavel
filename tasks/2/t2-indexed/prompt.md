Implement `indexed` on a list of `Nat`, then prove all four laws.

`indexed(xs)` packs every element with the position it is at, counting from
`0n`: `indexed([5n, 6n])` is `[P.MkIndexed{0n, 5n}, P.MkIndexed{1n, 6n}]`. The
count has to travel with the recursion, so the work is done by a helper that
takes the position as a second argument, and `indexed` is that helper started at
`0n`. The helper recurses on the list and steps the position by one on the way
down. The list is the argument that shrinks, and Bend reads a self-call's
arguments left to right -- each passed unchanged until one shrinks -- so the
list comes first and the position second. The position is read twice in the
step, once into the pair and once into the recursive call, so it is declared
reusably (`+i`).

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.MkIndexed{i, x}`, the record the prelude declares; `P.len`, the length of a
list of `Nat`; `P.plen`, the length of a list of index pairs -- `len` does not
take the pair type and `plen` does not look inside a pair; and `P.elems`, which
projects a list of pairs back to its elements in order.

`indexed_zero` ties the two targets together. It says `indexed` is the helper
started at zero, and it is the only law here that mentions `indexed` at all --
every other law is stated over the helper, so a body that wrote the counting out
by hand in `indexed`, or that started it at the wrong position, is caught by
this law and nothing else. There is deliberately no law pinning `indexed` on the
empty list on its own: this one already implies it, since the helper answers
`Nil{}` there, and a law that only ever fails when another one does is weight
the corpus does not need.

`indexed_cons` is the step: the head is paired with the position it is at, and
the tail is numbered from the next position on. It is the law that says which
number goes with which element, and it is definitional, since both sides compute
to the same pair in front of the same call.

`indexed_len` and `indexed_elems` are the two laws that are not definitional:
with the list a variable the helper cannot take a step, so the two sides do not
compute and the induction on the list is the proof. Both are inductions of the
same shape, on the list, with the position moved on by one in the hypothesis.
`indexed_len` reads the answer as a number of pairs -- the positions run out
exactly when the elements do -- and `indexed_elems` reads it as the elements
themselves -- throwing the positions away gives the input back in the order it
came in. The second is the sharper of the two: a body that kept the right number
of pairs but filled them with the wrong elements, reading one element twice or
writing an element's successor in its place, satisfies the count law and is
caught only here.

Together the laws determine both targets: `indexed` is `indexed_zero` applied to
the helper, and the helper is `indexed_cons` on a non-empty list, the induction
laws at the empty one, so the induction on the list settles it.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.indexed_zero(xs)`, `def L.indexed_cons(x, t, i)`, `def L.indexed_len(xs,
i)` and `def L.indexed_elems(xs, i)`.
