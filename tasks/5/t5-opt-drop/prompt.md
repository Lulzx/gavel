Implement `exec` and `opt`, then prove all eight laws.

The prelude owns the machine (`P.Op`, with the constructors `P.Zero{}`,
`P.Inc{}` and `P.Twice{}`) and the specification the optimiser is judged
against, `P.clean`. A program is a list of instructions read left to right, and
the machine holds one number, the accumulator.

`exec(prog, s)` runs a program from the accumulator `s`. `opt(prog, z)` is the
optimiser: `z` is what the caller knows about the accumulator where `prog`
starts -- `True{}` when it holds zero -- and a caller that knows nothing passes
`False{}`.

The instruction the task is about is the `Twice` that follows a `Zero`.
Doubling zero is zero, so that instruction cannot change what the program
computes and removing it is free -- but only there. A `Twice` the caller had no
licence to remove is a wrong answer, and the flag is the licence: it is not
decoration on `opt`, it is the difference between an optimiser and a bug.

`P.clean(p, z)` is **not yours**. It is the specification of what the optimiser
is allowed to leave behind, indexed by the same flag: under the claim the caller
made, the output has no `Twice` left where the accumulator is zero. Because it
lives in the immutable prelude, `clean_opt` is a statement about the policy's
code rather than a restatement of it.

`exec_nil`, `exec_zero`, `exec_inc` and `exec_twice` are the pins on `exec`, one
per instruction plus the empty program. Each is stated over an **arbitrary
tail** rather than over a one-instruction program, and that is the whole
difference between a pin and a decoration: an `exec` that applied the first
instruction and stopped would satisfy the one-instruction version of all four,
and none of the laws about the optimiser would notice either, because the
programs they compare are truncated in the same way on both sides. With the
tail arbitrary the four clauses determine `exec` by induction on the program.
They are definitional in the sense of this bank -- each is its own body read
back -- and the reference proves each with `{==}`.

The other three laws are the optimiser's, and they are three different
obligations rather than three ways of saying one thing. `clean_opt` is the
specification: it rejects an optimiser that kept a redundant instruction, and it
is the only law that does -- an optimiser that changes nothing satisfies both
correctness laws. `opt_sound` is correctness for the caller who claimed nothing,
and it rejects an optimiser that removed on its own initiative. `opt_sound_zero`
is correctness for the caller who claimed the accumulator is zero, and it is
what stops the claim from being taken on trust: an optimiser can answer `True`
with anything that is clean and be right about it in the sense of the other two
laws, and the only place that answer is cashed is here, where both programs are
run at zero and the results compared.

`opt_twice_zero` is the drop itself, named. The three laws above pin what `opt`
returns only up to `clean` and equal meaning, and that leaves one branch free:
`clean` forbids a `Twice` where the accumulator is known to be zero, but it
permits a `Zero`, and at a known-zero accumulator a `Zero` is a no-op -- so an
`opt` that answers `P.Zero{} <> opt(t, True{})` is clean and sound and is not
this optimiser. The `Twice`/`True` branch is the only free one, and it is free
precisely because it is the only branch allowed to remove an instruction.
`opt_twice_zero` is that branch's definition: the instruction goes, and nothing
takes its place.

Two things about the shape of the work. Bend's defs cannot mention a later def,
so the two soundness laws cannot be proved by a pair of helpers that call each
other -- and they need each other, because a `Zero` turns the unknown-state
obligation into the zero-state one and a `Twice` under a `False{}` turns it back.
State a single helper over the flag, alongside a small function whose whole job
is to name the accumulator the flag describes, and both laws fall out of one
induction: `opt_sound` is that helper at `False{}` and `opt_sound_zero` is it at
`True{}` and `0n`. And in the `Twice` case the helper has to be called with the
flag the *branch* established rather than the one it was handed, which is the
same distinction the laws are about.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.exec_nil(s)`, `def L.exec_zero(t, s)`, `def L.exec_inc(t, s)`,
`def L.exec_twice(t, s)`, `def L.clean_opt(p, z)`, `def L.opt_sound(p, s)`,
`def L.opt_sound_zero(p)` and `def L.opt_twice_zero(t)`. Proof helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
