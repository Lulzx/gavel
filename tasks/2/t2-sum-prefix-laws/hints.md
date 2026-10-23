The reference matches on `n` first and only then on the list: `0n` answers
`0n`, and a successor `1n+k` answers `0n` on `Nil{}` and `h + sum_prefix(k, t)`
on a cons. With that shape three of the laws close by `{==}`:

- `sum_prefix_zero`: the match on `0n` answers `0n` without looking at the list.
- `sum_prefix_step`: both matches step, on `1n + k` and on `h <> t`.
- `sum_prefix_nil`: the list is a literal but the count is a variable, so match
  on `k`; both cases then reduce to `0n`.

`sum_prefix_len` is an induction on `xs`. `P.len` and `P.sum` both match on the
list, so with a variable `xs` neither side reduces. In the `Nil{}` case both
sides are `0n`. In the cons case `P.len(h <> t)` is `1n + P.len(t)`, so the
count steps too, and both sides reduce to `h` plus the hypothesis at `t`:

    %L.sum_prefix_len(t) : {h + S.sum_prefix(P.len(t), t) == h + _ : Nat}
    {==}
