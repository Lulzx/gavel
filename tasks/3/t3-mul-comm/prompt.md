Implement multiplication on `Nat`, then prove all four laws.

`mul(a, b)` recurses on its first argument: zero gives zero, and a successor
gives `b + mul(p, b)`. Every law below is stated with the second factor as a
parameter, so nothing here needs an accumulator.

The prelude is immutable and contributes nothing; the laws speak in Base's
terms (`+` is `Nat.add`, which matches on its *left* argument).

`mul_one_right` and `mul_zero_right` are the two easy inductions, and their
step cases are where the direction of a rewrite first matters: to replace a
term `B` in the goal you supply a proof of `{B' == B}` with `B'` what you want
in its place, so a helper stated the other way round has to be wrapped in
`Equal.sym`, and one stated the way you need does not. Note `x + 0n` is stuck:
`Nat.add` matches on its left argument, so `x + 0n` does not reduce to `x` for
a variable `x`, and both of these laws need that fact as a lemma.

`mul_succ_right` is the first real induction. Its step case has
`(1n + y) + S.mul(p, 1n + y)` on one side and `(1n + p) + (y + S.mul(p, y))`
on the other, and getting from one to the other is associativity and
commutativity of `+` -- helpers you will have to prove in `Policy.`, since no
law may cite another law. `references/t2-add-assoc/PROOF.bend` and
`references/t2-mul-distrib/PROOF.bend` in this repo are worked examples of
exactly that helper stack; you may read them.

`mul_comm` is the last one and the one the others were for. Its step unfolds
the left factor to `b + S.mul(p, b)`, uses the hypothesis on the tail, and then
needs `S.mul(b, 1n + p)` rewritten by the successor law -- two facts about the
same variable.

Both of those facts are about variables that the checker counts. Every variable
is **Lone** by default: it may be used live at most once, and a second live use
is `expected : p / observed : p (consumed more than once)`. That holds for a
variable bound by `case 1n+p:` and equally for a parameter of a `def` -- which
is why the reference `mul` declares its second factor `+b: Nat`, and why every
`Policy.` helper below needs the same treatment. The two ways to say "more than
once" are the `+` marker in a signature or a pattern (`+b: Nat`,
`case +h <> t:`) and a rebinding line at the top of a branch (`+p = p`), which
creates an unrestricted copy under a new name.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_one_right(x)`, `def L.mul_zero_right(x)`, `def L.mul_succ_right(x, y)`
and `def L.mul_comm(a, b)`. Helpers go under the reserved `Policy.` namespace,
which the gate ignores, and none of them may cite a law.
