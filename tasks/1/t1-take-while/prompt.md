Implement `take_while` on lists of `Nat`, then prove all three laws.

`take_while(xs, n)` returns the longest prefix of `xs` whose elements are all at
most `n`, in order. Recurse on `xs`: `Nil{}` returns `Nil{}`, and a cons cell
starts where the tail does and keeps its head only when the head is at most `n`.

The prelude is immutable and owns the vocabulary. `P.le(a, b)` is the `Bool`
comparison "`a` is at most `b`", and `P.keep_put(h, r, k)` is `h <> r` when `k`
is `True{}` and `Nil{}` otherwise. That second one is there because of a Bend
restriction rather than for convenience: **a `match` cannot scrutinise a
computed value**, so `case P.le(h, n):` inside `take_while` is not a thing you
can write, and neither is a cons step that answers two different ways on a
`Bool` it just computed. Recurse on `xs` and hand the decision to the helper.

The three laws are the three cases of that walk, and together they fix it. None
of them is a restatement of another.

`take_while_nil` says the empty list takes nothing. It is definitional -- `Nil{}`
is a constructor, so both sides compute -- and it is the weak half on its own: it
answers only where the list has already run out.

`take_while_keep` and `take_while_stop` are the cons case, split by the
predicate's answer, and they are the pair that pins the function. `keep` says a
head at most the threshold is kept and the answer for the tail follows it;
`stop` says the first head above the threshold stops the walk and nothing comes
back. A body that answered `Nil{}` for every list is killed by `keep`, whose
right-hand side is a cons cell; a body that kept every element -- the identity
on the list -- satisfies `keep` and is killed by `stop`, whose right-hand side
is `Nil{}`. Neither of the two implies the other, and `nil` implies neither.

Each of the two carries its predicate answer as a **premise**: with `h` and `n`
variables, `P.le(h, n)` is stuck, so without the premise there is nothing for
either side of the equation to reduce to and the law would say nothing at all.
The premise is about the prelude's predicate applied to universally quantified
values, so it is a fact about the input and no submission can falsify it. Its
effect in the proof is one rewrite: the premise is
`{P.le(h, n) == True{}}`, and the goal wants `True{}` where the predicate sits,
so the step is `Equal.sym` around it -- a step `%e : P` replaces the *right*
side of `e`'s equation by the left in the motive `P`, and the hole in `P` goes
exactly where the term to be replaced sits. Once the decision is a literal,
`P.keep_put` computes and the goal closes by definition.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.take_while_nil(n)`, `def L.take_while_keep(h, t, n, e)` and
`def L.take_while_stop(y, t, n, e)`.
