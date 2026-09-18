Implement `append`, `len` and `map` on lists of `Nat`, then prove both laws.

`append(xs, ys)` must return the elements of `xs` followed by the elements of
`ys`; recurse on `xs`. `len(xs)` must return how many elements `xs` has;
recurse on `xs`. `map(xs)` is the successor map: it replaces every element `h`
with `1n+h`, and recurses on `xs`.

`len_map` says mapping preserves the length. It is inductive in `xs`, and in
the step case the induction hypothesis rewrites the tail. `map_cons` says what
`map` does to a cons: the head becomes `1n+h` and the tail is mapped. It is
what `map` already computes, so that proof closes without induction.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.len_map(xs)` and `def L.map_cons(h, t)`.
