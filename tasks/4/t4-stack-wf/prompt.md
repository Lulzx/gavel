Implement `step`, then prove all four laws.

A stack is a `List<&2, P.Sym>` read from the top, and a `P.Sym` is either
`P.Op{}` or `P.Cl{}`. `step(xs, s)` reads one symbol and pushes it: the stack it
is given is still there afterwards, with `s` on top. `P.snoc` is the prelude's
push, and `P.len` its length.

`step_op` and `step_cl` are definitional pins, one per symbol, and between them
they determine the body: they say exactly what a step on `Op` and what a step on
`Cl` has to be. `step_len` says the stack grows by exactly one, whatever the
symbol was.

`step_wf` is the invariant law, and it carries two premises rather than one.
`P.wf(xs)` is well-formedness: reading the stack from the top, the closes and
the opens balance, with every close matching an open above it. `P.closable(xs)`
says the stack still has an unmatched open to spend (`P.depth(xs) > 0n`). Both
are needed, and neither is decoration: `Nil{}` is well-formed, and `step(Nil{},
Cl{})` would close a bracket that was never opened, so the claim without the
second premise is false. A step on `Op` is safe either way; a step on `Cl` is
safe only for a stack that still has something to close, which is why the law as
stated says both and why the policy cannot weaken it.

The proof is the work, and the prelude's scans are what make it awkward.
`P.wf_go(xs, n)` and `P.depth_go(xs, n)` walk the stack carrying the number of
opens already seen, `P.wf` and `P.depth` being the same scans started at `0n`,
and both stop at different points: the scans have to be generalized over `n`, so
the lemma is "`P.snoc(xs, s)` keeps `P.wf_go(xs, n)`" for an arbitrary `n` and
an arbitrary accumulator, and the guard has to be carried through the same
generalization. The accumulator is also why `P.depth_go` steps it structurally
rather than writing `n - 1n`: `Nat.sub` is a `match` on both arguments and is
stuck when the first one is a variable.

Two smaller traps, both enforced by the checker. `P.le` and the accumulator
scans are defs, and `match` cannot scrutinise a computed value -- the match has
to be on a bound variable, which is why the prelude's scans pattern-match
symbols rather than comparing them. And a variable bound by a pattern is usable
live once per branch: a head that is used in both branches of a nested match has
to be bound `+h`, and a pattern variable that is also passed on is "consumed
more than once". To replace a term `B` in the goal with a term `B'`, supply a
proof of `{B' == B}` -- the hole in the motive marks `B`, and `Equal.sym` is
what turns a lemma stated the other way round into that shape.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.step_op(xs)`, `def L.step_cl(xs)`, `def L.step_len(xs, s)` and
`def L.step_wf(xs, s, e, g)`. Helpers go under the reserved `Policy.` namespace,
which the gate ignores, and none of them may cite a law.
