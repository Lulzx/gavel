`run_starts` matches on the list: `Nil{}` answers `Nil{}` and `h <> t` answers
`0n <> run_starts_go(t, h, 1n)`. `run_starts_go` matches on `rest`: `Nil{}`
answers `Nil{}`, and `+h <> t` answers
`P.put_start(i, run_starts_go(t, h, Nat.add(i, 1n)), P.same(h, prev))`. The
comparison is a computed value, so it goes through `P.put_start`. `i` is `+i`.

Five laws close by `{==}`: `run_starts_nil`, `run_starts_single`,
`run_starts_go_nil`, `run_starts_go_cons` and `run_starts_three`.

`run_starts_go_same` needs `P.same(a, a)` to become `True{}`, which is stuck on
a variable. A `Policy.` lemma `same_refl(a)`: `{True{} == P.same(a, a) : Bool}`,
by induction on `a` (`0n` is `{==}`, `1n+p` rewrites with the hypothesis, then
`{==}`). The law rewrites the decision with it, hole in the `Bool` slot of
`P.put_start`, and closes by `{==}`:

    %Policy.same_refl(a) : {P.put_start(i, S.run_starts_go(t, a, Nat.add(i, 1n)), _) == S.run_starts_go(t, a, Nat.add(i, 1n)) : List<&2, Nat>}
