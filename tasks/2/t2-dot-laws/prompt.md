Implement `dot`, then prove the four laws in `LAWS.bend`.

`dot(xs, ys)` is the sum of the products of corresponding elements of the two
lists, pairing the first with the first, the second with the second, and so on.
It stops when either list runs out; elements of the longer list beyond that
point are ignored. If either list is empty the answer is `0n`.

    dot([1n, 2n, 3n], [4n, 5n]) == 14n
    dot([1n], [2n, 3n])         == 2n
    dot(Nil{}, [2n])            == 0n

The laws use these prelude names. `P.len(xs)` is the number of elements of
`xs`. `P.take(n, xs)` is the first `n` elements of `xs`, or all of `xs` when it
has fewer.

- `dot_nil_left`: `dot(Nil{}, ys)` is `0n`.
- `dot_nil_right`: `dot(xs, Nil{})` is `0n`.
- `dot_cons`: `dot(h1 <> t1, h2 <> t2)` is `Nat.mul(h1, h2)` plus `dot(t1, t2)`.
- `dot_shorter`: `dot(xs, ys)` equals `dot(xs, P.take(P.len(xs), ys))`:
  cutting the second list down to the first one's length changes nothing.
