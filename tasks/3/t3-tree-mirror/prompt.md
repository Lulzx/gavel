Implement `mirror` on the prelude's `Tree`, then prove all four laws.

The type is the task's own, declared in the prelude, so both its constructors
and its functions are reached through the prelude alias: `P.Leaf{v}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude
is immutable and already has `P.size` (the number of leaves), `P.leftmost` and
`P.rightmost` (the values at the two extreme leaves, each descending one side).
`solution` is where `mirror` lives.

`mirror(t)` returns the same tree with the two subtrees swapped at every node.
Both subtrees are used exactly once -- the leaves are carried across unchanged
-- so the definition itself needs nothing special.

The laws are inductions on the tree, and the step of each is a case on the two
constructors. That makes the step *two* hypotheses rather than one, and each
subtree is then live **twice**: once as the recursive call the hypothesis
replaces, and once in the tree that is left over as the goal. A variable is
Lone by default -- usable live once -- so the laws bind their tree `for +t:
P.Tree`. `Tree is Data`, which is what makes the `+` legal on it; with a bare
`for t: P.Tree` the second use of a subtree fails with `expected : l / observed
: l (consumed more than once)`.

`mirror_mirror` is the involution and the one that rules out the constant
bodies: `mirror(t) = P.Leaf{0n}` leaves `P.Leaf{0n} == t`, stuck on a variable.
`mirror_leftmost` and `mirror_rightmost` are the pair that rules out the
identity body, which the involution cannot: they say which of the two extreme
leaves comes out where, and the identity gets both of them wrong.
`mirror_size` is the law that needs arithmetic as well as trees: after the two
hypotheses have replaced the subtrees, the goal has `P.size(r) + P.size(l)`
against `P.size(l) + P.size(r)`, and `Nat.add` folds on its first argument, so
that is not definitional. The helper that proves `a + b == b + a` is the
policy's to write, and it needs the same two facts the bank's other arithmetic
tasks use (`a + 0n == a` is stuck, and `a + (1n + b)` is `1n + (a + b)`).

The direction of every rewrite is the one that matters. To replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way: the rewrite fills the hole
where the equation's right side sits with its left side, so a lemma stated with
`O` on the left has to be flipped before it can replace anything. The hole may
sit inside a constructor -- `{P.Node{_, S.mirror(S.mirror(r))} == P.Node{l, r}
: P.Tree}` is a motive -- and uses inside a rewrite motive are dead and free, so
a variable that appears only in the goal and in a motive costs nothing.

Two naming rules. The law file imports the prelude as `P` and the solution as
`S`, and the solution does not re-export the prelude, so a law that means the
prelude's `size` must say `P.size`; naming `S.size` gets `expected : a defined
name / observed : S.size`, which reads like a proof bug and is not one. Anything
the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.mirror_mirror(t)`, `def L.mirror_leftmost(t)`,
`def L.mirror_rightmost(t)` and `def L.mirror_size(t)`, and each may cite the
earlier helpers but never one of the other laws. Helpers go under the reserved
`Policy.` namespace, which the gate ignores and the credit path does not count;
a helper may call `P.*`, `S.*` and other `Policy.*`, but never a law, since a
helper that cited one would make an isolated law depend on a law that has not
been credited yet and the credit for both would be lost. Write the
implementation in `solution.bend` and the proofs in `PROOF.bend`.
