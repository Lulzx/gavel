Implement `concat`, then prove the four laws in `LAWS.bend`.

`concat(xss)` flattens a `List<List<Nat>>` into a `List<Nat>`: the pieces of
`xss` end to end, in order, with nothing dropped and nothing repeated. The empty
list of pieces flattens to `Nil{}`:

    concat([[1n, 2n], Nil{}, [3n]]) == [1n, 2n, 3n]
    concat(Nil{}) == Nil{}

The laws use the prelude's `P.append(xs, ys)` (the elements of `xs` followed by
those of `ys`), `P.len` (the number of elements of a list) and `P.sum` (the sum
of its elements). `P.sum_lens(xss)` is the lengths of the pieces of `xss` added
up, and `P.sum_sums(xss)` is their sums added up.

- `concat_len`: the flattened list's length is `P.sum_lens(xss)`.
- `concat_sum`: the flattened list's sum is `P.sum_sums(xss)`.
- `concat_single`: flattening a list holding the one piece `xs` gives `xs`.
- `concat_cons`: flattening `h <> t` is the piece `h` followed by (`P.append`)
  the flattening of `t`.
