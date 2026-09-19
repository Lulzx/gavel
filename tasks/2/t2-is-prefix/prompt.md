Implement `is_prefix` on lists of `Nat`, then prove the five laws about it.

`is_prefix(xs, ys)` answers whether `xs` is the first part of `ys`: whether
`ys` starts with `xs`. Recurse on both lists. The empty list is a prefix of
everything, so `Nil{}` answers `True{}`. A cons cell looks at `ys`: if `ys` is
empty there is nothing for the head to match and the answer is `False{}`, and
if `ys` is `k <> u` the answer is the head's equality with `k` and the tail's
prefix test, combined with `Bool.and`. `P.eq` and `P.append` come from the
prelude.

`P.eq(a, b)` steps one successor off both of its arguments at once, so
`P.eq(x, x)` on a variable `x` is stuck -- that it is `True{}` is a fact about
`x`, not an unfolding. `P.append(xs, ys)` matches on its first argument, so with
a variable `xs` it does not reduce either.

The law `is_prefix_nil` fixes the answer on the empty input. It is the weak
half: it is definitional, and the constant body `True{}` satisfies it.

The law `is_prefix_nil_right` fixes the other empty case, where it is `ys` that
has run out. Its left-hand side is ground in that argument -- `is_prefix` steps
on the cons cell and then finds `Nil{}` where it wants a second element -- and
no other law here reaches that answer, because the cons law names its second
argument as a cons cell. It is the law that rules out a body whose `Nil{}` case
answers `True{}`.

The law `is_prefix_cons` is the step, and it is definitional: it is the
definition written out, and it says *which* elements have to line up. A body
that compared the head against the wrong element, or that recursed on the wrong
tail, does not have its two sides equal. It is satisfied by every body of the
right shape, so it is not enough on its own -- it says nothing about where the
recursion is handed.

The law `is_prefix_append` is the first with real content, and it is the reason
this task exists: prefixing `ys` with `xs` makes `xs` a prefix of the result. It
is inductive in `xs`. `append` matches on its first argument, so with a variable
`xs` the left-hand side does not reduce on its own, and the hypothesis has to
carry the head comparison out of the `and` one element at a time. The constant
body `False{}` fails it, because the right-hand side is `True{}` at every
length, and a body that stopped after the first element fails it too.

The law `is_prefix_self` says that every list is a prefix of itself. It is the
second law with content, it is also inductive in `xs`, and it is not given away
by `is_prefix_append`: `P.append(xs, Nil{})` is not `xs` to the checker. It ties
the answer to the second argument's own elements rather than to a list built
around them.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.is_prefix_nil(ys)`, `def L.is_prefix_nil_right(h, t)`,
`def L.is_prefix_cons(h, k, t, u)`, `def L.is_prefix_append(xs, ys)` and
`def L.is_prefix_self(xs)`.
