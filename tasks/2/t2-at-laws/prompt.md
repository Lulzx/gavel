Implement `at` on `List<Nat>`, then prove the two laws about it.

`at(xs, n)` is element `n` of `xs`, counting from zero, and it is `0n` once the
list runs out. Match on the list first and then on the count, so that `Nil{}` is
`0n`, a cons cell at count `0n` is its head, and a cons cell at `1n + k` steps
one cell further in, to `at(t, k)`. `append` and `len` come from the prelude.

The laws are the step law and the length law:

    S.at(h <> t, 1n + k) == S.at(t, k)
    S.at(P.append(xs, y <> Nil{}), P.len(xs)) == y

The first is the weak half: it is definitional, and a body that ignores both
arguments and returns one constant satisfies it. The second is the one that pins
`at`: the constant is wrong here, and so is a body that ignores the list and
hands back the count, since neither returns `y`. It is inductive in `xs` --
`append` and `len` both match on their first argument, so with a variable `xs`
neither side reduces on its own.

The first law's proof is `{==}`: the match steps on the cons cell and then on
the successor count, and both sides are `at(t, k)`. The second is an induction
in `xs`. Its `Nil{}` case is the head case of `at` -- `append(Nil{}, ys)` is
`ys` and `len(Nil{})` is `0n` -- and its cons case reduces to
`at(P.append(t, y <> Nil{}), P.len(t))`, which is the hypothesis at `t`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.at_succ(h, k, xs)` and `def L.at_len_append(xs, y)`.
