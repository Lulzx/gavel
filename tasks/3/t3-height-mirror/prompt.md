Implement `height` on the prelude's `Tree`, then prove all three laws.

The type is the task's own, declared in the prelude, so both its constructors and
its functions are reached through the prelude alias: `P.Leaf{}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude is
immutable and already has `P.mirror` (the two subtrees swapped at every node) and
`P.max` (the larger of two numbers). `solution` is where `height` lives.

`height(t)` is the number of edges on the longest path from the root to a leaf:
zero at a leaf, and one more than the taller of the two subtrees at a node.
Both subtrees are read once, so the definition itself needs nothing special.

The laws are inductions on the tree, and the step of each is a case on the two
constructors, so the step has *two* hypotheses rather than one. `height_leaf` and
`height_node` are the pins: both sides of each compute, so `{==}` closes them, and
they fix the bottom of the recursion and the step. `height_node` is the one that
says the answer comes from *both* subtrees -- a body that descended one side only,
`1n + S.height(l)`, agrees with `height_mirror` on every tree that leans that way
and leaves the two sides of `height_node` unconvertible.

`height_mirror` is the work. Its step leaves the two subtrees' heights in the
other order under the same `1n +`:

    case P.Node{l, r}:
      -- goal: height(mirror(Node{l, r})) == height(Node{l, r})
      -- unfolds to: 1n + max(height(mirror(r)), height(mirror(l)))
      --             == 1n + max(height(l), height(r))

so after the two hypotheses land the goal is `P.max(h, k)` against `P.max(k, h)`.
That is not an unfolding: `P.max` steps on its first argument and then on its
second, so on variables neither side reduces, and the helper that proves
`P.max(a, b) == P.max(b, a)` is the policy's to write. It is an induction on the
first argument with a case split on the second.

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
bare. A motive with the hole anywhere else is rejected with `expected`/`observed`
about the hole's type, which reads like a bug in the lemma and is not one. A
lemma stated the other way has to be flipped with `Equal.sym`, as in the bank's
other tree task.

Two naming rules. The law file imports the prelude as `P` and the solution as
`S`, and the solution does not re-export the prelude, so a law that means the
prelude's `max` must say `P.max`; naming `S.max` gets `expected : a defined name
/ observed : S.max`, which reads like a proof bug and is not one. Anything the
policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.height_leaf()`, `def L.height_node(l, r)` and
`def L.height_mirror(t)`, and each may cite the earlier helpers but never one of
the other laws. Helpers go under the reserved `Policy.` namespace, which the gate
ignores and the credit path does not count; a helper may call `P.*`, `S.*` and
other `Policy.*`, but never a law, since a helper that cited one would make an
isolated law depend on a law that has not been credited yet and the credit for
both would be lost. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
