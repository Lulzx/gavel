Implement `diffs` on lists of `Nat`, then prove all four laws.

`diffs(xs)` is the successive differences of `xs`: a list one element shorter
than `xs`, whose entries are the second element minus the first, the third minus
the second, and so on. So `diffs([3n, 1n, 4n, 1n])` is `[0n, 3n, 0n]` -- the
subtraction is truncated, it stops at zero rather than going below it. Recurse
on `xs`: `Nil{}` has no pairs and answers `Nil{}`, a one-element list has none
either and answers `Nil{}`, and from two elements on the answer is the
difference of the first two in front of the differences of the tail.

`P.sub(a, b)` is truncated subtraction and `P.len(xs)` is the length of a list;
both come from the prelude. `P.sub` matches on both of its arguments at once, so
a term like `P.sub(b, a)` with both variables does not reduce on its own.

The laws come in a pair, one for the values and one for the count.

`diffs_cons` is the value half: from two elements on, the answer starts with the
difference of the first two and continues with the differences of the tail. It
is definitional, and it is the law that says *which* numbers come out and where
the recursion restarts -- a body that answered the differences of the tail
without the leading difference, or that paired the wrong neighbours, leaves the
two sides unconvertible. The two one-line laws beside it, `diffs_nil` and
`diffs_single`, are the two inputs this one cannot reach: it names only lists of
two or more elements, so the empty list and the one-element list would be
constrained by nothing if they were not stated.

`diffs_len` is the count half, and it is the law that is not definitional: the
answer is exactly one element shorter than the input, because the first element
is the one with nothing before it to be subtracted from. With a variable `x` on
the front the goal does not compute, so this one is proved by induction on `xs`,
and the induction has to be the one the checker accepts -- it reads the
arguments of a recursive call left to right and insists that each is passed
unchanged until one of them shrinks -- which is why the law binds `xs` before
`x`.

Together the four determine `diffs` on every input, by induction on the length:
the empty and one-element cases are the two base laws, and a longer list is the
step law applied to the tail, which is shorter.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.diffs_nil()`, `def L.diffs_single(x)`, `def L.diffs_cons(a, b, t)` and
`def L.diffs_len(xs, x)`.
