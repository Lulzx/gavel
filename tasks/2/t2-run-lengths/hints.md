`run_lengths` matches on the list, then on its tail: `Nil{}` answers `Nil{}`,
`h <> Nil{}` answers `1n <> Nil{}`, and `h <> (+h2 <> +t2)` answers
`run_lengths_go(t2, P.same(h, h2), 1n, h2)`.

`run_lengths_go` matches on `t`, then on `cont`. On `Nil{}`: `True{}` answers
`(1n + cur) <> Nil{}` and `False{}` answers `cur <> (1n <> Nil{})`. On
`+h2 <> +t2`: `True{}` answers `run_lengths_go(t2, P.same(h, h2), 1n + cur, h2)`
and `False{}` answers `cur <> run_lengths_go(t2, P.same(h, h2), 1n, h2)`. The
comparison is a computed value, so it is passed as an argument rather than
matched on. `cur` is `+cur`.

Eight laws close by `{==}`; every one but `run_lengths_go_same` is
definitional.

`run_lengths_go_same` needs `P.same(a, a)` to become `True{}`, which is stuck on
a variable. A `Policy.` lemma `same_refl(a)`: `{True{} == P.same(a, a) : Bool}`,
by induction on `a` (`0n` is `{==}`, `1n+p` rewrites with the hypothesis, then
`{==}`). The law rewrites the decision with it and closes by `{==}`:

    %Policy.same_refl(a) : {S.run_lengths_go(t, _, 1n + cur, a) == S.run_lengths_go(t, True{}, 1n + cur, a) : List<&2, Nat>}
