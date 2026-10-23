Implement `pad`, then prove the five laws in `LAWS.bend`.

`pad(n, x, xs)` lengthens `xs` to `n` elements by adding copies of `x` on the
right. A list that already has at least `n` elements is returned unchanged.
The elements of `xs` are kept, in order, as a prefix of the result.

    pad(4n, 0n, [7n, 8n]) == [7n, 8n, 0n, 0n]
    pad(1n, 0n, [7n, 8n, 9n]) == [7n, 8n, 9n]
    pad(2n, 5n, Nil{}) == [5n, 5n]

The prelude's `P.len(xs)` is the number of elements of `xs`, and `P.max(a, b)`
is the larger of `a` and `b`.

- `pad_nil`: padding to length `0n` returns `xs` unchanged.
- `pad_single`: padding the empty list to length `1n` gives the one-element
  list `[x]`.
- `pad_len`: the padded list has `n` elements or as many as `xs`, whichever is
  larger.
- `pad_step`: padding `y <> ys` to length `1n + n` gives `y` in front of `ys`
  padded to length `n`.
- `pad_nil_step`: padding the empty list to length `1n + n` gives `x` in front
  of the empty list padded to length `n`.
