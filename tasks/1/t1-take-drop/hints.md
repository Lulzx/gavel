The reference matches on `xs`, and inside a cons on `n`: `Nil{}` answers
`Nil{}`; for `h <> t`, `0n` answers `Nil{}` and `1n+p` answers
`h <> take(t, p)`.

`take_drop` is an induction on `xs` with a match on `n` inside the cons case.
The `Nil{}` case is `{==}`, and so is the `0n` case (`take` gives `Nil{}`,
`drop` gives the whole list). In the `1n+p` case both sides are `h` in front of
the decomposed tail, so rewrite with the hypothesis at the tail,
`L.take_drop(t, p)` (hole in `h <> _`), then `{==}`.
