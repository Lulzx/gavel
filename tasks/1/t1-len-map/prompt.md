Implement `len` and `map` on lists of `Nat`, then prove the laws that relate
them.

`len(xs)` must return the number of elements in `xs`. Recurse on `xs`: `Nil{}`
is the base case and returns `0n`, and `h <> t` returns `1n+len(t)`.

`map(xs)` must return the list of the results of `P.inc` on each element.
`inc` is supplied by the prelude and adds one to its argument. Recurse on `xs`:
`Nil{}` returns `Nil{}` and `h <> t` returns `P.inc(h) <> map(t)`.

The law `len_cons` says that consing one element onto a list makes it one
element longer. It closes by direct computation: `len` reduces on a non-empty
list, so both sides become `1n+len(xs)`.

The law `len_single` is the weak companion that pins the base case. `len_cons`
constrains only the cons step, so a `len` that gets `Nil{}` wrong still satisfies
it; this one does not.

The law `len_map` says that mapping a list does not change its length. It is
inductive in `xs`, and the step follows from the induction hypothesis directly.

The law `map_cons` pins `map` itself: `len_map` is satisfied by the identity
map and by a `map` that returns `Nil{}`, and this one is not.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.len_cons(x, xs)`, `def L.len_single(x)`, `def L.len_map(xs)` and
`def L.map_cons(x, xs)`.
