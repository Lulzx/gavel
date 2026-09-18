Implement `count_zeros` on lists of `Nat`, then prove the law about it.

`count_zeros(xs)` must return how many elements of `xs` are `0n`. Recurse on
`xs`: `Nil{}` returns `0n`, and `h <> t` returns `is_zero(h) + count_zeros(t)`.

`is_zero` and `append` are given in `prelude.bend` and are not yours to change.
`is_zero` is `Nat`-valued rather than `Bool` -- it is `1n` for `0n` and `0n` for
anything else -- so that the law's right-hand side is an arithmetic term.

The law `count_zeros_snoc` says that adding one element on the right adds
`is_zero(x)` to the count. It is inductive in `xs`: `append` matches on its
first argument, so with a variable `xs` on the left the goal does not reduce.

This law pins `count_zeros` by itself -- there is no companion law -- and it
pins what is counted, not merely how many elements there are. A body that
ignores `xs` is a constant `k`, and the right-hand side is then `k + is_zero(x)`,
which is stuck on a variable `x`, so only `k = 0n` has a chance and `1n` is not
`is_zero(x)`. A body that returned the length would give `len(xs) + 1n` on the
left against `len(xs) + is_zero(x)` on the right.

`+` is stuck on a variable, so the proof needs two facts that are not
definitional: that `x + 0n == x`, and that `+` reassociates. Both are yours to
prove, under the reserved `Policy.*` namespace, as `def Policy.add_zero(x)` and
`def Policy.add_assoc(a, b, c)`. Mark the parameters that appear only in a
lemma's statement as erased (`-b`) so that calling it does not consume the
caller's values.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.count_zeros_snoc(xs, x)`.
