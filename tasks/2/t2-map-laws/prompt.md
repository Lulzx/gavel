Implement `len` and `map` on lists of `Nat`, then prove both laws.

`len(xs)` must return how many elements `xs` has; recurse on `xs`. `map(xs)` is
the successor map: it replaces every element `h` with `1n+h`, and recurses on
`xs`.

`len_map_cons` says the length of a mapped cons is one more than the length of
the tail. `map(h <> t)` is `(1n+h) <> map(t)` and `len` of that is
`1n + len(map(t))`, so the goal closes once you have the fact that mapping
preserves the length -- that fact is an induction of its own, to be proved under
the reserved `Policy.` namespace.

`map_cons` says what `map` does to a cons: the head becomes `1n+h` and the tail
is mapped. It is what `map` already computes, so that proof closes without
induction.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.len_map_cons(h, t)` and `def L.map_cons(h, t)`.
