`max_prefix_sum_go` matches on the list: `Nil{}` answers `best`, and
`+h <> t` recurses with `Nat.add(acc, h)` as the new accumulator and
`P.max2(Nat.add(acc, h), best)` as the new best. Both `h` and `acc` are used
twice, so they are bound reusable (`+acc` in the signature, `+h` in the
pattern). `max_prefix_sum(xs)` is just `max_prefix_sum_go(xs, 0n, 0n)`.

Four laws close by `{==}`: `max_prefix_sum_nil`, `mpg_nil`, `mpg_cons` and
`max_prefix_sum_three`.

`max_prefix_sum_walk` also needs no lemma. The reference matches on `xs`
(`Nil{}` and `h <> t`) and closes each case by `{==}`; no induction hypothesis
is used.
