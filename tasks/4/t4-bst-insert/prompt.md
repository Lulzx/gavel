Implement `ins_at`, `insert` and `count`, then prove all nine laws.

`insert(t, k)` is `t` with `k` stored in it: the keys already there are kept and
`k` is added, so an ordered tree stays ordered. `count(t, x)` is how many keys
in `t` are equal to `x`, counting equal keys rather than answering yes or no.
The prelude owns the type (`P.Tip{}`, `P.Bin{l, key, r}`), the ordering
predicate (`P.ordered`, built from `P.all_le` and `P.all_ge`), the comparison
`P.le` and the indicator `P.is_eq`, which returns `1n` or `0n` rather than a
`Bool` so that a count is a sum of indicators.

`insert_leaf`, `insert_le` and `insert_gt` are definitional pins. They fix what
`insert` does on a one-node tree -- a key at most the node's goes to its left, a
key greater goes to its right -- and they are what rules out an implementation
that stores the key in the wrong place on a small tree.

`ins_at_tip`, `ins_at_left` and `ins_at_right` are also definitional, and they
are `ins_at`'s definition written out: one case for the tip and one per
decision at a node. They are what makes the stub's first obligation an
obligation. `ins_at` is reached by no law about `insert`, so without them a
submission can put the descent wherever the gate allows -- including under
`Policy.` -- and leave `ins_at` answering its own tree for full reward. A
submission may still delegate the work to a `Policy.` helper; what it may not
do is hand back something `ins_at` is not.

`count_tip` is the third definitional pin, and it is the one that makes `count`
a value rather than a difference. On its own `insert_count` fixes only how the
count *changes*: `count(t, x) = 1n + <the real count>` satisfies it at every
input, because the `1n` appears on both sides and cancels. `count_tip` names
`count` at a closed term -- `S.count(P.Tip{}, x) == 0n` -- and `1n` is not `0n`.
It is `count`'s base case, and since every tree is reached from `P.Tip{}` by
inserts, the base plus the increment determine the function.

`insert_ordered` and `insert_count` are the work.

`insert_ordered` is the invariant law. It is stated as an implication: the
statement carries `for e: {P.ordered(t) == True{} : Bool}` and what is to be
proved is `P.ordered(S.insert(t, k)) == True{}`. That premise is not decorative
-- an insert into an unordered tree is not claimed to produce anything -- and
the proof cannot skip it: `P.ordered` on a variable tree is stuck, so the step
has to unfold both the tree and the premise, and what is left is a pair of
bound lemmas, one per side of every node. Each of those is an induction of its
own, and each has to be generalized over the bound `b`. `P.root_key` is in the
prelude for the comparison the descent needs at the next node down.

`insert_count` is the multiset law: the count at a key goes up by exactly one
when that key is the one inserted. It needs no invariant hypothesis, only
arithmetic. After the induction hypothesis the inserted key's indicator is
nested inside the subtree it landed in and has to become a term of the whole
sum, which is one reassociation -- plus one commutation, because `Nat.add`
matches on its *left* argument and will not move a term past a variable on its
own. `a + 0n` is stuck for the same reason, so even the leaf case is not
definitional, and `P.is_eq(x, x)` is `1n` only by an induction of its own.

Two things about the shape of the descent, both of which the checker enforces
with an error rather than a warning, and both of which are why `ins_at` is
declared in the stub rather than left to you. A `match` cannot scrutinise a
computed value: `match P.le(k, key):` is refused with "a parameter or field
scrutinee (a match cannot scrutinize a computed value: give it its own def)", so
the decision has to be a parameter of a def. And two defs may not call each
other: an `insert` that calls `ins_at` which calls `insert` again is refused
with "a decreasing self-call (arguments are read left to right: each passed
unchanged until one shrinks)". `ins_at` is therefore its own recursion, with the
subtree it is descending into and the decision it was handed as its first two
parameters, computing the next decision itself. Its pattern variables are Lone
and a variable bound by a pattern is usable live once per branch: destructuring
a node and *also* passing the node on is "consumed more than once", so pass the
parts reassembled.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.insert_leaf(k)`, `def L.insert_le(x, y, e)`, `def L.insert_gt(x, y, e)`,
`def L.ins_at_tip(c, k)`, `def L.ins_at_left(l, key, r, k)`,
`def L.ins_at_right(l, key, r, k)`, `def L.count_tip(x)`,
`def L.insert_ordered(t, k, e)` and
`def L.insert_count(t, k, x)`. Proof helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
