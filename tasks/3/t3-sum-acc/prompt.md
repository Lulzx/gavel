Implement `sum_acc` on the prelude's `List<&2, Nat>`, then prove all four laws.

`sum_acc(xs, a)` is the sum of `xs` with `a` already in the accumulator: the
empty list answers `a`, and a cons folds the head in and carries on. The
prelude is immutable and already has the vocabulary the laws are stated in --
`P.sum`, the plain recursive sum -- and `solution` is where `sum_acc` lives.
`List<&2, Nat>` is the list type here, and a law or helper written over
`List<Nat>` will not unify with these.

The two pins are definitional. `sum_acc_nil` fixes what the accumulator answers
when there is nothing left to add, and `sum_acc_cons` fixes one step of the
fold. Both sides of each compute, so `{==}` closes them, and the reason they are
worth stating is that they are what says the answer is built by *folding* --
a body that computes the right number some other way, by answering
`a + P.sum(xs)` outright or by calling itself at `0n` on the tail, satisfies
every value law below and leaves the two sides of `sum_acc_cons`
unconvertible.

The real work is `sum_acc_zero`, and the induction that suggests itself does not
go through. Its step case needs the hypothesis at the accumulator `a + h`, and
the hypothesis for the law as stated is only available at `0n`:

    case h <> t:
      -- goal: sum_acc(h <> t, 0n) == P.sum(h <> t)
      -- unfolds to: sum_acc(t, 0n + h) == h + P.sum(t)
      -- the hypothesis is about sum_acc(t, 0n), and the goal is about
      -- sum_acc(t, h)

So the law has to be *generalized*: `sum_acc_add` says `sum_acc(xs, a)` is
`a + P.sum(xs)` for an arbitrary `a`, and `sum_acc_zero` is then its
instantiation at `0n`, which closes in one step because `0n + P.sum(xs)`
computes to `P.sum(xs)`. Proving `sum_acc_add` is the task; stating it is the
part that is not asked for and has to be found.

A variable is Lone by default -- usable live once per branch -- and the
generalized law uses `a` twice in its step, once in the goal and once in the
hypothesis at the new accumulator, so it binds `for +a: Nat`. Its list is
`for +xs: List<&2, Nat>` for the same reason the other list laws are: the
destructured tail is live twice in the step, once as the recursive call the
hypothesis replaces and once in what is left of the goal.

The induction also needs two facts about `+` that the prelude does not have: the
empty case needs `a == a + 0n`, and the step needs `a + (h + P.sum(t))` seen as
`(a + h) + P.sum(t)`. The generalized law has to be proved under them, so they
belong in helpers under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an
isolated law depend on a law that has not been credited yet and the credit for
both would be lost. Their parameters are mostly erased (`-b`, `-c`) because each
step uses them only in the goal; the ones that are live twice carry `+` instead.

The direction of every rewrite is the one that matters. To replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way: the rewrite fills the hole
where the equation's right side sits with its left side, so a lemma stated with
`O` on the left has to be flipped before it can replace anything -- and a lemma
already pointing the way you need is used bare, without `Equal.sym` around it.
Uses inside a rewrite motive are dead and free, so a variable that appears only
in the goal and in a motive costs nothing.

The law file imports the prelude as `P` and the solution as `S`, and the
solution does not re-export the prelude, so a law that means the prelude's `sum`
must say `P.sum`; naming `S.sum` gets `expected : a defined name / observed :
S.sum`, which reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.sum_acc_nil(a)`, `def L.sum_acc_cons(h, t, a)`,
`def L.sum_acc_add(xs, a)` and `def L.sum_acc_zero(xs)`, and each may cite the
earlier helpers but never one of the other laws. Write the implementation in
`solution.bend` and the proofs in `PROOF.bend`.
