Implement `drop_while` on lists of `Nat`, then prove all three laws.

`drop_while(xs, n)` returns everything after the longest prefix of `xs` whose
elements are all at most `n`: the first element above the threshold and
everything behind it, unchanged. Recurse on `xs`: `Nil{}` returns `Nil{}`, and a
cons cell is thrown away and the tail's answer taken when the head is at most
`n`, and handed back whole when it is not.

The prelude is immutable and owns the vocabulary. `P.le(a, b)` is the `Bool`
comparison "`a` is at most `b`", and `P.drop_put(h, t, r, k)` is `r` when `k` is
`True{}` and `h <> t` otherwise. That helper is there because of a Bend
restriction rather than for convenience: **a `match` cannot scrutinise a
computed value**, so the cons step cannot decide inline on `P.le(h, n)`. It
takes the head and the tail as well as the recursion's answer because the step
that stops has to hand the whole list back from where it stopped.

That is also why the parameter is `+xs: List<&2, Nat>` rather than a plain
`xs: List<Nat>`. The cons step reads the tail twice -- once to ask the recursion
and once to hand it back -- and a variable is **Lone** by default, so a plain
parameter written that way is rejected with `consumed more than once`. The `+`
marker is what makes the second read legal, and it is available on a `List<&2,
Nat>` parameter; `t3-split-even-odd` binds its list the same way for the same
reason.

The three laws are the three cases of that walk, and together they fix it.

`drop_while_nil` says the empty list drops nothing. It is definitional --
`Nil{}` is a constructor, so both sides compute -- and it is the weak half on
its own.

`drop_while_keep` and `drop_while_stop` are the cons case, split by the
predicate's answer, and they are the pair that pins the function. `keep` says a
head at most the threshold is dropped and the answer is the tail's; `stop` says
the first head above the threshold is where the answer begins, so the whole list
from there comes back. A body that dropped nothing -- the identity on the list
-- is killed by `keep`, whose right-hand side is the recursion for the tail. A
body that dropped everything is killed by `stop`, whose right-hand side is a
cons cell. Neither law implies the other, and `nil` implies neither.

Each of the two carries its predicate answer as a **premise**: with `h` and `n`
variables `P.le(h, n)` is stuck, so without the premise neither side of the
equation reduces and the law says nothing. The premise is about the prelude's
predicate applied to universally quantified values, so it is a fact about the
input and no submission can falsify it. In the proof its effect is one rewrite:
the premise is `{P.le(h, n) == True{}}` and the goal wants `True{}` where the
predicate sits, so the step is `Equal.sym` around it -- a step `%e : P` replaces
the *right* side of `e`'s equation by the left in the motive `P`, and the hole
in `P` goes exactly where the term to be replaced sits. With the decision a
literal, `P.drop_put` computes and the goal closes by definition.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.drop_while_nil(n)`, `def L.drop_while_keep(h, t, n, e)` and
`def L.drop_while_stop(y, t, n, e)`.
