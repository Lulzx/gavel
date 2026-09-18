Implement `split` on the prelude's `List<&2, Nat>`, then prove all three laws.

`split(xs)` is `xs` separated into the elements at even positions and the
elements at odd positions, counting from zero. Bend has no tuples, so the answer
is a data type: the prelude owns `P.PairL`, built with `P.MkL{evens, odds}`, and
the two projections `P.evens` and `P.odds`. It also owns `P.len`. `List<&2, Nat>`
is the list type here, and a law or helper written over `List<Nat>` will not
unify with these.

The two pins are definitional. `split_nil` fixes the two halves when the list is
empty, and `split_cons` fixes one step: the head joins the odd half of the tail,
and the even half of the whole is the odd half of the tail. Both sides of each
compute, so `{==}` closes them, and the reason they are worth stating is that
`split_cons` is what says the two halves *alternate*: a body that put every
element in one half, or that swapped the two fields, still satisfies `split_nil`
and leaves the two sides of `split_cons` unconvertible. The step calls the
recursion twice, once for each half, which is why the tail is live twice and the
binder is `+xs`; a Lone binder written that way is rejected with `consumed more
than once`.

The real work is `split_len`: the two halves have between them as many elements
as the input. Nothing reduces on its own. `S.split` of a variable list is stuck,
and even after the list is a cons, the goal is about the lengths of the two
projections of a *recursive* `split`, which is a computed value -- so the goal

    case h <> t:
      -- goal: len(evens(split(h <> t))) + len(odds(split(h <> t))) == len(h <> t)
      -- unfolds to: 1n + (len(odds(split(t))) + len(evens(split(t)))) == 1n + len(t)

is about `split(t)`, and the induction hypothesis is the only thing that can
rewrite it. The hypothesis as the law suggests it is
`len(evens(split(t))) + len(odds(split(t))) == len(t)`, whose left side is the
two lengths the *other* way round from where the goal has got them, so the two
have to be swapped before the hypothesis can be used at all.

That swap, and the `1n +` sitting outside it, is arithmetic the prelude does not
have. `a + 0n` is not `a` and `a + b` is not `b + a` for a variable, because
`Nat.add` matches on its *left* argument, so each fact needs an induction of its
own. The swap also wants `b + (1n + p)` seen as `1n + (b + p)`. All of them
belong in helpers under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost. Parameters are erased (`-b`) when each step uses them only in the goal,
and marked `+` when they are live twice.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare while one stating it the other way needs `Equal.sym` around it. A motive
with the hole anywhere else is rejected with `expected`/`observed` about the
hole's type, which reads like a bug in the lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `evens` must
say `P.evens`; naming `S.evens` gets `expected : a defined name / observed :
S.evens`, which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.split_nil()`, `def L.split_cons(h, t)` and `def L.split_len(xs)`,
and each may cite the earlier helpers but never one of the other laws. Write the
implementation in `solution.bend` and the proofs in `PROOF.bend`.
