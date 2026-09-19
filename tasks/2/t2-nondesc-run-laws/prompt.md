Implement `nondesc_run`, the comparison-driven measure a run-based sort consumes,
then prove all five laws.

`nondesc_run(xs)` answers the length of the longest prefix of `xs` whose
elements do not decrease: how far a walk from the front gets before two
neighbouring elements are out of order. `nondesc_run([1n, 2n, 2n, 1n])` is `3n`;
`nondesc_run([3n, 1n, 2n])` is `1n`; `nondesc_run(Nil{})` is `0n`, because there
is no pair to get past.

The list type is `List<&2, Nat>`, and a law or helper written over `List<Nat>`
will not unify with these. The prelude is immutable and already has the
vocabulary the laws are stated in: `P.le(a, b)` is the `Bool` comparison,
`P.len(xs)` counts the elements, and `P.rl_step(x, t, n)` is the cons step with
the decision deferred to `P.rl_put`. That pair is there because of a Bend
restriction rather than for convenience: **a `match` cannot scrutinise a
computed value**, so the cons case cannot decide inline on how the head compares
with the element behind it. It hands the head, the tail and the tail's own
answer to `P.rl_step`, which is where the comparison lives.

`nondesc_run` recurses on `xs`: `Nil{}` answers `0n` and a cons cell answers
`P.rl_step(x, t, nondesc_run(t))`. The recursion is on the tail of the list it
matched, so it is structural.

`nondesc_run_nil` fixes the empty answer and `nondesc_run_single` the
one-element one. Both sides compute in each, so both are definitional and both
are pins. `nondesc_run_single` is the one that catches a walk seeded with a
constant rather than with the head: a run never stops before its first element.

`nondesc_run_up` and `nondesc_run_down` are the two answers the comparison can
give, stated on a list of at least two elements so that the tail is a variable
in both. `up` says the head being no larger than the element behind it lets the
walk continue, and the answer is one more than the walk on the tail; `down`
says the other value of the comparison stops the walk there, so the answer is
exactly `1n`. Each carries the comparison as a premise, because with `x` and `y`
variables `P.le` is stuck, and the premise is about the prelude's own predicate
over universally quantified values. Together the two laws say that nothing
after the first out-of-order pair is looked at.

Be aware of the division of labour: because `nondesc_run_up` and
`nondesc_run_down` are the two branches of the prelude's `P.rl_put` with the
premise supplied, a body that gets the cons case right already satisfies them.
Their independent weight is against a body that special-cases where the
comparison leads; the case-by-case evidence for them comes from the mutants, not
from an independent induction.

`nondesc_run_le_len` is the work, and the one law that is not an unfolding: a
run cannot be longer than the list it walks, so the walk neither invented
elements nor skipped any. It is stated on `x <> t` rather than on a bare list,
so that its induction has the head it needs: `nondesc_run(x <> t)` reduces to
`P.rl_put` of `P.le(x, y)` and the tail's own answer, and the answer on the
empty list is never consulted. With a variable tail neither side reduces, so
this is an induction on `t` with `x` fixed. Its step needs one fact the prelude
does not state -- that the step's answer is still below the list's length, given
that the tail's own answer is -- and that fact is itself a case split on the
decision, because `P.rl_put` cannot be reduced while the decision is unknown.
That fact goes in under the reserved `Policy.` namespace, which the gate
ignores, and it may not cite a law: a helper that did would make an isolated law
depend on a law that has not been credited yet, and the credit for both would be
lost.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.nondesc_run_nil()`, `def L.nondesc_run_single(x)`,
`def L.nondesc_run_up(x, y, t, e)`, `def L.nondesc_run_down(x, y, t, e)` and
`def L.nondesc_run_le_len(x, t)`.
