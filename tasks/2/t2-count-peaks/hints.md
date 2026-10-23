The reference `peaks_go` matches on `t`: `Nil{}` answers `0n`, and `+j <> u`
answers `P.peak_at(prev, h, j) + peaks_go(u, h, j)`. `h` and `j` are read twice,
so declare `+h` and bind `+j`; the list comes first because it is the argument
that shrinks. `count_peaks` matches on the list, then on its tail: `Nil{}` and
`x <> Nil{}` answer `0n`, and `h <> (j <> u)` answers `peaks_go(u, h, j)`.

Five laws close by `{==}`: `count_peaks_nil`, `count_peaks_single`,
`count_peaks_step`, `peaks_go_nil`, `peaks_go_cons`.

`count_peaks_three` reduces to `P.peak_at(x, y, z) + 0n`, stuck on the variables.
A `Policy.` lemma `add_zero(x)`: `x == x + 0n`, an induction on `x` (the step
rewrites with the hypothesis at the predecessor, goal `{1n + p == 1n + _ : Nat}`).
Then:

    %Policy.add_zero(P.peak_at(x, y, z)) : {_ == P.peak_at(x, y, z) : Nat}
    {==}
