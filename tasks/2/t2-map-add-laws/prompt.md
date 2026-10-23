Implement `map_add`, then prove the two laws in `LAWS.bend`.

`map_add(xs, n)` is the list of the same length in which `n` has been added to
every element of `xs`. The empty list gives the empty list.

    map_add([1n, 4n], 3n) == [4n, 7n]
    map_add([0n], 5n)     == [5n]
    map_add(Nil{}, 3n)    == Nil{}

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `map_add_single`: `map_add(h <> Nil{}, n)` is `(h + n) <> Nil{}`.
- `map_add_append`: `map_add` of `P.append(xs, ys)` with `n` is `P.append` of
  `map_add(xs, n)` and `map_add(ys, n)`.
