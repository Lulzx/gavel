Implement `tree_map` on the prelude's `Tree`, then prove the three laws.

The type is the task's own, declared in the prelude, so both its constructors
and its functions are reached through the prelude alias: `P.Leaf{v}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude
is immutable. It has `P.inc` (adds one to a number), `P.leftmost` and
`P.rightmost` (the values at the two extreme leaves, each descending one side),
and `P.leaves` (how many leaves the tree has).

`tree_map(t)` returns the same tree with `P.inc` applied at every leaf. Recurse
on `t`: `P.Leaf{v}` becomes `P.Leaf{P.inc(v)}`, and `P.Node{l, r}` becomes
`P.Node{tree_map(l), tree_map(r)}`.

None of the three laws is definitional; each is an induction on the tree, and
the step of each is a case on the two constructors. That makes each step *two*
hypotheses, and the tree is then live twice -- once as the recursive call the
hypothesis replaces and once in what is left of the goal -- so the laws bind
their tree `for +t: P.Tree`. `Tree is Data`, which is what makes the `+` legal
on it; with a bare `for t: P.Tree` the second use of a subtree fails with
`expected : l / observed : l (consumed more than once)`.

`tree_map_leftmost` says the leftmost leaf of a mapped tree is `P.inc` of the
leftmost leaf of the original. `P.leftmost` descends the left spine, so the
step is the hypothesis at the left subtree and nothing else. It is the law that
rules out the identity body, which leaves `P.leftmost(t) == P.inc(P.leftmost(t))`
stuck on a variable, and the constant bodies, which map nothing at all.

`tree_map_rightmost` is the dual, descending the right spine. It is not
redundant with the left one: a body that maps only the left subtree of each node
satisfies `tree_map_leftmost` and fails this one, and a body that maps only the
right subtree does the opposite.

`tree_map_leaves` says mapping does not change how many leaves there are. Its
step is the two hypotheses side by side, because `P.leaves` is a sum of the two
subtree counts and `P.inc` is applied below the leaves, not to the count. It is
what a body that drops a subtree, or that maps one subtree twice, cannot do
while the two laws above still hold.

The naming rule the proofs need: the law file imports the prelude as `P` and the
solution as `S`, and the solution does not re-export the prelude, so a law that
means the prelude's `leaves` must say `P.leaves`; naming `S.leaves` gets
`expected : a defined name / observed : S.leaves`, which reads like a proof bug
and is not one. Anything the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.tree_map_leftmost(t)`, `def L.tree_map_rightmost(t)` and
`def L.tree_map_leaves(t)`, and each may cite the earlier helpers but never one
of the other laws. A helper, if one is needed, goes under the reserved `Policy.`
namespace, which the gate ignores and the credit path does not count. Write the
implementation in `solution.bend` and the proofs in `PROOF.bend`.
