Implement `count_up` and `count_down` on `Nat`, then prove all seven laws.

`count_up(n)` is the list `[0n, 1n, ..., n - 1n]`: `Nil{}` for nothing, and for
`1n + k` the list below `k` with `k` appended at the *end*, which is why the
prelude has `P.snoc`. `count_up(3n)` is `[0n, 1n, 2n]`.

`count_down(n)` is the list `[n - 1n, ..., 1n, 0n]`, the same elements the other
way round: `Nil{}` for nothing, and for `1n + k` the element `k` on the *front*
of the list below it. `count_down(3n)` is `[2n, 1n, 0n]`.

Both recursions are on the same number and both use `k` twice -- once as the
number the recursive call stops below and once as the element it adds -- so the
pattern has to mark `k` reusable: `case 1n++k:` rather than `case 1n + k:`.

The prelude is immutable and holds `P.snoc`, `P.rev` and `P.len`, each matching
on its first argument. A goal about any of them applied to a list that is not a
literal cons does not reduce, which is what makes the two laws below stated at a
variable `n` into inductions rather than definitions.

`count_up_zero` and `count_down_zero` fix the two answers on the empty input,
which no other law here reaches; `count_up_succ` and `count_down_succ` fix one
step of each, and they are definitional. The four are not redundant with each
other: `count_up_succ` is the law that says the answer *grows at the back* --
`P.snoc(S.count_up(k), k)` -- and `count_down_succ` says it grows at the front,
so a body that had the two the wrong way round satisfies neither of the
zero laws and fails a different one of these two.

`count_up_rev_count_down` is the interaction and the reason the two functions
are one task: reversing what `count_up` builds gives exactly what `count_down`
builds. Neither side computes on a variable `n` -- `count_up` is stuck until its
argument is a numeral and `rev` is stuck on the list it is handed -- so the two
sides are not convertible and the induction is the proof. It also needs a fact
the prelude does not state, that the reverse of a `snoc` is the element on the
front of the reverse, and that fact is an induction of its own; write it in
`PROOF.bend` as `Policy.rev_snoc`, not as a law, since a law that cited another
law would make the credit for both depend on the citation. The step of the law
holds `P.rev(P.snoc(S.count_up(k), k))` against `k <> S.count_down(k)`, and the
fact read backwards is what turns the first into the second.

`len_count_up` and `len_count_down` pin how many elements each function
produces, which the reverse law only pins indirectly: two bodies that agreed on
the order of the answer could still disagree on how many elements it has. Both
are inductions for the same reason as above, and both need the other fact the
prelude does not state, that the length of a `snoc` is one more than the length
of the list -- write it as `Policy.len_snoc` in `PROOF.bend`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_up_zero()`, `def L.count_up_succ(k)`, `def L.count_down_zero()`,
`def L.count_down_succ(k)`, `def L.count_up_rev_count_down(n)`,
`def L.len_count_up(n)` and `def L.len_count_down(n)`.
