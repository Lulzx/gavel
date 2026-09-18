Implement `last` on the prelude's `List<&2, Nat>`, then prove all three laws.

`last(xs, d)` is the last element of `xs`, or `d` when `xs` is empty. The prelude
is immutable and already has the vocabulary the laws are stated in: `P.snoc`,
which puts one element on the end of a list, and `P.append`, which it is built
from. `List<&2, Nat>` is the list type here, and a law or helper written over
`List<Nat>` will not unify with these.

The two pins are definitional. `last_nil` fixes what the empty list answers, and
`last_cons` fixes one step of the descent -- the head becomes the default and the
answer comes from the tail. Both sides of each compute, so `{==}` closes them,
and the reason they are worth stating is that they are what says the answer comes
from the *tail*: a body that read the head and stopped, `last(h <> t, d) == h`,
satisfies every value law below and leaves the two sides of `last_cons`
unconvertible.

The real work is `last_snoc`, and the induction that suggests itself does not go
through. Its step case leaves the hypothesis at the default the law was stated
with, and the goal has moved past it, because the head of the list became the
default on the way down:

    case a <> b:
      -- goal: last(snoc(a <> b, h), d) == h
      -- unfolds to: last(snoc(b, h), a) == h
      -- the hypothesis is about last(snoc(b, h), d), and the goal is about
      -- last(snoc(b, h), a)

So the induction has to be *generalized*: carry `d` as a parameter rather than
the constant the law was stated with, and the hypothesis lands at `a`. That
generalized statement is not asked for and has to be found.

A variable is Lone by default -- usable live once per branch -- and the helper's
list is `+xs` because the destructured tail is live twice in the step, once as
the recursive call the hypothesis replaces and once in what is left of the goal.
Its `d` is a plain parameter: the step uses it once, in the goal, and passes `a`
to the recursive call.

The helper belongs under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole where the term you
want to replace sits, and a lemma stated the way you need it is used bare. A
motive with the hole anywhere else is rejected with `expected`/`observed` about
the hole's type, which reads like a bug in the lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `snoc` must say
`P.snoc`; naming `S.snoc` gets `expected : a defined name / observed : S.snoc`,
which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.last_nil(d)`, `def L.last_cons(h, t, d)` and
`def L.last_snoc(xs, h, d)`, and each may cite the earlier helpers but never one
of the other laws. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
