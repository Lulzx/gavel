Implement `map_len` and `longest_row` on a list of lists of `Nat`, then prove
all five laws.

`map_len(xss)` is the list of the lengths of the rows, in the order the rows
appear: `map_len([[1n, 2n], Nil{}, [3n]])` is `[2n, 0n, 1n]`. The prelude has
`P.len`, which is the length of a single list, and that is what each row is
passed through.

`longest_row(xss)` is the length of the longest row, and `0n` when there are no
rows: `longest_row([[1n, 2n], Nil{}, [3n]])` is `2n`. The prelude has `P.max`,
which is the larger of two numbers, and that is what the two candidates are
compared with.

Both functions are a match on the list of rows -- `Nil{}` is the base, a cons
cell takes its first row apart and recurses on the rest -- so neither looks at
the elements of a row, only at how many of them there are.

The prelude is immutable, and `P.len`, `P.max` and `P.max_list` are what it
holds. Each matches on its first argument (`P.max` on both of its at once), so a
goal about one of them at a list or a number that is a variable does not reduce,
which is what makes the interaction law below an induction rather than a
computation.

`map_len_nil` and `longest_row_nil` fix the two answers on an empty list of rows,
which no other law here reaches. `map_len_cons` and `longest_row_cons` fix one
step of each, and both are definitional. They are not the same law twice:
`map_len_cons` says the lengths come out in the order the rows went in, so a body
that answered them backwards fails it and nothing else, and `longest_row_cons`
says the answer is a maximum of a row's length and the rest, so a body that
answered the first row's length alone fails it.

`longest_row_map_len` is the interaction and the reason the two functions are one
task: the longest row is the largest of the row lengths, so taking the lengths
first and the largest of those afterwards gives the same number. Neither side
computes on a variable `xss` -- `longest_row` and `map_len` are both stuck until
their argument is a cons, and `P.max_list` is stuck on the list `map_len` has not
produced yet -- so the two sides are not convertible and the induction is the
proof. It is the only law here that mentions both functions, so it is what pins
them against each other rather than one at a time: a `map_len` that dropped a row
and a `longest_row` that stopped at the second row agree with every law above and
disagree here.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.map_len_nil()`, `def L.map_len_cons(l, t)`, `def L.longest_row_nil()`,
`def L.longest_row_cons(l, t)` and `def L.longest_row_map_len(xss)`.
