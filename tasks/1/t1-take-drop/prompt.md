Implement `take` on lists of `Nat`, then prove the law about it.

`take(xs, n)` must return the first `n` elements of `xs`, in order, or all of
them if `xs` is shorter. Recurse on `xs`, and inside the cons cell on `n`:
`Nil{}` returns `Nil{}`; for `h <> t`, `0n` returns `Nil{}` and `1n+p` returns
`h <> take(t, p)`.

`drop` and `append` are given in `prelude.bend` and are not yours to change, so
the law speaks about `take` alone.

The law `take_drop` says that the first `n` elements followed by the rest of the
list are the whole list. It is inductive in `xs`: `take` matches on its first
argument, so with a variable `xs` on the left the goal does not reduce. The step
case splits on `n`, and only the `1n+p` branch needs the induction hypothesis.

This law pins `take` by itself -- there is no companion law -- and it pins the
elements, not just the length. A `take` that ignores `xs` is either `Nil{}` or
`xs`, and neither satisfies the law for a variable `xs`: the first makes the
left-hand side `drop(xs, n)`, which already differs from `xs` at `1n+p`, and
the second makes it `append(xs, drop(xs, n))`, which differs at `0n`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.take_drop(xs, n)`.
