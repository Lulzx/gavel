Implement `dot` on two lists of `Nat`, then prove the four laws about it.

`dot(xs, ys)` is the sum of the pairwise products of the two lists: it walks
them together, multiplies element against element, and adds the products up. It
stops as soon as either list runs out, which is what makes it a `Nat` and not a
list: `dot([1n, 2n, 3n], [4n, 5n])` is `1n*4n + 2n*5n`, because the third
element of the first list has nothing to pair with, and `dot([1n], [2n, 3n])` is
`1n*2n` for the same reason. `dot(Nil{}, ys)` and `dot(xs, Nil{})` are both `0n`.

Recurse on `xs`: `Nil{}` answers `0n`, and a cons cell looks at `ys` -- an empty
`ys` answers `0n` there too, and `k <> u` answers `Nat.mul(h, k) + dot(t, u)`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.len(xs)` counts the elements of a list, and `P.take(n, xs)` is the first `n`
of them, or all of `xs` when it is shorter than `n`. `Nat.mul` comes from
`Base` and is the multiplication the step uses.

The law `dot_nil_left` fixes the answer when the first list is empty. Both sides
compute, so it is definitional, and it is the anchor the step law cannot reach:
the step law names its first argument as a cons cell.

The law `dot_nil_right` fixes the other empty case, where it is the second list
that has run out. `dot_nil_left` constrains only the case where the *first* list
is empty, so it says nothing about a body that recursed on its second list and
stopped at the wrong one; this law is the induction on `xs` that pins the answer
there.

The law `dot_cons` is the step, and it says what one pair contributes: the
product of the two heads, added to the walk over the two tails. Both sides
compute, and it is the law that a body which added instead of multiplying, or
which read one list's elements twice, does not satisfy.

The law `dot_shorter` is the law about the *stopping rule* rather than about one
step: truncating `ys` to the length of `xs` and walking that is walking the
original, because the elements past the end of the shorter list contribute
nothing. It is inductive in `xs`, and `P.take` steps on its count, so the step
case is the hypothesis at the two tails. A body that padded the shorter list out
to the longer one, or that walked on to the end of the longer one, fails it.

Together the four determine `dot` on every input, by induction on the length:
the first two fix the two empty cases, the step law fixes every pair of cons
cells, and the fourth fixes where the walk stops.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.dot_nil_left(ys)`, `def L.dot_nil_right(xs)`, `def L.dot_cons(h1, t1,
h2, t2)` and `def L.dot_shorter(xs, ys)`.
