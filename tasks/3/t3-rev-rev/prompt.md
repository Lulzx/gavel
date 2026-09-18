Implement `rev` on `List<&2, Nat>`, then prove all three laws.

`rev(xs)` returns `xs` backwards. It recurses on `xs`: the empty list reverses
to itself, and a cons cell reverses its tail and puts the head on the right,
through the prelude's `P.snoc`. That placement is where all the work comes from.
Because the head lands on the *right*, the step case of a law is an induction
rather than a computation: `rev(h <> t)` is `P.snoc(rev(t), h)`, which is a
`snoc` applied to a value nothing can match on, so no law about `len` or
`append` follows by itself. Every step has to move the head back out before the
hypothesis, which is about `rev(t)`, applies -- and each move is a lemma of its
own, because `P.snoc` matches on its first argument and the first argument here
is the opaque `rev(t)`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.append(xs, ys)` concatenates, matching on its first argument; `P.snoc(xs, y)`
adds one element on the right, matching on its first argument as well; and
`P.len(xs)` counts the elements, also matching on its first argument. The
`solution` module is where `rev` lives.

`rev_len` is the induction, and its step case is the length side of the same
problem. `len(rev(h <> t))` reduces to `len(snoc(rev(t), h))`, and `len` cannot
step past the `snoc` because its scrutinee is a computed value. What the step
needs is the lemma that `len(snoc(xs, y))` is `1n + len(xs)`: it is inductive in
`xs`, and once it has exposed the succ, the hypothesis `len(rev(t)) == len(t)`
finishes the cell. `rev_append` is the same shape one turn further in: the step
computes to a `snoc` on the left and an `append` on the right, and what is
needed is the reassociation that pushing an element onto the right of an
`append` is appending onto the already-snocced tail -- again stuck on a
variable, again inductive. `rev_rev`'s step needs a third lemma: reversing a
`snoc` puts that element in front, and only after the head is out front does the
hypothesis on the tail collapse the double reversal. None of those three lemmas
is part of a law, so all of them go under the reserved `Policy.` namespace,
which the gate ignores and the credit path does not count; a helper may call
`P.*`, `S.*` and other `Policy.*`, but never a law, since a helper that cited
one would make an isolated law depend on a law that has not been credited yet
and the credit for both would be lost.

The direction of every rewrite is the one that matters. To replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way: the rewrite fills the hole
where the equation's right side sits with its left side, so a lemma stated with
`O` on the left has to be flipped before it can replace anything. Uses inside a
rewrite motive are dead and free, so a variable that appears only in the goal
and in a motive costs nothing.

Two details of the form matter more here than anywhere else. First, a variable
is **Lone** by default -- usable live once -- whether a pattern binds it or a
signature declares it, and the step of `rev_len` uses the destructured tail
live twice: once as `S.rev(t)` inside the `len_snoc` lemma and once as the
argument of the recursive call. That is why the lists are `List<&2, Nat>` and
the laws bind `for +xs: List<&2, Nat>`: a `+` binder is only allowed on a list
whose kind is `Data`, and it is what makes the tail reusable. Writing `+t = t`
to rebind the tail instead fails with `expected : Data, observed : Type`, and
leaving the lists as plain `List<Nat>` fails with `expected : t / observed : t
(consumed more than once)`. Second, the law file imports the prelude as `P` and
the solution as `S`, and the solution does not re-export the prelude, so a law
that means the prelude's `len` must say `P.len`; naming `S.len` gets
`expected : a defined name / observed : S.len`, which reads like a proof bug and
is not one. Anything the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.rev_len(xs)`, then `def L.rev_append(xs, ys)`, then
`def L.rev_rev(xs)`, and each may cite the earlier helpers but never one of the
other laws. Write the implementations in `solution.bend` and the proofs in
`PROOF.bend`.
