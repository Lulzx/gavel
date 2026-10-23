Implement `interleave`, then prove the four laws in `LAWS.bend`.

`interleave(xs, ys)` takes two `List<&2, Nat>` and alternates their elements,
starting with the first element of `xs`; once one list runs out, the rest of
the other follows in order:

    interleave([1n, 3n, 5n, 6n], [2n, 4n]) == [1n, 2n, 3n, 4n, 5n, 6n]
    interleave([1n], [2n, 4n, 7n]) == [1n, 2n, 4n, 7n]

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`. The
lists are `List<&2, Nat>`, not `List<Nat>`.

- `interleave_nil_l`: interleaving `Nil{}` with `ys` gives `ys`.
- `interleave_nil_r`: interleaving `xs` with `Nil{}` gives `xs`.
- `interleave_len`: the interleaving has `P.len(xs) + P.len(ys)` elements.
- `interleave_pair`: interleaving `x <> tx` with `y <> ty` gives `x`, then
  `y`, then the interleaving of `tx` with `ty`.
