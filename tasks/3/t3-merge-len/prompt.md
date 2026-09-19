Implement `merge` on the prelude's `List<&2, Nat>`, and prove all seven laws.

`merge(xs, ys)` combines the two lists by comparing their heads with `P.le`: the
list with the smaller head is advanced and the other keeps its head, until one
list runs out, at which point the rest of the other is the answer. The prelude is
immutable and already has the vocabulary the laws are stated in: `P.le`, `P.len`
and `P.append`. `List<&2, Nat>` is the list type here, and a law or helper
written over `List<Nat>` will not unify with these.

There is a restriction that decides the shape of the implementation. **A `match`
cannot scrutinise a computed value**, so `case P.le(hx, hy):` is not something
you can write: the decision has to arrive as a parameter of its own def. That
second def is `merge_go(tx, hx, ty, hy, k)`, and it continues a merge in which
the left list is `hx <> tx`, the right list is `hy <> ty`, and `k` is the
already-computed `P.le(hx, hy)`. It is declared for you; both it and `merge` are
the policy's to write.

`merge_go` has a second constraint on it, and it is the one worth thinking about
before writing anything. A `match` consumes the binders in front of its
scrutinee, and nothing may be matched after the final match on the last
parameter. `k` is last, so `match k` has to be the innermost match of each
branch -- which means the heads that decide the *next* call have to come from
matches that happen before it. That is why the two tails are matched before `k`:
`P.le` of the next two heads is what the recursive call is handed, and the head
of the side being advanced is not available until its tail has been matched. The
recursive call also has to pass the shrinking list as the argument that differs
first, or the decreasing self-call check rejects it.

Five of the seven laws are pins, and they come in two pairs. `merge_nil_l` fixes
what an empty left list answers, and in `merge` both sides compute, so `{==}`
closes it. `merge_nil_r` takes a variable left list, so the match in `merge` is
stuck and it is an induction rather than an unfolding -- which is what makes it
worth stating: a body that read only one of its arguments satisfies
`merge_nil_l` and leaves the two sides of `merge_nil_r` unconvertible.

`merge_go_true` and `merge_go_false` pin what the decision *means*: a `merge_go`
branch whose two heads have nothing left to compare against owes its answer to
the comparison alone, and the two laws say which order each value of the
comparison calls for. They are definitional -- `merge_go(Nil, a, Nil, b, True)`
computes to `a <> b <> Nil`.

They are also the narrowest laws here, and it is worth being exact about how
narrow. Both are stated at `merge_go(Nil{}, a, Nil{}, b, k)`, so between them
they constrain exactly one of `merge_go`'s eight leaves -- the one where both
lists are exhausted, which `merge` reaches only when the caller handed it two
lists of one element each. Every other branch is reached through the recursion,
and `merge_len` is blind to order by construction. An earlier version of this
task shipped those two laws as the whole account of the decision, and an
order-swapping body -- the `(cons, cons, True)` branch recursing with
`P.le(hy, hx2)` where the reference recurses with `P.le(hx2, hy)` -- reached
**tier 4, complete, reward 1.000 against the reference proof**. That body is now
`mutants/merge_go-swap-args-27.bend`.

`merge_le_head` and `merge_gt_head` are the step, stated as an equation rather
than transcribed from the body, and they are what closes the gap the two
decision pins leave. Each carries the comparison as a premise on its own
binder -- `for e: {P.le(hx, hy) == True{} : Bool}` -- and concludes
`merge(hx <> tx, hy <> ty) == hx <> merge(tx, hy <> ty)`, with the mirror law
taking the `False{}` premise and answering `hy <> merge(hx <> tx, ty)`. That
sentence is the specification of the algorithm: *the list with the smaller head
is advanced and the other keeps its head*. Between them the two laws reach every
branch `merge` can produce -- one for each value of the top comparison, with the
tails arbitrary -- so there is no branch left for a body to answer differently.

The premise is not decoration. `merge_go`'s last parameter is the decision, and
`match` cannot see a computed value, so in the goal the decision sits there as a
stuck `P.le(hx, hy)` and the `match k` under it does not fire. The proof has to
spend the premise to get the body moving: `Equal.cong` over the decision
argument, with the motive `k => S.merge_go(tx, hx, ty, hy, k)` and the equality
thought of as `P.le(hx, hy) == True{}`, rewrites the stuck call to one whose
decision is `True{}` and the branch computes. A proof of the law that only says
`{==}` is refused, and that refusal is the checker telling you the premise is
load-bearing.

The real work is `merge_len`. It says `merge` keeps every element of both lists,
and it is the law that says the head is chosen by the comparison rather than by
which list it came from: a body that kept the two heads and dropped the tails --
`hx <> hy`, say -- satisfies all the pins above and leaves the two sides here
unconvertible. As stated, its direct induction does not go through, because the
step of `merge` moves past the heads the law was stated with. The induction has
to be *generalized* over both tails and over the decision, and that generalized
statement is not asked for and has to be found.

Two facts about `+` are needed along the way -- that it is associative on the
right, and that `a + 1n == 1n + a` -- and neither is in the prelude. They go in
as `Policy.` helpers, not as laws: a law that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost. A helper may call `P.*`, `S.*` and other `Policy.*`, but never a law.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole where the term you
want to replace sits, and a lemma stated the way you need it is used bare. A
motive with the hole anywhere else is rejected with `expected`/`observed` about
the hole's type, which reads like a bug in the lemma and is not one. The checker
also normalizes numeral arithmetic as it goes, so some branches that look like
they need a step are already closed by `{==}` and a step written there is
rejected as an identity.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `len` must say
`P.len`; naming `S.len` gets `expected : a defined name / observed : S.len`,
which also reads like a proof bug and is not one. `merge_go` is the policy's, so
it is `S.merge_go`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.merge_nil_l(ys)`, `def L.merge_nil_r(xs)`,
`def L.merge_go_true(a, b)`, `def L.merge_go_false(a, b)`,
`def L.merge_len(xs, ys)`, `def L.merge_le_head(hx, tx, hy, ty, e)` and
`def L.merge_gt_head(hx, tx, hy, ty, e)`, and each may cite the earlier helpers
but never one of the other laws. Write the implementation in `solution.bend` and
the proofs in `PROOF.bend`.
