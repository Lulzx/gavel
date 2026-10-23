Implement `delete`, then prove the four laws in `LAWS.bend`.

`delete(x, xs)` removes the first element of `xs` that equals `x` and keeps
everything else in its original order. Only that one element goes: not every
match and not the last. If `x` does not occur, the whole list comes back. The
empty list gives the empty list.

For example, deleting `5n` from `[4n, 5n, 5n, 6n]` gives `[4n, 5n, 6n]`, and
deleting `7n` from `[4n, 5n]` gives `[4n, 5n]`.

The laws use these prelude names. `P.eq(a, b)` is the `Bool` comparison of two
`Nat`s. `P.at_if(b, x, y)` is `x` when `b` is `True{}` and `y` otherwise.
`P.inc_all(xs)` adds one to every element of `xs`, so none of its elements is
`0n`.

- `delete_nil`: deleting from the empty list gives the empty list.
- `delete_step`: deleting `x` from `h <> t` is the decision `P.at_if` makes on
  `P.eq(h, x)` between two lists: `t` (the head is dropped) and `h` in front of
  the deletion of `x` from `t`.
- `delete_hit`: deleting `k` from `k <> t` gives `t`, even when `t` contains `k`
  again.
- `delete_miss`: deleting `0n` from `P.inc_all(xs)` gives `P.inc_all(xs)`
  unchanged.
