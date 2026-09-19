Implement `cmp` on `Nat`, then prove all six laws.

`cmp(a, b)` answers which of the two numbers is the bigger one, as one of the
prelude's three values: `P.Lt{}` when `a` is below `b`, `P.Eq{}` when they are
the same number, and `P.Gt{}` when `a` is above `b`. Recurse on the two
arguments at once: a zero against a zero is `P.Eq{}`, a zero against a successor
is `P.Lt{}`, a successor against a zero is `P.Gt{}`, and two successors answer
whatever is below them answers. `P.Eq{}`, `P.Lt{}` and `P.Gt{}` are the
constructors of the prelude's `P.Tri`, and `P.flip` is also the prelude's: it
answers for the same two numbers the other way round, so it maps `P.Lt{}` to
`P.Gt{}`, `P.Eq{}` to itself and `P.Gt{}` to `P.Lt{}`.

`cmp_zero_zero` fixes the answer at two literal zeroes. The step law below names
two *successors*, so it never reaches a zero, and a body that got the `Eq{}`
answer wrong at the bottom would keep every other law here.

`cmp_zero_succ` fixes what a zero answers against a successor, and
`cmp_succ_zero` what a successor answers against a zero. They are the two
remaining leaves of the match, and neither is reachable from the step law,
which steps a successor off each side and so never sees a zero.

`cmp_succ_succ` is the step: two successors answer what is below them answers.
It is the only law that relates the answer at one pair of numbers to the answer
at another, and the only one that says the comparison looks at both arguments
and not at how big they are.

`cmp_self` says a number compared with itself is `P.Eq{}`. Unlike the four laws
above it is not definitional: with `a` a variable the match does not reduce, so
the induction is the proof. It is what a body answering `P.Lt{}` for everything
cannot satisfy, since such a body keeps the step law and every pin.

`cmp_antisym` says the two argument positions are symmetric: comparing `a` with
`b` answers what comparing `b` with `a` answers, with `P.flip` exchanging below
and above. Every other law here steps both arguments down together, so a body
that swapped its two arguments would keep all of them; this is the law that
sees which side of the comparison each number is on.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.cmp_zero_zero()`, `def L.cmp_zero_succ(k)`, `def L.cmp_succ_zero(k)`,
`def L.cmp_succ_succ(a, b)`, `def L.cmp_self(a)` and `def L.cmp_antisym(a, b)`.
