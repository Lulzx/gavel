Implement `rotate`, then prove the three laws in `LAWS.bend`.

`rotate(n, xs)` rotates `xs` to the left `n` times: each rotation takes the
first element off the front and puts it on the end. No element is lost, so
rotating a non-empty list by its own length gives the list back. The empty list
has nothing to move, so `rotate(n, Nil{})` is `Nil{}` for every `n`.

    rotate(1n, [1n, 2n, 3n]) == [2n, 3n, 1n]
    rotate(2n, [1n, 2n, 3n]) == [3n, 1n, 2n]
    rotate(4n, [1n, 2n, 3n]) == [2n, 3n, 1n]
    rotate(0n, [1n, 2n])     == [1n, 2n]
    rotate(3n, Nil{})        == Nil{}

The laws use `P.append(xs, ys)`, the elements of `xs` followed by those of
`ys`.

- `rotate_zero`: `rotate(0n, xs)` is `xs`.
- `rotate_succ`: `rotate(1n + n, x <> t)` equals `rotate(n, P.append(t, x <>
  Nil{}))`: one rotation moves the head `x` to the end of the tail, and the
  other `n` rotations carry on from there.
- `rotate_nil`: `rotate(n, Nil{})` is `Nil{}`, for every `n`.
