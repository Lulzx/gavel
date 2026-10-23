Implement `nth_from_end`, then prove the seven laws in `LAWS.bend`.

`nth_from_end(xs, k, d)` is the element of `xs` that is `k` positions from its
end, counting the last element as `0n` positions from the end, so the element
`k` positions from the end has exactly `k` elements after it. When `xs` has no
such element, it is the default `d`. The lists are `List<&2, Nat>`.

    nth_from_end([1n, 2n, 3n], 0n, 9n) == 3n
    nth_from_end([1n, 2n, 3n], 1n, 9n) == 2n
    nth_from_end([1n, 2n, 3n], 3n, 9n) == 9n

The laws use `P.len(xs)`, the number of elements; `P.eq(a, b)`, the `Bool` that
says `a` equals `b`; `P.pick_if(b, x, y)`, which is `x` when `b` is `True{}` and
`y` when it is `False{}`; `P.same(n, k)`, the list of `n` copies of `k`; and
`P.snoc(xs, x)`, `xs` with `x` added at the end.

- `nth_from_end_nil`: on the empty list the answer is the default `d`.
- `nth_from_end_step`: `nth_from_end(h <> t, k, d)` is,
  through `P.pick_if` on the test `P.eq(P.len(t), k)`, `h` when the tail has `k`
  elements and `nth_from_end(t, k, d)` otherwise.
- `nth_from_end_pair_last`: in `x <> y <> Nil{}`, distance `0n` gives `y`.
- `nth_from_end_pair_first`: in `x <> y <> Nil{}`, distance `1n` gives `x`.
- `nth_from_end_third`: in `x <> y <> z <> Nil{}`, distance `2n` gives `x`.
- `nth_from_end_last`: in `P.snoc(P.same(n, x), y)`, distance `0n` gives `y`,
  whatever `n`, `x` and `d` are.
- `nth_from_end_out`: `nth_from_end(1n <> 2n <> Nil{}, 2n, 7n)` is `7n`.
