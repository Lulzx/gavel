Implement `tree_sum` on the prelude's `Tree`, then prove all three laws.

The type is the task's own, declared in the prelude, so both its constructors and
its functions are reached through the prelude alias: `P.Leaf{}` and
`P.Node{l, key, r}` are how they are written in a pattern and in a term, with the
node's number sitting between its two subtrees. The prelude is immutable and
already has `P.mirror`, which swaps the two subtrees at every node and carries
the key across with the node. `solution` is where `tree_sum` lives.

`tree_sum(t)` is the sum of the keys in `t`: zero at a leaf, and at a node the
two subtrees' sums with the node's own key between them. The key is read once, so
the definition itself needs nothing special.

The laws are inductions on the tree, and the step of each is a case on the two
constructors, so the step has *two* hypotheses rather than one. `tree_sum_leaf`
and `tree_sum_node` are the pins: both sides of each compute, so `{==}` closes
them, and they fix the bottom of the recursion and the step. `tree_sum_node` is
the one that says the node's own key is counted -- a body that added only the
subtrees, `S.tree_sum(l) + S.tree_sum(r)`, agrees with `tree_sum_mirror` on any
tree whose keys are all zero and leaves the two sides of `tree_sum_node`
unconvertible.

`tree_sum_mirror` is the work. Its step leaves the two subtrees' sums swapped
around the key:

    case P.Node{l, key, r}:
      -- goal: tree_sum(mirror(Node{l, key, r})) == tree_sum(Node{l, key, r})
      -- unfolds to: (tree_sum(mirror(r)) + key) + tree_sum(mirror(l))
      --             == (tree_sum(l) + key) + tree_sum(r)

so after the two hypotheses land the goal is `(s + key) + u` against
`(u + key) + s`. That is arithmetic rather than anything about trees, and none of
it is definitional: `Nat.add` folds on its first argument, so `a + 0n` is stuck on
a variable, `a + b` does not commute, and `a + b + c` does not reassociate. The
helpers for those are the policy's to write, and the bank's other arithmetic
tasks use the same three.

Each subtree is live **twice** in that step -- once as the recursive call the
hypothesis replaces, and once in the tree that is left over as the goal. A
variable is Lone by default, usable live once, so the law binds `for +t: P.Tree`.
`Tree is Data`, which is what makes the `+` legal on it; with a bare
`for t: P.Tree` the second use of a subtree fails with `expected : l / observed :
l (consumed more than once)`.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare as the last line. A lemma stated the other way has to be flipped with
`Equal.sym`, as in the bank's other tree task. A motive with the hole anywhere
else is rejected with `expected`/`observed` about the hole's type, which reads
like a bug in the lemma and is not one. A motive may reach inside a constructor
and inside an operator application; uses inside a motive are dead and free, so a
variable that appears only in the goal and in a motive costs nothing.

Two naming rules. The law file imports the prelude as `P` and the solution as
`S`, and the solution does not re-export the prelude, so a law that means the
prelude's `mirror` must say `P.mirror`; naming `S.mirror` gets `expected : a
defined name / observed : S.mirror`, which reads like a proof bug and is not one.
Anything the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.tree_sum_leaf()`, `def L.tree_sum_node(l, key, r)` and
`def L.tree_sum_mirror(t)`, and each may cite the earlier helpers but never one
of the other laws. Helpers go under the reserved `Policy.` namespace, which the
gate ignores and the credit path does not count; a helper may call `P.*`, `S.*`
and other `Policy.*`, but never a law, since a helper that cited one would make
an isolated law depend on a law that has not been credited yet and the credit for
both would be lost. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
