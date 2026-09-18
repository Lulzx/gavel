Implement `flatten` on the prelude's `Tree`, then prove all four laws.

The type is the task's own, declared in the prelude, so both its constructors
and its functions are reached through the prelude alias: `P.Leaf{v}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude
is immutable and already has the vocabulary the laws are stated in -- `P.append`,
`P.snoc`, `P.len` and `P.rev` on `List<&2, Nat>`, `P.leaves` (the number of
leaves) and `P.mirror`. `solution` is where `flatten` lives.

`flatten(t)` is the leaf values of `t`, left to right. Both subtrees are used
exactly once, so the definition itself needs nothing special.

The two measure laws are inductions on the tree, and a tree induction has *two*
hypotheses: the step is a case on the two constructors, and each subtree is
live **twice**, once as the recursive call the hypothesis replaces and once in
what is left of the goal. A variable is Lone by default -- usable live once --
so both laws bind `for +t: P.Tree`. `Tree is Data`, which is what makes the `+`
legal; with a bare `for t: P.Tree` the second use of a subtree fails with
`expected : l / observed : l (consumed more than once)`.

`flatten_leaf` and `flatten_node` are definitional: they fix what the answer is
at each constructor, and without them a body that drops a subtree can still be
the right *size* once something else compensates.

The real work is the two measure laws, because each one needs a **list** lemma
inside the tree induction, and neither lemma is definitional:

- `flatten_leaves` unfolds `flatten` of a node into `P.append`, and `P.len`
  cannot step past it -- `append` matches on its first argument, so with a
  variable list the goal is stuck. The lemma is `len(append(xs, ys)) ==
  len(xs) + len(ys)`, an induction on the list, and the tree step uses it once
  and then the two tree hypotheses.
- `flatten_mirror` says flattening a mirror is reversing a flattening, and it is
  the law that pins the *order*: the length law accepts any body that produces
  the right multiset, including one that appends the two subtrees the wrong way
  round. Its step needs `rev(append(xs, ys)) == append(rev(ys), rev(xs))`, which
  is itself an induction that needs the reassociation of `snoc` and `append`
  (`snoc(append(xs, ys), y) == append(xs, snoc(ys, y))`) and the fact that
  appending `Nil{}` on the right changes nothing.

Every one of those helpers is the policy's to write, and they belong under the
reserved `Policy.` namespace, which the gate ignores and the credit path does
not count. A helper may call `P.*`, `S.*` and other `Policy.*`, but never a law,
since a helper that cited one would make an isolated law depend on a law that
has not been credited yet and the credit for both would be lost. Their list
parameters need `+` too, for the same reason the laws do: each of those steps
uses its subject twice. `List<&2, Nat>` is the list type here, and a law or
helper written over `List<Nat>` will not unify with these.

The direction of every rewrite is the one that matters. To replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way: the rewrite fills the hole
where the equation's right side sits with its left side, so a lemma stated with
`O` on the left has to be flipped before it can replace anything. Uses inside a
rewrite motive are dead and free, so a variable that appears only in the goal
and in a motive costs nothing.

The law file imports the prelude as `P` and the solution as `S`, and the
solution does not re-export the prelude, so a law that means the prelude's `len`
must say `P.len`; naming `S.len` gets `expected : a defined name / observed :
S.len`, which reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.flatten_leaf(v)`, `def L.flatten_node(l, r)`,
`def L.flatten_leaves(t)` and `def L.flatten_mirror(t)`, and each may cite the
earlier helpers but never one of the other laws. Write the implementation in
`solution.bend` and the proofs in `PROOF.bend`.
