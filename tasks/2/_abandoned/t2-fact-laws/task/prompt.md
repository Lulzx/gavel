Implement `fact` on `Nat`, then prove the three laws.

`fact(n)` is the product of the numbers from `1n` to `n`: `fact(0n)` is `1n`,
`fact(1n)` is `1n`, and `fact(5n)` is `120n`.

The recursion is on the parameter itself, and the parameter is the whole
descent -- there is no accumulator and no fuel. `0n` is the arm the loop stops
at and answers `1n`; a successor answers itself times the factorial of its
predecessor. That is a structural descent, so the self-call is accepted: the
argument of `fact` in the step is the predecessor bound by the pattern, which is
a subterm of the argument that was matched.

The parameter is read twice in the step -- once as the scrutinee of the match
and once as the number being multiplied -- so it is declared reusable: `+n`.
A binder is consumed on every use, and without the marker the second read of the
same name is rejected.

The law `fact_zero` is the pin on the arm where the loop stops, and it is the
only law whose argument is the literal `0n`. `fact_succ` is the step: a
successor is itself times the factorial of its predecessor. The step law fixes
the recursion at a variable argument, and it is definitional -- the successor
arm of the match is the whole of it -- so its proof closes with `{==}`.

Together those two laws determine the function: a `g` with `g(0n) == 1n` and
`g(1n + n) == Nat.mul(1n + n, g(n))` is the factorial by induction, so any body
that satisfies both is the one asked for. `fact_five` is the absolute law that
says what they compute: both sides are literals, so the checker evaluates them
and confirms that the product is one hundred and twenty rather than something
else with the same recurrence.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.fact_zero()`, `def L.fact_succ(n)` and `def L.fact_five()`.

ABANDONED, for the record, and the note was missing until 2026-09-19 — the
directory was parked without one and this paragraph is written from the task's
own files. All three laws are `{==}`-provable and the reference proves all three
that way: `fact_zero` and `fact_five` are ground terms the checker evaluates,
and `fact_succ` -- the step, and the only one that looks like work -- is
definitional, because the reference matches on its parameter, so `1n + n` is
constructor-headed and the law reduces to the same multiplication on both sides.
The pipeline's V3 check refuses a task whose every law the reference closes
reflexively -- "the task's reward can be earned without solving it" -- and it is
right to: a solver that wrote nothing but `{==}` would collect full reward.

**The repair is known and this task has not been re-authored with it.** The
sibling `t2-nat-half` was abandoned for the same reason -- its step law was over
`1n + 1n + p`, constructor-headed, and so `{==}`-only -- and it *was* repaired,
by adding a law whose argument is stuck on a **call** rather than on `+`:
`S.half(Nat.double(n)) == n`. That law reduces on neither side and is provable
by an induction that unfolds the call in its successor case, so it carries real
work and V3 is satisfied. The same move is available here -- a law relating
`fact` to a fold whose argument is stuck, or `fact` at a call-headed argument --
and until it is found this task stays parked. It is parked, not deleted, and it
is not a duplicate of anything in the manifest: no registered task implements
`fact`.
