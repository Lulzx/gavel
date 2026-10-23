Implement `sum_acc`, then prove the four laws in `LAWS.bend`.

`sum_acc(xs, a)` is the sum of `xs` with `a` already in the accumulator: the
empty list answers `a`, and a cons adds its head to the accumulator, as `a + h`,
and carries on with the tail.

    sum_acc([1n, 2n, 3n], 10n) == 16n
    sum_acc(Nil{}, 4n) == 4n

The list type is `List<&2, Nat>`. `P.sum(xs)` is the plain sum of the elements
of `xs`.

- `sum_acc_nil`: with an empty list the answer is the accumulator `a`.
- `sum_acc_cons`: `sum_acc(h <> t, a)` equals `sum_acc(t, a + h)`.
- `sum_acc_add`: `sum_acc(xs, a)` equals `a + P.sum(xs)`, with the accumulator
  on the left of the `+`.
- `sum_acc_zero`: with the accumulator at `0n` the answer is `P.sum(xs)`.
