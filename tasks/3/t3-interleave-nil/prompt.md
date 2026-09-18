Implement `interleave` on the prelude's `List<&2, Nat>`, then prove all three
laws.

`interleave(xs, ys)` alternates the elements of the two lists, taking from `xs`
first, and puts whatever is left of the longer list on the end. The prelude is
immutable and already has the vocabulary the laws are stated in: `P.len` and
`P.append`. `List<&2, Nat>` is the list type here, and a law or helper written
over `List<Nat>` will not unify with these.

The two nil laws are the weak half. `interleave_nil_l` fixes what an empty left
list leaves, and both sides of it compute, so `{==}` closes it -- a body that
ignored its first argument would satisfy it. `interleave_nil_r` is the mirror
image and is *not* an unfolding when the left list is a variable: the match in
`interleave` is stuck, so the two sides are proved equal by an induction on `xs`
whose step case is the branch the body already took. Together they say which
list is read first, which is the thing a body that swapped its arguments would
get wrong.

The real work is `interleave_len`: the interleaving has as many elements as both
lists together. Its step counts *two* heads at once, one from each list, and
that is what makes it more than the usual cons induction -- the arithmetic left
over is not associativity alone. After the induction hypothesis replaces the
recursive call, the left side is `1n + (1n + (P.len(tx) + P.len(ty)))` and the
right side is `(1n + P.len(tx)) + (1n + P.len(ty))`, and no single `+` lemma
moves between them:

  -- the right side is the same number, grouped the other way, so `Policy.add_assoc`
  -- at `1n` puts the outer `1n` back in front of `P.len(tx) + (1n + P.len(ty))`
  -- the inner `P.len(tx) + (1n + P.len(ty))` then has to become
  --   `1n + (P.len(tx) + P.len(ty))`, which is `Policy.add_succ_right`

The induction has to be over both lists at once, because both of them shrink on
the way down: the hypothesis is needed at the two tails, not at one of them and
something else. A variable is Lone by default -- usable live once per branch --
and the tails are live once in the step, so the helper's lists are `+` only
because the destructured pair is read again when the recursive call is built.

Both `+` facts belong in helpers under the reserved `Policy.` namespace, which
the gate ignores and the credit path does not count. A helper may call `P.*`,
`S.*` and other `Policy.*`, but never a law, since a helper that cited one would
make an isolated law depend on a law that has not been credited yet and the
credit for both would be lost.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare while one stated the other way round is wrapped in `Equal.sym`. A motive
with the hole anywhere else is rejected with `expected`/`observed` about the
hole's type, which reads like a bug in the lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `len` must say
`P.len`; naming `S.len` gets `expected : a defined name / observed : S.len`,
which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.interleave_nil_l(ys)`, `def L.interleave_nil_r(xs)` and
`def L.interleave_len(xs, ys)`, and each may cite the earlier helpers but never
one of the other laws. Write the implementation in `solution.bend` and the
proofs in `PROOF.bend`.
