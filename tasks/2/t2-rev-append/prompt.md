Implement `rev_append`, then prove the two laws in `LAWS.bend`.

`rev_append(xs, ys)` is `xs` reversed and placed in front of `ys`.

    rev_append([1n, 2n, 3n], [8n, 9n]) == [3n, 2n, 1n, 8n, 9n]
    rev_append(Nil{}, [8n]) == [8n]
    rev_append([5n], [8n]) == [5n, 8n]

The laws use `P.append(xs, ys)`, the concatenation of two lists.

- `rev_append_single`: `rev_append(h <> Nil{}, ys)` is `h <> ys`.
- `rev_append_append`: `rev_append(P.append(xs, ys), zs)` is
  `rev_append(ys, rev_append(xs, zs))`.
