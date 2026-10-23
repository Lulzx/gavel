Implement `inc_all`, then prove the two laws in `LAWS.bend`.

`inc_all(xs)` is the list of the same length in which every element is replaced
by its successor, `h + 1n`. The empty list gives the empty list.

    inc_all([1n, 4n]) == [2n, 5n]
    inc_all([0n])     == [1n]
    inc_all(Nil{})    == Nil{}

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `inc_all_single`: `inc_all(h <> Nil{})` is `(h + 1n) <> Nil{}`.
- `inc_all_append`: `inc_all` of `P.append(xs, ys)` is `P.append` of `inc_all(xs)`
  and `inc_all(ys)`.
