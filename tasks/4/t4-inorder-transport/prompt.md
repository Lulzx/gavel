Implement `inorder`, `all_le_put`, `all_ge_put` and `bst`, then prove all six
laws.

`inorder(t)` is the keys of `t` in ascending order: the left subtree's traversal,
then the node's key, then the right subtree's. `all_le_put(t, b, k)` is `k`
conjoined with "every key in `t` is at most `b`", and `all_ge_put` is the same
with "at least `b`"; both take the answer for the part already walked, the way a
left-threading list fold does, and return it conjoined with this node's
comparison, so that the tree fold and the list fold can be walked in the same
order. `bst(t, lo, hi, k)` is the range invariant: `k` conjoined with "every key
in `t` lies between `lo` and `hi`", where a node's key is the upper bound for its
left subtree and the lower bound for its right one.

The prelude owns the type (`P.Tip{}`, `P.Bin{l, key, r}`), the comparison
`P.le`, the traversal's building blocks (`P.append`, `P.len`, `P.size`), the
sortedness fold `P.sorted_put` and its seed-valued form `P.is_sorted`, the
seedless list bounds `P.all_le_list` and `P.all_ge_list`, and the left-threading
list folds `P.all_le_list_put` and `P.all_ge_list_put` that the transports are
stated with.

`inorder_tip` and `inorder_bin` are definitional pins: they are `inorder`'s
definition written out, one case per constructor, and they are what makes the
stub's first obligation an obligation. `inorder_len` is the measure law, one
element per node. It is implied by the pins and is kept anyway, because the laws
are also the readable statement of what the function is.

`inorder_all_le` and `inorder_all_ge` are the transports: a bound on the tree
becomes a bound on the list the traversal produces. Each is an implication whose
premise names the tree-side fold and whose conclusion names the list-side one.
They are the pair of laws that make the two folds' association matter, which is
why both sides thread their accumulator left to right rather than conjoining in
the order the recursion happens to produce.

`inorder_sorted` is the work: the range invariant implies the traversal is
sorted. Its premise is not decorative -- a traversal of a tree whose keys are
outside their range is not claimed to be sorted -- and the proof cannot skip it.
The statement to prove is about a list, and the premise is about a tree, so the
proof has to carry the bound across the traversal, and what survives the
induction is not just sortedness: it is sortedness together with the two list
bounds the transports are about. `Policy.bst_ind` is that stronger statement,
and the law is then one projection of it. At a node the two subtrees are joined
by the node's key, so the sortedness of the concatenation is a claim about
`X ++ [key] ++ Y` given the sortedness of each half and their separation -- the
step that makes this task more than the sum of its parts.

Two things about the shape of a recursion here, both of which the checker
enforces with an error rather than a warning. A `match` cannot scrutinise a
computed value: `match P.le(a, b):` is refused with "a parameter or field
scrutinee (a match cannot scrutinize a computed value: give it its own def)", so
a decision has to be a parameter of a def. And two defs may not call each other:
a recursion has to be a single def that shrinks its argument. Pattern variables
are Lone -- a variable bound by a pattern is usable live once per branch,
so destructuring a node and also passing it on is "consumed more than once";
declare a binder `+` when the body consults it more than once.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.inorder_tip()`, `def L.inorder_bin(l, key, r)`, `def L.inorder_len(t)`,
`def L.inorder_all_le(t, b, k, e)`, `def L.inorder_all_ge(t, b, k, e)` and
`def L.inorder_sorted(t, lo, hi, e)`. A law's binders are its def's parameters
in order, and a premise `for e: {...}` is one more parameter. Proof helpers go
under the reserved `Policy.` namespace, which the gate ignores, and none of them
may cite a law.
