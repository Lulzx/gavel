Implement `zip_with_const`, then prove the four laws in `LAWS.bend`.

The prelude declares a pair `P.MkPair{a, b}` of two `Nat` (type `P.Pair`).

`zip_with_const(xs, k)` pairs every element `h` of `xs` with the constant `k`,
as `P.MkPair{h, k}`, in the order the elements come. The answer has as many
pairs as `xs`, and the empty list gives the empty list.

    zip_with_const([1n, 2n], 9n) == [P.MkPair{1n, 9n}, P.MkPair{2n, 9n}]
    zip_with_const([5n], 0n) == [P.MkPair{5n, 0n}]
    zip_with_const(Nil{}, 3n) == Nil{}

The laws use four prelude names. `P.fsts(ps)` and `P.snds(ps)` are the first
and the second components of the pairs of `ps`, in order, as lists of `Nat`.
`P.len(xs)` is the number of elements of `xs`. `P.repeat(n, x)` is the list of
`n` copies of `x`.

- `zip_with_const_nil`: the empty list gives the empty list.
- `zip_with_const_step`: for `h <> t`, the answer is `P.MkPair{h, k}` followed
  by `zip_with_const(t, k)`.
- `zip_with_const_fsts`: the first components of `zip_with_const(xs, k)` are
  `xs` itself.
- `zip_with_const_snds`: the second components of `zip_with_const(xs, k)` are
  `P.repeat(P.len(xs), k)`, that is `k` once for each element of `xs`.
