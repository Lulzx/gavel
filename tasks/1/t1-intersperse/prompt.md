Implement `intersperse` on lists of `Nat`, then prove all four laws.

`intersperse(xs, sep)` puts `sep` between every two neighbours of `xs` and
nowhere else. So `intersperse([1n, 2n, 3n], 0n)` is `[1n, 0n, 2n, 0n, 3n]` -- one
`sep` per gap, and none at either end. Recurse on `xs`: `Nil{}` answers `Nil{}`,
a one-element list answers itself, and from two elements on the answer is the
first element, then `sep`, then the interspersing of everything from the second
element on. The separator argument is declared reusably (`+sep`) because the cons
case uses it twice: once in the answer and once in the recursive call.

Three defs are given in `prelude.bend`. `P.len(xs)` is the length of a list.
`P.ilen(xs)` is the length the answer must have, counted without mentioning
`intersperse`: `0n` for the empty list, and otherwise one element for the head
plus two for every element after it. It is split in two -- `P.ilen` and
`P.ilen_tail` -- because the answer's length is not one recurrence over `xs`:
the one-element list answers one element, not two.

`intersperse_nil` and `intersperse_single` pin the two inputs the step cannot
reach. The step law below names `a <> (b <> t)`, so it constrains only lists of
two or more elements; without these two, a body that answered the empty list or
the one-element list with a separator in it would satisfy it. Both sides compute
in each, and neither one mentions a separator at all, which is what says the
answer has nothing at the ends.

`intersperse_cons` is the step, and it is the law that says where the separators
go: one between the first two elements, and the rest left to the recursion on
the tail from the second element on. Both sides compute, so it is definitional. A
body that put the separator before the head, or that recurred on `t` instead of
on `b <> t` -- losing the second element and with it a separator -- leaves the
two sides unconvertible here.

`intersperse_len` is the count half: the answer is exactly as long as `P.ilen`
says. It is the law that says how many separators come out, where
`intersperse_cons` says which list they land in.

It is also the only one of the four that is not definitional, and so the only
one that needs an induction. Its list is a variable, so `intersperse` cannot take
a step and `{==}` gets nowhere: match on `xs`, and in the cons case match on the
tail as well, because `P.ilen` has a case for the one-element list that the empty
tail reaches. The cons-of-cons case is the one that uses the hypothesis, at the
smaller list `h2 <> t2`.

Together the four determine `intersperse` on every input, by induction on the
length: the empty and one-element cases are `intersperse_nil` and
`intersperse_single`, and a longer list is `intersperse_cons` applied to the
tail, which is shorter.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.intersperse_nil(sep)`, `def L.intersperse_single(x, sep)`,
`def L.intersperse_cons(a, b, t, sep)` and `def L.intersperse_len(xs, sep)`.
