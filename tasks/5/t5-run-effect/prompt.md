Implement `step`, `run` and `effect`, then prove all nine laws.

The machine is a list of instructions and one number. `run(prog, s)` is the
accumulator after executing `prog` from `s`, reading the program left to right;
`step(s, i)` is one instruction applied to the accumulator. `effect(prog)` is
the instruction set's other reading of the same text: the number the program
adds to the accumulator, computed from the program alone and never from a
state. The prelude owns the type (`P.Instr`, with the constructors `P.Inc{}`
and `P.Add{n}`) and `P.cat`, the append on programs. `<>` in Bend is the list
*constructor*, not append, which is why `P.cat` is in the prelude rather than
written inline in the laws.

`step_inc`, `step_add`, `run_inc`, `run_add`, `effect_inc` and `effect_add` are
the six pins. Each names one function on one instruction, and together they fix
both functions completely: there are two instructions, so a body that answers
both of them answers everything, and a body that answers `run` on both
singletons and satisfies a concatenation law has nowhere left to go. They are
not decoration. Before they existed this task was measured at tier 4 by
`run(prog, s) = s` together with `effect(prog) = 0n`, a pair that satisfies
every program-level law here -- each one leaves the other function free to
absorb the damage -- and it is the reason the summary and the interpreter are
pinned separately rather than only through the law that relates them.

`effect_inc` is not quite definitional: `effect` reports `1n + effect(Nil{})`
and `1n + 0n` reduces, so that one is free, but `effect_add` reports
`n + effect(Nil{})` and `n + 0n` is stuck on a variable. Even a pin needs one
arithmetic fact.

`run_compose` says running a concatenation is running the two halves in turn.
No `run` that ignores its program can satisfy it, and the proof has to be taken
over an arbitrary state rather than the one the law is handed, because the
step applies the hypothesis at the accumulator the first instruction produced.

`effect_hom` is the same shape for the summary, and its step is one
reassociation: after the hypothesis both sides carry the same two terms, one
bracketed left and the other right.

`run_effect` is the law the task is named for and the only one that relates the
two readings of the program. It says the summary is exactly what execution
does. Note what it is *not*: because the six pins already determine both
functions, this law is implied by them, so it is not the law that catches a
degenerate body -- the pins do that. It is the theorem, and it is the hardest
proof here, which is why it is worth its own reward rather than being folded
into the definition.

Two things about the shape of the work. `Nat.add` matches on its *left*
argument, so `a + 0n` is stuck for a variable `a` and `b + (1n + p)` will not
hand its successor to the front: the step needs an instruction's contribution,
which arrives on the left of the state, to end up on its right, past a variable
that `Nat.add` cannot look through. Both `run_effect` and the reassociation
below it need that rotation, and there is no way to get it from the definitions
alone. And a rewrite `%e : P` is the J axiom, not a rewrite tactic: the `_` in
`P` marks the position at which the evidence's *right* endpoint sits in the
current goal, and the goal you are left with has the evidence's *left* endpoint
there. A rewrite whose evidence points the wrong way is not rejected for its
direction -- it fails the check that says the substitution reproduces the goal
you were already looking at.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.step_inc(s)`, `def L.step_add(s, n)`, `def L.run_inc(s)`,
`def L.run_add(s, n)`, `def L.effect_inc()`, `def L.effect_add(n)`,
`def L.run_compose(p1, p2, s)`, `def L.effect_hom(p1, p2)` and
`def L.run_effect(prog, s)`. Proof helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
