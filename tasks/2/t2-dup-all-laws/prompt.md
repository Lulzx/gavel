Implement `dup_all`, then prove the two laws in `LAWS.bend`.

`dup_all(xs)` repeats every element twice in place, so the result is twice as
long as `xs`. The empty list gives the empty list.

    dup_all([1n, 2n]) == [1n, 1n, 2n, 2n]
    dup_all([7n])     == [7n, 7n]
    dup_all(Nil{})    == Nil{}

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `dup_all_single`: `dup_all(h <> Nil{})` is `h <> (h <> Nil{})`.
- `dup_all_append`: `dup_all` of `P.append(xs, ys)` is `P.append` of `dup_all(xs)`
  and `dup_all(ys)`.
