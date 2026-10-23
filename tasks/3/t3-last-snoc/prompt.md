Implement `last`, then prove the three laws in `LAWS.bend`.

`last(xs, d)` is the last element of `xs`, or the default `d` when `xs` is
empty. The default only matters for the empty list:

    last([1n, 2n, 3n], 9n) == 3n
    last([5n], 9n) == 5n
    last(Nil{}, 9n) == 9n

The list type is the prelude's `List<&2, Nat>`; a statement written over
`List<Nat>` will not unify with the laws. The prelude's `P.snoc(xs, x)` is `xs`
with `x` put on the end, and `P.append` is list concatenation.

- `last_nil`: the empty list answers the default `d`.
- `last_cons`: the last element of `h <> t` with default `d` is the last element
  of `t` with default `h`.
- `last_snoc`: the last element of `xs` with `h` put on the end is `h`, whatever
  the default.
