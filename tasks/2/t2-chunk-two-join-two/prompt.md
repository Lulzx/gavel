Implement `chunk_two` and `join_two` on a list of `Nat`, then prove all six laws.

`chunk_two(xs)` groups the elements of `xs` in twos, left to right:
`chunk_two([1n, 2n, 3n, 4n])` is `[P.MkPair{1n, 2n}, P.MkPair{3n, 4n}]`. An
element left without a partner is dropped, so `chunk_two([1n])` is `Nil{}` and
`chunk_two(Nil{})` is `Nil{}`. Both matches are needed: the outer one splits off
the first element, and the inner one on the tail tells you whether there is a
second. The groups are built with `P.MkPair{a, b}`, the record the prelude
declares.

`join_two(ps)` is the other direction: it writes each record out flat, its two
halves in order, so `join_two([P.MkPair{1n, 2n}, P.MkPair{3n, 4n}])` is
`[1n, 2n, 3n, 4n]`.

The prelude is immutable, and `P.MkPair{a, b}` is the only thing in it. It is
the record the two functions pass each other, so it is what the laws are stated
over: a pair has no place in the element type, and the laws about `chunk_two`
have to talk about the records it produces.

`chunk_two_nil` fixes the answer on an empty input and `chunk_two_single` on a
lone element; the step law below names lists of two or more elements, so neither
covers the other's input. `chunk_two_single` is what catches a body that packed
the unpaired element with a default instead of dropping it, and
`chunk_two_cons` is what says which element lands in which half -- it is the
only law here that looks inside a record, so a body that built `P.MkPair{y, x}`
agrees with every other law about `chunk_two` and fails this one.

`join_two_nil` and `join_two_cons` do the same two jobs on the way back: the
empty answer, and the halves in the order they were grouped.

`chunk_two_join_two` is the round trip and the reason the two functions are one
task. Writing the records out and grouping the result again is the identity on a
list of records -- a list that is already grouped has no unpaired element to
lose, which is what makes this direction total where `join_two(chunk_two(xs))`
is not. It is the one law here that is not definitional: with `ps` a variable,
`join_two` is stuck on its argument and `chunk_two` is stuck on the list it is
handed, so neither side reduces and the induction on `ps` is the proof. It is
also the law that pins the two functions against each other rather than one at a
time.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.chunk_two_nil()`, `def L.chunk_two_single(x)`, `def L.chunk_two_cons(x, y, t)`,
`def L.join_two_nil()`, `def L.join_two_cons(a, b, t)` and `def L.chunk_two_join_two(ps)`.
