Implement `insert` and `isort`, then prove the seven laws in `LAWS.bend`.

Both work on `List<&2, Nat>`. `insert(xs, y)` places `y` immediately before the
first element `h` of `xs` with `y` at most `h`, keeping every other element in
its order; if there is no such element, `y` goes at the end. On a sorted list
this keeps it sorted. `isort(xs)` sorts `xs` into non-decreasing order by
inserting each element into the sorted rest; the empty list sorts to `Nil{}`.

    insert([1n, 3n, 5n], 4n) == [1n, 3n, 4n, 5n]
    insert([1n, 3n], 3n) == [1n, 3n, 3n]
    insert(Nil{}, 2n) == [2n]
    isort([3n, 1n, 2n, 1n]) == [1n, 1n, 2n, 3n]

The prelude's `P.le(a, b)` is `True{}` when `a` is at most `b`, `P.eq(a, b)` is
`True{}` when `a` equals `b`, `P.ind(b)` is `1n` for `True{}` and `0n` for
`False{}`, and `P.count(z, xs)` is the number of elements of `xs` equal to `z`.
The prelude also provides `P.insert_put` and `P.count_put`, a list step and a
count step with the comparison passed in as a `Bool` argument.

- `insert_count`: the count of `z` in `insert(xs, y)` is `P.ind(P.eq(z, y))`
  plus the count of `z` in `xs`.
- `isort_count`: every number occurs in `isort(xs)` as many times as in `xs`.
- `isort_swap`: when `P.le(x, y)` is `False{}`, sorting `[x, y]` gives `[y, x]`.
- `isort_keep`: when `P.le(x, y)` is `True{}`, sorting `[x, y]` gives `[x, y]`.
- `insert_before`: when `P.le(y, h)` is `True{}`, inserting `y` into `h <> t`
  gives `y <> h <> t`.
- `insert_after`: when `P.le(y, h)` is `False{}`, inserting `y` into `h <> t`
  gives `h` followed by `y` inserted into `t`.
- `isort_cons`: sorting `h <> t` is inserting `h` into the sorted `t`.
