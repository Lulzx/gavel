Implement `insert` and `isort`, then prove the six laws in `LAWS.bend`.

Both work on `List<&2, Nat>`. `insert(xs, y)` places `y` immediately before the
first element `h` of `xs` with `y` at most `h`, keeping every other element in
its order; if there is no such element, `y` goes at the end. On a sorted list
this keeps it sorted. `isort(xs)` sorts `xs` into non-decreasing order by
inserting each element into the sorted rest; the empty list sorts to `Nil{}`.

    insert([1n, 3n, 5n], 4n) == [1n, 3n, 4n, 5n]
    insert([1n, 3n], 3n) == [1n, 3n, 3n]
    insert(Nil{}, 2n) == [2n]
    isort([3n, 1n, 2n, 1n]) == [1n, 1n, 2n, 3n]

The prelude's `P.le(a, b)` is `True{}` when `a` is at most `b`, `P.len(xs)` is
the number of elements of `xs`, and `P.is_sorted(xs)` is `True{}` when each
element of `xs` is at most the next. (`P.is_sorted(xs)` is
`P.sorted_put(xs, 0n, True{})`, where `P.sorted_put(t, h, k)` is whether
`h <> t` is sorted given the decision `k` about `h` against the element before
it. The prelude also provides `P.insert_put`, a list step with the comparison
passed in as a `Bool` argument.)

- `isort_sorted`: `isort(xs)` is sorted.
- `insert_sorted`: when `xs` is sorted, `insert(xs, y)` is sorted.
- `insert_le`: when `P.le(y, x)` is `True{}`, inserting `y` into `[x]` gives
  `[y, x]`.
- `insert_gt`: when `P.le(y, x)` is `False{}`, inserting `y` into `[x]` gives
  `[x, y]`.
- `isort_swap`: when `P.le(x, y)` is `False{}`, sorting `[x, y]` gives `[y, x]`.
- `insert_len`: `insert(xs, y)` has one more element than `xs`.
