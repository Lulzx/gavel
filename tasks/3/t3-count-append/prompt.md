Implement `count`, then prove all four laws.

`count(x, xs)` is how many elements of `xs` are equal to `x`. The prelude is
immutable and already has `P.append` and `P.is_eq`, which returns `1n` or `0n`
rather than a `Bool` so that a count is a sum of indicators.

`count_nil` and `count_cons` are definitional and fix the shape of the answer.
The other two are the work.

`count_self` needs two facts, neither of which is definitional: `P.is_eq(x, x)`
is `1n` (an induction of its own, on `x`), and `1n + 0n` is `1n`. `+` is
`Nat.add` and it matches on its *left* argument, so `1n + 0n` is stuck; the
helper that proves `a + 0n == a` is not optional, and the corpus states it the
other way round (`a == a + 0n`) so that the term to eliminate is on the right
of the equation -- to replace a term `B` in the goal you supply a proof of
`{B' == B}`.

`count_append` is the induction, and its step case is the whole task. After the
hypothesis the goal has `P.is_eq(x, h) + (S.count(x, t) + S.count(x, ys))` on
one side and `(P.is_eq(x, h) + S.count(x, t)) + S.count(x, ys)` on the other,
so it needs associativity of `+`. The catch is that the hypothesis has already
used `t`, the tail bound by `case h <> t:`, and a variable bound by a list
pattern is usable live **once** per branch -- `expected : t / observed : t
(consumed more than once)`. Rebind it with `+t = t` and you get
`expected : Data, observed : Type`. The way through is the shape the corpus
uses for arithmetic helpers: make the lemma's second and third parameters
erased (`-b: Nat, -c: Nat`, appearing only in its statement) and call it with
the tail in one of those positions, where the mention is free.

The same once-only rule is what the reference `count` runs into: `x` is used in
the indicator and again in the recursion, so the definition declares it `+x`.
A parameter is Lone by default just like a pattern binder, and `+` in a
signature -- or `+h <> t:` in a pattern -- is how a definition says it needs a
value more than once.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_nil(x)`, `def L.count_cons(x, h, t)`, `def L.count_self(x)` and
`def L.count_append(x, xs, ys)`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
