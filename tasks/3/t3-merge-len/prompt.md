Implement `merge` and `merge_go`, then prove the seven laws in `LAWS.bend`.

`merge(xs, ys)` merges two lists by comparing heads with the prelude's `P.le`:
when the left head is less than or equal to the right head the left head goes
first and the merge continues on the left tail; otherwise the right head goes
first and the merge continues on the right tail. When one list is empty the
answer is the other list. On two sorted lists the result is sorted, and ties
take the left element first.

    merge([1n, 4n], [2n, 3n, 5n]) == [1n, 2n, 3n, 4n, 5n]
    merge([3n, 1n], [2n]) == [2n, 3n, 1n]
    merge(Nil{}, [3n, 1n]) == [3n, 1n]

`merge_go(tx, hx, ty, hy, k)` continues a merge of the left list `hx <> tx`
with the right list `hy <> ty`, taking the comparison's answer as the `Bool`
`k` rather than computing it. When `k` is `True{}` it is
`hx <> merge(tx, hy <> ty)`; when `k` is `False{}` it is
`hy <> merge(hx <> tx, ty)`. With `k` equal to `P.le(hx, hy)` it is therefore
`merge(hx <> tx, hy <> ty)`.

    merge_go(Nil{}, 4n, Nil{}, 2n, False{}) == [2n, 4n]
    merge_go([5n], 1n, [3n], 2n, True{}) == [1n, 2n, 3n, 5n]

The list type is the prelude's `List<&2, Nat>`. `P.le(a, b)` is `True{}` when
`a` is at most `b` and `False{}` otherwise; `P.len` is the number of elements.

- `merge_nil_l`: merging the empty list with `ys` gives `ys`.
- `merge_nil_r`: merging `xs` with the empty list gives `xs`.
- `merge_go_true`: with both tails empty and the decision `True{}`, the answer
  is `a` then `b`.
- `merge_go_false`: with both tails empty and the decision `False{}`, the answer
  is `b` then `a`.
- `merge_len`: the merge has as many elements as `xs` and `ys` together.
- `merge_le_head`: when `P.le(hx, hy)` is `True{}`, merging `hx <> tx` with
  `hy <> ty` gives `hx` followed by the merge of `tx` with `hy <> ty`.
- `merge_gt_head`: when `P.le(hx, hy)` is `False{}`, merging `hx <> tx` with
  `hy <> ty` gives `hy` followed by the merge of `hx <> tx` with `ty`.
