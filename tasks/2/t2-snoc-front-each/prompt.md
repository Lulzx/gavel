Implement `snoc_each` and `front_each` on a list of lists of `Nat`, then prove
all five laws.

`snoc_each(xss, y)` appends `y` to the *end* of every row:
`snoc_each([[1n], [2n, 3n]], 4n)` is `[[1n, 4n], [2n, 3n, 4n]]`. The prelude has
`P.snoc`, which is one element on the end of a single list, and that is what each
row is passed through.

`front_each(xss, y)` puts `y` at the *front* of every row:
`front_each([[1n], [2n, 3n]], 4n)` is `[[4n, 1n], [4n, 2n, 3n]]`.

Both functions are a match on the list of rows: `Nil{}` is `Nil{}`, a cons cell
is the first row changed in front of the same function on the remaining rows, so
the recursion is on the rows and never on the elements. `y` is live twice in each
body -- once for the first row and once for the recursive call -- so the
signature marks it reusable with `+`, and the same is true of the `y` and `z` in
the interaction law below.

The prelude is immutable, and `P.snoc` is the only thing in it. It matches on its
first argument, so a goal about `P.snoc` of a row that is a variable does not
reduce, which is what makes the interaction law below an induction rather than a
computation.

`snoc_each_nil` and `front_each_nil` fix the two answers on an empty list of
rows, which no other law here reaches. `snoc_each_cons` and `front_each_cons` fix
one step of each, and both are definitional. They are not the same law with the
rows reversed: one says the element goes on the end of the first row and the
other says it goes on the front, so a body that had them the wrong way round
fails one of them and not the other.

`snoc_front_commute` is the interaction and the reason the two functions are one
task: doing one and then the other gives the same rows whichever order they are
done in, because every row ends up with `y` at the front and `z` at the end.
Neither side computes on a variable `xss` -- both are stuck on the list of rows
they are handed -- so the two sides are not convertible and the induction is the
proof. It is the only law here that mentions both functions, so it is what pins
them against each other rather than one at a time: a `snoc_each` that appended to
the first row alone and a `front_each` that prepended to the last row alone agree
with every law above at their own step and disagree here.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.snoc_each_nil(y)`, `def L.snoc_each_cons(l, y, t)`,
`def L.front_each_nil(y)`, `def L.front_each_cons(l, y, t)` and
`def L.snoc_front_commute(xss, y, z)`.
