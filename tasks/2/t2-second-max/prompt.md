Implement `sec_go` and `second_max`, then prove the five laws in `LAWS.bend`.

`second_max(xs)` is the second largest element of `xs` when the elements are
sorted from largest down, so a value that occurs twice as the largest is also
the second largest. When `xs` has fewer than two elements the answer is `0n`.
The lists are `List<&2, Nat>`.

`sec_go(xs, top, second)` continues a scan in progress: `top` and `second` are
the largest and second largest elements seen so far, with `second` at most
`top`. It answers the second largest once the elements of `xs` are counted in as
well, so on the empty list it is `second`.

    second_max([3n, 1n, 2n]) == 2n
    second_max([5n, 5n, 1n]) == 5n
    second_max([7n]) == 0n
    sec_go([4n, 9n], 6n, 2n) == 6n

The laws use `P.max2(a, b)` and `P.min2(a, b)`, the larger and the smaller of two
numbers.

- `second_max_nil`: `second_max(Nil{})` is `0n`.
- `second_max_cons`: `second_max(h <> t)` is `sec_go(t, h, 0n)`.
- `sec_go_nil`: `sec_go(Nil{}, top, second)` is `second`.
- `sec_go_cons`: `sec_go(h <> t, top, second)` is
  `sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second))`: the new largest is
  the larger of `h` and `top`, and the new second is the larger of the smaller
  of `h` and `top`, and the old `second`.
- `second_max_three`: `second_max([3n, 1n, 2n])` is `2n`.
