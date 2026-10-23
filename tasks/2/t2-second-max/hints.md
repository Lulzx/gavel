`sec_go` matches on the list: `Nil{}` answers `second`, and `+h <> t` answers
`sec_go(t, P.max2(h, top), P.max2(P.min2(h, top), second))`. `top` is used
twice, so it is `+top`. `second_max` matches on the list: `Nil{}` is `0n` and
`h <> t` is `sec_go(t, h, 0n)`.

All five laws are definitional and close by `{==}`; no case split, induction or
lemma is needed.
