Implement `count_while` on lists of `Nat`, then prove all three laws.

`count_while(xs, n)` returns how many elements of `xs` are at most `n` before
the first one that is not: the length of the longest prefix whose elements are
all at most `n`. Recurse on `xs`: `Nil{}` returns `0n`, and a cons cell
contributes one plus the tail's count when the head is at most `n`, and nothing
at all when it is not.

The prelude is immutable and owns the vocabulary. `P.le(a, b)` is the `Bool`
comparison "`a` is at most `b`", and `P.count_put(c, k)` is `1n + c` when `k` is
`True{}` and `0n` otherwise. That helper is there because of a Bend restriction
rather than for convenience: **a `match` cannot scrutinise a computed value**,
so the cons step cannot decide inline on `P.le(h, n)`. It does not take the head
as an argument -- a count does not carry the element, so the step is only what
the predicate's answer does to the tail's number.

The three laws are the three cases of that walk, and together they fix it.

`count_while_nil` says the empty list counts nothing. It is definitional --
`Nil{}` is a constructor, so both sides compute -- and it is the weak half, with
one thing of its own: since `n` is a variable on both sides it also rules out a
body that ignored its list argument and answered with the threshold.

`count_while_keep` and `count_while_stop` are the cons case, split by the
predicate's answer, and they are the pair that pins the function. `keep` says a
head at most the threshold is counted and the tail's count follows; `stop` says
the first head above the threshold ends the walk and `0n` comes back. A body
that answered `0n` for every list is killed by `keep`; a body that counted every
element -- `1n` plus the tail's count, with no predicate in it -- satisfies
`keep` and is killed by `stop`. Neither law implies the other, and `nil`
implies neither.

Each of the two carries its predicate answer as a **premise**: with `h` and `n`
variables `P.le(h, n)` is stuck, so without the premise neither side of the
equation reduces and the law says nothing. The premise is about the prelude's
predicate applied to universally quantified values, so it is a fact about the
input and no submission can falsify it. In the proof its effect is one rewrite:
the premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
predicate sits, so the step is `Equal.sym` around it -- a step `%e : P` replaces
the *right* side of `e`'s equation by the left in the motive `P`, and the hole
in `P` goes exactly where the term to be replaced sits. With the decision a
literal, `P.count_put` computes and the goal closes by definition.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_while_nil(n)`, `def L.count_while_keep(h, t, n, e)` and
`def L.count_while_stop(y, t, n, e)`.
