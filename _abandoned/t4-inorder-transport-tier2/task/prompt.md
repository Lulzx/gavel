Implement `inorder` and prove all three laws.

`inorder(t)` is the keys of the tree `P.Tree`, left to right, as a
`List<&2, Nat>`. The tree has a number at every node (`P.Bin{l, key, r}`) and an
empty tree (`P.Tip{}`), and `P.append`, `P.len`, `P.size` and `P.is_nil` are the
prelude's; so are the two folds the laws are stated with, and all of them are
immutable.

The folds are what this task is about. `P.bounded(t, b, k)` asks whether every
key of `t` is at most `b`, given that `k` already holds of everything to the
left of `t`; `P.bounded_list(xs, b, k)` asks the same of the list `xs`. The
decision `k` is a *parameter* and not a `Bool.and` written into the return type,
because a `match` cannot scrutinise a computed term: the accumulator the
recursion carries is computed (`P.le(key, b)`, and the left subtree's answer),
and a parameter can be instantiated with a computed term even though a scrutinee
cannot. Read the tree fold's body carefully before writing anything: the
left subtree is folded first and its answer becomes the left conjunct of the
key's comparison. That association is the one an inorder traversal has, and the
transport below is convertible only because the two folds were written to agree.

`inorder_transport` is the law that relates the two structures: boundedness over
the tree implies boundedness over the list the traversal produces. It carries
its hypothesis as a premise, and the premise is *used*, not assumed -- the step
rewrites the goal to the tree side and then applies the hypothesis. It is not
vacuous at `P.Tip{}`, where the hypothesis reduces to `{True{} == True{}}` and
the conclusion follows from the fold's base case. Note what it cannot do: it is
a conjunction over a fold that is blind to permutations, so a body that emitted
the right subtree first would still satisfy it.

`inorder_node` is the order, and it is where the order is stated: the traversal
of a node is the left traversal, then the key, then the right one. It is
definitional for the reference -- both sides are the same `append` -- and it is
the only law that says where the key sits relative to the two subtrees. A law
about where a traversal *starts* is not enough, because it constrains only the
nodes whose left traversal is empty, and a preorder-shaped body agrees with an
inorder one there and on the count while disagreeing in between. The set is not
made of definitional laws, which is what keeps it admissible: the transport and
the measure both need inductions.

`inorder_size` is the measure: one element per node. It is blind to order, and
it is what reaches `P.Tip{}`, where `inorder_node` says nothing.

The proof is the work, and the shape is always the same: a tree induction whose
step meets lemmas about *lists*, because `P.bounded_list` matches on its first
argument and `P.append` puts the opaque `S.inorder(l)` in front of the goal. So
the transport needs `P.bounded_list(P.append(xs, ys), b, k)` in terms of
`P.bounded_list(xs, b, k)` and `P.bounded_list(ys, b, ...)` at the decision the
recursion carries, and the measure needs the length of an append plus one
arithmetic lemma, because `Nat.add` matches on its *left* argument and
`P.len(xs) + P.len(ys)` is stuck until the first is a constructor.

Three traps, all enforced by the checker. `match` cannot scrutinise a computed
value, and a nested `match` on a variable the outer pattern did not bind is
refused ("match scrutinees in binder order"). A binder used twice needs `+` in
its signature -- a tree induction has two hypotheses and each subtree is live
once as the recursive call and once in what is left of the goal. And to replace
a term `B` in the goal with a term `B'`, supply a proof of `{B' == B}`: the hole
in the motive marks `B`, and `Equal.sym` is what turns a lemma stated the other
way round into that shape.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.inorder_node(l, key, r)`, `def L.inorder_transport(t, b, e)` and
`def L.inorder_size(t)`. Helpers go under the reserved `Policy.` namespace, which
the gate ignores, and none of them may cite a law.
