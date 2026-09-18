Implement `nth` and prove all four laws.

`nth(k, xs)` is the element of `xs` at index `k`, as a `Maybe<&2, Nat>`: `Some{x}`
when the list has an element at that index, `None{}` when it does not. Lists are
`List<&2, Nat>` and indices are `Nat`; `Maybe` is the base library's sum type, so
an answer is either `None{}` or `Some{x}` and the only thing a law can say about
one is which branch it took.

`P.len` and `P.is_some` are the prelude's, and immutable: they are the vocabulary
the laws are written in, not something to define.

The first two laws are the definition of the walk. `nth_zero` reads the head --
`0n` is a constructor, so both sides of the equation compute -- and `nth_succ`
steps over it, handing the *tail* to the recursive call with the index
decremented. `nth_succ` holds at every index, in range or not, and it is what
rules out a body that answers the head at every index: the answer has to depend
on the index the way `Nat` counts.

The other two laws are the domain, and they are the point of the task. Each
carries a premise, `for e: {Nat.is_lt(k, P.len(xs)) == True{} : Bool}` or the
same equation against `False{}`, and the premise is a fact about the *index and
the length* -- an invariant of the argument pair -- rather than about the answer.
What `nth_some` and `nth_none` say together is that the domain of `nth` is
exactly the indices the list has: `Some{}` on those, `None{}` on the rest. The
premise is not decoration and must be *used*, not merely assumed: in the branches
where the list has run out, `P.len` and `Nat.is_lt` have reduced to constants and
the hypothesis has become `{False{} == True{}}`, from which the goal follows by
transport. That transport is the work: build an `ite` indexed by the boolean and
apply `Equal.cong` to it, so the equation between the two booleans carries the
equation between the two values.

There is deliberately no bare clause saying `nth(k, Nil{})` is `None{}`.
`nth_none` already says that, and says where the boundary is as well -- on `Nil{}`
its premise reduces to `{False{} == False{}}`, which *holds*, so the conclusion
is not vacuous: every index is out of range on the empty list. A bare clause
would take this law's mutant weight, and the bodies that are wrong only on the
empty list would be killed by the clause with nothing left for the law the task
is about.

Three traps, all enforced by the checker. `match` cannot scrutinise a computed
value, and a nested `match` on a variable the outer pattern did not bind is
refused ("match scrutinees in binder order") -- so the index is consumed first,
`match k:` with the list read inside each branch. A self-call's decreasing
argument has to be structurally smaller, which is why the step recurses on `p`
and `t` rather than on anything the branch computed. And to replace a term `B` in
the goal with a term `B'`, supply a proof of `{B' == B}` -- the hole in the motive
marks `B`, and `Equal.sym` is what turns a lemma stated the other way round into
that shape.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.nth_zero(h, t)`, `def L.nth_succ(k, h, t)`, `def L.nth_some(k, xs, e)` and
`def L.nth_none(k, xs, e)`. Helpers go under the reserved `Policy.` namespace,
which the gate ignores, and none of them may cite a law.
