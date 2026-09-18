Implement `neg_all` on `List<&2, Bool>`, then prove all five laws.

`neg_all(xs)` negates every element and keeps the order: the empty list maps to
itself, and a cons cell maps to the negation of its head in front of the map of
its tail. That is the whole function, and the two definitional laws below are
its unfolding at a constructor -- proving them is a `{==}` and nothing more.

The work is in the last three laws, and none of them is closed by the induction
hypothesis applied to a tail alone. `neg_all_involutive` is the first: the step
unfolds the outer `neg_all` onto a cons and leaves `Bool.not(Bool.not(h))` as
the head of the goal, which no list induction can touch because `not` matches on
its argument and the argument here is the variable `h`. The fact that
double negation is the identity is a lemma of its own, and it is a case split on
`h` -- one step, both branches compute.

`neg_all_all` is the law the task is named for: the `all` fold of a negated list
is the negation of the `any` fold of the list. Its step reduces the left-hand
side to `Bool.and(Bool.not(h), _)` and the right-hand side to
`Bool.not(Bool.or(h, _))`. Two things have to happen, and the order between them
matters. First the hypothesis rewrites the tail's fold under the conjunction:
the hole is the *second* argument of `Bool.and`, whose first argument is the
already-computed `Bool.not(h)`. That is well placed -- `and` matches on its
first argument, so with `h` a variable the application is stuck and the motive
can reach the second position. What is left after that rewrite is
`Bool.and(Bool.not(h), Bool.not(P.any_bool(t)))` on the left against
`Bool.not(Bool.or(h, P.any_bool(t)))` on the right: de Morgan, and nothing about
the list any more. That fact is not in the prelude, it is not a law, and it does
not follow from the induction -- it is the second lemma, and it too is a case
split, on the first argument of the `or` (or of the `and`), never on the second.

`neg_all_any` is the same law with the folds exchanged, and its step needs the
*other* de Morgan direction: once the hypothesis has replaced `any(neg_all(t))`
by `not(all(t))`, the goal is a disjunction of negations against the negation of
a conjunction. A policy that states one direction and reuses it at the other law
finds the goal stuck -- the two are not interderivable by `Equal.sym` alone,
since one is about `and` and the other about `or`.

Neither de Morgan direction is a fact about lists, so both go under the reserved
`Policy.` namespace, which the gate ignores and the credit path does not count.
A helper may call `P.*`, `S.*` and other `Policy.*`, but never a law, since a
helper that cited one would make an isolated law depend on a law that has not
been credited yet and the credit for both would be lost.

The direction of every rewrite is the one that matters. To replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way: the rewrite fills the hole
where the equation's right side sits with its left side, so a lemma stated with
`O` on the left has to be flipped before it can replace anything. The helpers
here are stated in the direction the goal needs -- `b == Bool.not(Bool.not(b))`
and the de Morgan facts with the negation of the `or` (resp. the `and`) on the
left -- so the goal usage is direct and only the hypothesis is flipped. Uses
inside a rewrite motive are dead and free, so a variable that appears only in
the goal and in a motive costs nothing.

Two details of the form matter here. First, a variable is **Lone** by default --
usable live once -- whether a pattern binds it or a signature declares it, and
the steps of the last three laws use the destructured tail more than once: in
the goal, inside a fold, and again as the hypothesis's argument. That is why the
lists are `List<&2, Bool>` and the laws bind `for +xs: List<&2, Bool>`: a `+`
binder is only allowed on a list whose kind is `Data`, and it is what makes the
tail reusable. Writing `+t = t` to rebind the tail instead fails with
`expected : Data, observed : Type`, and leaving the lists as plain `List<Bool>`
fails with `expected : t / observed : t (consumed more than once)`. Second, the
law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `all_bool`
must say `P.all_bool`; naming `S.all_bool` gets `expected : a defined name /
observed : S.all_bool`, which reads like a proof bug and is not one. Anything
the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.neg_all_nil()`, then `def L.neg_all_cons(h, t)`, then
`def L.neg_all_involutive(xs)`, then `def L.neg_all_all(xs)`, then
`def L.neg_all_any(xs)`, and each may cite the earlier helpers but never one of
the other laws. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
