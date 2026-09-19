Implement `snoc_tree` on the prelude's `Tree`, then prove the three laws.

The type is the task's own, declared in the prelude, so both its constructors
and its functions are reached through the prelude alias: `P.Leaf{v}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude
is immutable. It has `P.leftmost` and `P.rightmost` (the values at the two
extreme leaves, each descending one side) and `P.right_spine` (how many nodes
the right spine has).

`snoc_tree(t, v)` returns the tree with a new `P.Leaf{v}` appended at the
rightmost position -- as the right child of the bottom node of the right spine,
not as a new root. Recurse on `t`: `P.Leaf{x}` becomes
`P.Node{P.Leaf{x}, P.Leaf{v}}`, and `P.Node{l, r}` becomes
`P.Node{l, snoc_tree(r, v)}`.

The trap is the shape. `P.Node{t, P.Leaf{v}}` -- hang the new leaf on top of
whatever you were given -- has the new value at the rightmost leaf and leaves
the leftmost leaf where it was, so it satisfies the first two laws below and is
not the function being asked for. What separates the two is how far down the
right spine the new leaf sits, and that is what the third law measures.

`snoc_tree_rightmost` says the new leaf carries `v`. `P.rightmost` descends the
right spine and the recursion descends the same spine, so the step is the
hypothesis at the right subtree and nothing else. It is the law that rules out
the identity body, which leaves `P.rightmost(t) == v` stuck on a variable, and
every body that appends at the left or that overwrites the leaf it arrives at.

`snoc_tree_leftmost` says the leftmost leaf is unchanged. It is not implied by
the law above: a body that rebuilds each node with a constant in place of its
left subtree still puts `v` at the rightmost leaf, and this is the law that
rejects it. Its step is definitional at both constructors, because `P.leftmost`
never reaches the subtree the recursion rebuilds.

`snoc_tree_right_spine` says the right spine grows by exactly one node. This is
the law that pins the shape, and the wrapping body above fails it at every tree
with a right spine longer than one.

`snoc_tree_right_spine` binds its tree `for +t: P.Tree`, and so does
`snoc_tree_leftmost`: each names the tree twice in its statement, once as the
argument of the recursive call and once as the argument of the measure, and
`Tree is Data` is what makes the `+` legal. `snoc_tree_rightmost` names its tree
once and is written plain. The statement of the third law puts the `1n` on the
outside for a reason worth knowing before you write the step: `Nat.add` matches
on its first argument, so `1n + P.right_spine(t)` is the form in which the
hypothesis at the right subtree leaves both sides of the goal as the same term,
and `P.right_spine(t) + 1n` is not.

The naming rule the proofs need: the law file imports the prelude as `P` and
the solution as `S`, and the solution does not re-export the prelude, so a law
that means the prelude's `rightmost` must say `P.rightmost`; naming
`S.rightmost` gets `expected : a defined name / observed : S.rightmost`, which
reads like a proof bug and is not one. Anything the policy is not being asked to
write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.snoc_tree_rightmost(t, v)`, `def L.snoc_tree_leftmost(t, v)` and
`def L.snoc_tree_right_spine(t, v)`, and each may cite the earlier helpers but
never one of the other laws. A helper, if one is needed, goes under the reserved
`Policy.` namespace, which the gate ignores and the credit path does not count.
Write the implementation in `solution.bend` and the proofs in `PROOF.bend`.
