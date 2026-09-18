Implement `len` and `snoc` on lists of `Nat`, then prove the laws about `len`.

`len(xs)` must return the number of elements in `xs`. Recurse on `xs`: `Nil{}`
is the base case and returns `0n`, and `h <> t` returns `1n+len(t)`.

`snoc(xs, x)` must return the elements of `xs` followed by `x` -- the new
element goes on the right, unlike a cons cell. Recurse on `xs`: `Nil{}` returns
`x` on its own, and `h <> t` returns `h <> snoc(t, x)`.

The law `len_single` is the weak companion that pins the base case. `len_snoc`
constrains only the recursion step, so a `len` that gets `Nil{}` wrong still
satisfies it; this one does not. It closes by direct computation, since
`x <> Nil{}` is a cons cell.

The law `len_snoc` says that putting one element on the right makes the list one
element longer. It is inductive in `xs`, and the step follows from the induction
hypothesis directly.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.len_single(x)` and `def L.len_snoc(xs, x)`.
