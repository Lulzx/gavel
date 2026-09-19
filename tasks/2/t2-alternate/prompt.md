Implement `alternate` on `Nat`, then prove the four laws about it.

`alternate(n, a, b)` is the list of length `n` that alternates the two numbers,
starting with `a`: `alternate(4n, 1n, 2n)` is `[1n, 2n, 1n, 2n]`. Recurse on the
count. Zero answers nothing, `Nil{}`. A successor puts `a` on the front and
hands the rest of the work to the same function with one fewer to go and the two
numbers the other way round -- `alternate(1n + p, a, b)` is
`a <> alternate(p, b, a)`. The swap is the whole of the alternation: the next
element is whatever the tail was handed first.

The count has to be the first argument, because a recursive call is only
accepted when the checker can read the arguments left to right and find each of
them unchanged until one shrinks. Here it is the two numbers that change and the
count that shrinks, and an argument that changes before the shrinking one is
rejected. `a` is read twice -- once as the element itself and once as the
element the tail will start with after the swap -- so the parameter is marked
reusable with `+a`.

`P.len(xs)` is the length of a list of `Nat`, and `len` comes from the prelude.
It matches on its first argument, so with a variable list it does not reduce.

The law `alternate_zero` fixes the answer at `0n`. Its left-hand side is ground
in the argument the match consumes, so it is the answer a match that has already
stopped gives, and no other law here reaches it: the step law below names its
count as `1n + n`. It is the weak half on its own, satisfied by the constant
body `Nil{}`.

The law `alternate_cons` is the step, and it is definitional: it is the
definition written out, and it is the law that pins the order. A body that kept
`a` in front of every step answers a constant list and leaves the two sides
unequal.

The law `alternate_two` fixes the answer at `2n`, where the count is a literal,
so both sides compute all the way down and the swap at the first step is the
only thing left. It is what a body that got the two numbers the wrong way round
fails, and it is the only law here whose right-hand side names the second number
as an element.

The law `alternate_len` is the one with content: the answer is as long as the
count it was given. It is inductive in `n`, and it is what stops a body that
dropped a step or answered a constant list of the wrong size.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.alternate_zero(a, b)`, `def L.alternate_cons(n, a, b)`,
`def L.alternate_two(a, b)` and `def L.alternate_len(n, a, b)`.
