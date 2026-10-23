The reference `chunks_go` matches on `xs`: `Nil{}` answers `P.push(out, cur)`;
on `h <> t` it matches on `k`, with `0n` recursing as
`chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, P.push(out, cur))` and a successor
`j` as `chunks_go(t, n, j, P.snoc(cur, h), out)`. `chunks` matches on `xs`
first and then on `n`: `Nil{}` answers `Nil{}`; `h <> t` with `n = 0n` answers
`Nil{}`, and with a successor `n` answers
`chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, Nil{})`. `n` is used twice, so
declare `+n`.

Every law but one closes by `{==}`; no rewriting or lemma is needed.

- `chunks_nil`: the list is `Nil{}`, so the first match answers without looking
  at the size.
- `chunks_zero`: the list is a variable, so match on `xs`; both cases close by
  `{==}` (the `Nil{}` arm, and the cons arm hitting the `0n` size).
- `chunks_single`, `chunks_three_by_two`: closed terms, `{==}`.
- `chunks_cons`, `chunks_go_fill`, `chunks_go_close`: each is one arm of the
  definition written out, so both sides are the same term after reduction.
  In `chunks_cons`, `Nat.sub(1n + n, 1n)` reduces away on the definition's side
  too, which is why the law is stated with it.
