Implement `prefixes` on the prelude's `List<&2, Nat>`, then prove all three laws.

`prefixes(xs)` is every prefix of `xs`, shortest first: the empty list is the
first element and `xs` itself is the last, so `xs` has one more prefix than it
has elements. The prelude is immutable and already has the vocabulary the laws
are stated in: `P.Prefixes`, the task's own type for a list of prefixes, with the
constructors `P.PNil{}` and `P.PCons{p, rest}`; `P.llen`, how many prefixes a
`P.Prefixes` holds; `P.cons_all(x, ps)`, every prefix in `ps` with `x` on the
front, in order; and `P.len`, the length of a `List<&2, Nat>`. The outer list is
a type of its own rather than a `List` of `List` because its elements have
different lengths, and `P.llen` is not `P.len` -- `P.len` does not take a
`P.Prefixes` at all.

`prefixes_cons` is the step, and it is the law that says which prefixes are
missing: the empty list comes first, and everything after it is a prefix of the
*tail* with the head on the front. Both it and `prefixes_nil` are pins -- both
sides of each compute, so `{==}` closes them. The body that pinning rules out is
`P.PCons{Nil{}, S.prefixes(t)}`, which enumerates the tail's prefixes unchanged:
it agrees with the length law below on any list whose elements are all zero and
leaves the two sides of `prefixes_cons` unconvertible.

`prefixes_len` is the work, and the direct induction does not go through. Its
step case is about `P.llen(P.cons_all(h, S.prefixes(t)))`, and the hypothesis is
about `P.llen(S.prefixes(t))` -- the auxiliary fact that putting one more element
on the front of every prefix does not change how many prefixes there are has to
be stated and proved first. It is an induction on the outer list, and it holds
because `P.cons_all` maps a non-empty outer list to a non-empty one of the same
length. Finding that auxiliary statement is the task; it is not asked for.

The list is live **twice** in the step -- once as the recursive call the
hypothesis replaces and once in what is left of the goal -- so the law binds
`for +xs: List<&2, Nat>`. A variable is Lone by default, usable live once, and
the same rule applies inside the prelude: `P.cons_all` binds its element `+x`
because the step uses it on the front of the prefix and again in the recursive
call.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare. A lemma stated the other way has to be flipped with `Equal.sym`. A motive
with the hole anywhere else is rejected with `expected`/`observed` about the hole
or its type, which reads like a bug in the lemma and is not one. Note that the
two sides of the length law are *not* syntactically alike after the hypotheses
have landed -- one is `1n + (1n + P.len(t))` and the other is
`1n + P.len(h <> t)` -- so the second rewrite replaces the occurrence the
hypothesis's own left side matches, not a numeral.

Two naming rules. The law file imports the prelude as `P` and the solution as
`S`, and the solution does not re-export the prelude, so a law that means the
prelude's `cons_all` must say `P.cons_all`; naming `S.cons_all` gets
`expected : a defined name / observed : S.cons_all`, which reads like a proof bug
and is not one. Anything the policy is not being asked to write is `P.`. That
includes the constructors: `P.PCons{...}` in a law, and in a pattern too.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.prefixes_nil()`, `def L.prefixes_cons(h, t)` and
`def L.prefixes_len(xs)`, and each may cite the earlier helpers and itself --
that self-call is the induction -- but never another law. Helpers go under the
reserved `Policy.` namespace, which the gate ignores and the credit path does not
count; a helper may call `P.*`, `S.*` and other `Policy.*`, but never a law,
since a helper that cited one would make an isolated law depend on a law that has
not been credited yet and the credit for both would be lost. Write the
implementation in `solution.bend` and the proofs in `PROOF.bend`.
