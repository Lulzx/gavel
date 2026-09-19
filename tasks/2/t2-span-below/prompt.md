Implement `span_below` on the prelude's lists, then prove all four laws.

`span_below(xs, n)` splits `xs` at the first element above `n`: the answer is
the prefix whose elements are all at most `n`, and everything from that first
element onwards. Bend has no tuples, so the answer is a data type: the prelude
owns `P.PairL`, built with `P.MkL{front, back}`, and the two projections
`P.front` and `P.back`. It also owns `P.len`. The list type here is
`List<&2, Nat>` and a law or helper written over `List<Nat>` will not unify with
these.

Recurse on `xs`: `Nil{}` spans into `P.MkL{Nil{}, Nil{}}`, and a cons cell hands
the head, the tail and the tail's pair to `P.span_put`, together with the
predicate's answer for the head. `P.span_put(h, t, p, k)` is there because **a
`match` cannot scrutinise a computed value**: the cons step cannot decide inline
on `P.le(h, n)`, so the decision is passed in and the helper is where the two
branches live.

The cons step reads the head twice -- once for the predicate and once for the
front it builds -- and the tail twice, once for the recursion and once for the
back the stopping case hands over. A variable is **Lone** by default, which is
why the parameter is `+xs: List<&2, Nat>` rather than a plain `List<Nat>`:
without the marker the body is rejected with `consumed more than once`, and the
`&2` on the element type is what lets an element be read a second time.
`t3-split-even-odd` binds its list the same way.

The four laws are the three cases of the walk and the count of what they
produced.

`span_below_nil` says the empty list spans into two empty lists. It is
definitional and it is the weak half.

`span_below_keep` and `span_below_stop` are the cons case, split by the
predicate's answer. `keep` says a head at most the threshold joins the *front*
of the tail's pair, with the back taken from that same pair; `stop` says the
first head above the threshold ends the walk, with an empty front and the whole
list from that head as the back. Together they are what says the two halves come
from one recursion: a body that put every element in the front, or every element
in the back, or that swapped the two fields, leaves one of the two sides
unconvertible. Neither implies the other. Both carry the predicate's answer as a
**premise**, because with `h` and `n` variables `P.le(h, n)` is stuck; the
premise is about the prelude's predicate over universally quantified values, so
no submission can falsify it. In the proof each is one rewrite: a step `%e : P`
replaces the *right* side of `e`'s equation by the left in the motive `P`, and
the hole in `P` goes where the term to be replaced sits -- so the premise, which
is `{P.le(h, n) == True{}}`, goes in around `Equal.sym` to turn the predicate
into the literal the helper can match on.

`span_below_len` is the work, and the one law that is not an unfolding: the two
halves have between them as many elements as the input. Nothing reduces on its
own -- `S.span_below` of a variable list is stuck -- so this is an induction on
`xs`, with `n` a parameter throughout, and the hypothesis at the tail is the
only thing that can rewrite the goal after the cons case unfolds it. The step
needs one fact the prelude does not state: what `P.len` does to the pair the
cons step produced, i.e. what `h <> P.front(p)` and `P.back(p)` are lengths of.
That fact depends on the decision, and the decision is stuck, so it is a helper
of its own -- one that takes the decision as an argument and takes the
hypothesis as an argument too, because the two branches want different things
from it. On one branch the `1n +` for the head sits outside the two lengths the
hypothesis is about; on the other, the tail's pair has dropped out of the goal
entirely and the arithmetic is trivial.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.span_below_nil(n)`, `def L.span_below_keep(h, t, n, e)`,
`def L.span_below_stop(y, t, n, e)` and `def L.span_below_len(xs, n)`. Any
helpers you need go under the reserved `Policy.` namespace, which the gate
ignores, and none of them may cite a law -- a helper that did would make an
isolated law depend on a law that has not been credited yet, and the credit for
both would be lost.
