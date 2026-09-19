Implement `partition_below` on the prelude's lists, then prove all four laws.

`partition_below(xs, n)` sorts `xs` by the predicate "at most `n`": the answer is
the elements that are at most `n`, in order, and the elements that are not, in
order. Bend has no tuples, so the answer is a data type: the prelude owns
`P.PairL`, built with `P.MkL{front, back}`, and the two projections `P.front`
and `P.back`. It also owns `P.le` and `P.len`. The list type here is
`List<&2, Nat>` and a law or helper written over `List<Nat>` will not unify with
these.

Recurse on `xs`: `Nil{}` partitions into `P.MkL{Nil{}, Nil{}}`, and a cons cell
hands the head, the tail's pair and the predicate's answer for the head to
`P.part_put`. `P.part_put(h, p, k)` is there because **a `match` cannot
scrutinise a computed value**: the cons step cannot decide inline on
`P.le(h, n)`, so the decision is passed in and the helper is where the two
branches live. Both branches keep both halves: the head joins the *front* when
it passes and the *back* when it does not, and the other field comes from the
tail's pair either way. Nothing here ends the walk -- this is not a `span`,
which stops at the first element above the threshold and hands the rest back as
one piece.

The cons step reads the head twice -- once for the predicate and once for the
half it joins -- so the parameter is `+xs: List<&2, Nat>` rather than a plain
`List<Nat>`: without the marker the body is rejected with `consumed more than
once`, and the `&2` on the element type is what lets an element be read a second
time. The same signature is written in `t3-split-even-odd`.

The four laws are the three cases of the walk and the count of what they
produced.

`partition_below_nil` says the empty list partitions into two empty lists. It is
definitional and it is the weak half.

`partition_below_keep` and `partition_below_drop` are the cons case, split by
the predicate's answer. `keep` says a head at most the threshold joins the
*front* of the tail's pair, with the back taken from that same pair; `drop` says
a head above the threshold joins the *back*, with the front taken from that same
pair. `drop` is the half the bank's existing `filter` cannot state, because
there the rejected element is discarded: here it has to be somewhere, and this
is the law that says where. Together the two are what says both halves come from
one recursion: a body that put every element in the front, or every element in
the back, or that swapped the two fields, leaves one of the two sides
unconvertible. Neither implies the other. Both carry the predicate's answer as a
**premise**, because with `h` and `n` variables `P.le(h, n)` is stuck; the
premise is about the prelude's predicate over universally quantified values, so
no submission can falsify it -- it is not a condition the policy could arrange
to be false. In the proof each is one rewrite: a step `%e : P` replaces the
*right* side of `e`'s equation by the left in the motive `P`, and the hole in
`P` goes where the term to be replaced sits -- so the premise, which is
`{P.le(h, n) == True{}}`, goes in around `Equal.sym` to turn the predicate into
the literal the helper can match on.

`partition_below_len` is the work, and the one law that is not an unfolding: the
two halves have between them as many elements as the input. Nothing reduces on
its own -- `S.partition_below` of a variable list is stuck -- so this is an
induction on `xs`, with `n` a parameter throughout, and the hypothesis at the
tail is the only thing that can rewrite the goal after the cons case unfolds it.
The step needs one fact the prelude does not state: what `P.len` does to the
pair the cons step produced, i.e. what `h <> P.front(p)`, `P.back(p)`,
`P.front(p)` and `h <> P.back(p)` are lengths of. That fact depends on the
decision, and the decision is stuck, so it is a helper of its own -- one that
takes the decision as an argument and takes the hypothesis as an argument too,
because the two branches want different things from it. On the passing branch
the `1n +` for the head sits outside the two lengths the hypothesis is about.
On the rejecting branch the head joins a list the hypothesis is about from the
*right*, so the goal is `a + (1n + b)` against `1n + P.len(t)` where the
hypothesis gives `a + b == P.len(t)`: nothing reduces, because `+` matches on
its left argument and `a` is `P.len(P.front(p))`, stuck. That branch needs a
reassociation the prelude does not have, and it is a lemma of its own --
`Policy.add_succ_right(a, b)`, `a + (1n + b) == 1n + (a + b)`, by induction on
`a` -- with no law in it. The helper's pair is taken as `+p`, because the
rejecting branch names both projections twice and a plain parameter may be read
once.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.partition_below_nil(n)`, `def L.partition_below_keep(h, t, n, e)`,
`def L.partition_below_drop(y, t, n, e)` and `def L.partition_below_len(xs, n)`.
Any helpers you need go under the reserved `Policy.` namespace, which the gate
ignores, and none of them may cite a law -- a helper that did would make an
isolated law depend on a law that has not been credited yet, and the credit for
both would be lost.
