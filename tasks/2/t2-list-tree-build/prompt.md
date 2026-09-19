Implement `build` -- a list of numbers into a tree -- then prove the five laws.

The type is the task's own, declared in the prelude, so both its constructors
and its functions are reached through the prelude alias: `P.Leaf{v}` and
`P.Node{l, r}` are how they are written in a pattern and in a term. The prelude
is immutable. It has `P.len` (how many elements a list has), `P.leaves` and
`P.right_spine` (two counts of the tree -- all its leaves, and the nodes along
its right spine), `P.rightmost` (the value at the rightmost leaf) and
`P.last_or_zero` (the last element of a list, zero when there is none).

`build(bs)` recurses on the list. `Nil{}` becomes the sentinel leaf
`P.Leaf{0n}`, and `h <> t` becomes `P.Node{P.Leaf{h}, build(t)}`: the head's
one-leaf tree on the left, the rest of the list built into the right child. The
answer is a left-leaning comb -- every element's leaf sits on the right spine,
the head at the top, the last element at the bottom, and the sentinel leaf at
the very bottom. The sentinel is what makes the node case total, and it is also
what `build_nil` is about.

`build_nil` fixes the empty case: `P.Leaf{0n}`. Its left-hand side is a ground
term, both sides compute, and it is definitional. Nothing else in this file
looks at that case -- it is an answer a stopped match gives, not a step -- which
is why it is stated on its own.

`build_cons` fixes the shape at a cons, and it is definitional as well. This is
the law that pins the leaning: the head is the *left* child's leaf, and the tail
is built into the *right* child. A body that leaned the other way, or that put
the head somewhere else along the spine, leaves the two sides of this
unconvertible.

`build_leaves` says the answer has one leaf per element, plus the sentinel. Its
step unfolds the answer into a node, and `P.leaves` of a node is the sum of its
halves, so the hypothesis at the tail rewrites the right half and leaves
`1n + P.leaves(build(t))` against `1n + (1n + P.len(t))`.

`build_right_spine` says the same thing about the right spine instead of about
the leaves: one spine node per element, plus the sentinel. Read the two
together and they say something neither says alone. A tree with as many spine
nodes as leaves has *all* of its leaves on the right spine, so the pair rejects
a body that built a right-leaning comb -- the leaves are still all there and the
count is still right, and the shape is not. That is why the two laws share a
right-hand side honestly: what tells them apart is the left one.

`build_last` says the bottom of the spine carries the last element. `P.rightmost`
descends the right spine and `P.last_or_zero` walks the list to its end, and both
of them ignore the head, so the step is the hypothesis at the tail and nothing
else. It is what a body that kept the shape and the count while losing the
elements after the first cannot do.

The three measure laws bind the list `for +bs`. Each names it twice -- once
inside the recursive call the induction quantifies and once in what is left of
the goal -- and a list that is live twice is not Lone. `build_cons` names its
head and tail once each and is written plain; `build_nil` has no binders.

One arithmetic note worth having before writing `build_leaves`: the law puts the
`1n` on the *outside* of the right-hand side. That is not decoration. The goal
after the rewrite is `1n + P.leaves(build(t))` against `1n + (1n + P.len(t))`,
and with the `1n` outside, the two sides are the same term. With
`P.len(bs) + 1n` on the right instead, the empty case is the one that suffers,
and `Nat.add` matches on its first argument.

The naming rule the proofs need: the law file imports the prelude as `P` and the
solution as `S`, and the solution does not re-export the prelude, so a law that
means the prelude's `leaves` must say `P.leaves`; naming `S.leaves` gets
`expected : a defined name / observed : S.leaves`, which reads like a proof bug
and is not one. Anything the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.build_nil()`, `def L.build_cons(h, t)`, `def L.build_leaves(bs)`,
`def L.build_right_spine(bs)` and `def L.build_last(bs)`, and each may cite the
earlier helpers but never one of the other laws. A helper, if one is needed, goes
under the reserved `Policy.` namespace, which the gate ignores and the credit
path does not count. Write the implementation in `solution.bend` and the proofs
in `PROOF.bend`.
