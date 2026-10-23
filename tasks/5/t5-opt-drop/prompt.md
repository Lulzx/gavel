Implement `exec` and `opt`, then prove the nine laws in `LAWS.bend`.

A program is a `List<&2, P.Op>` read left to right, run on a machine holding one
number, the accumulator. The instructions are the prelude's `P.Zero{}` (set the
accumulator to `0n`), `P.Inc{}` (add one) and `P.Twice{}` (double it).

`exec(prog, s)` is the accumulator after running `prog` from the accumulator
`s`, applying the first instruction first. The empty program returns `s`.

`opt(prog, z)` is the optimised program: `prog` with every `P.Twice{}` removed
that is reached while the accumulator is known to hold zero (doubling zero is
zero), and every other instruction kept, in order. `z` is what the caller knows
at the start: `True{}` when the accumulator holds zero there, `False{}` when
nothing is known. The accumulator is known to be zero at the start when `z` is
`True{}` and right after every `P.Zero{}`; a removed `P.Twice{}` keeps that
knowledge, while a `P.Inc{}` or a kept `P.Twice{}` ends it.

    exec([P.Inc{}, P.Twice{}], 3n) == 8n
    opt([P.Zero{}, P.Twice{}, P.Inc{}, P.Twice{}], False{}) == [P.Zero{}, P.Inc{}, P.Twice{}]
    opt([P.Twice{}, P.Inc{}], True{}) == [P.Inc{}]
    opt([P.Twice{}, P.Inc{}], False{}) == [P.Twice{}, P.Inc{}]

The prelude's `P.clean(p, z)` is the specification of the optimiser's output:
it is `True{}` when `p`, started from an accumulator known to be zero exactly
when `z` is `True{}`, never reaches a `P.Twice{}` at a known-zero accumulator.
It tracks the knowledge the same way: a `P.Zero{}` makes it known-zero, and a
`P.Inc{}` or a `P.Twice{}` makes it unknown.

- `exec_nil`: running the empty program leaves the accumulator `s`.
- `exec_zero`: running `P.Zero{} <> t` from `s` is running `t` from `0n`.
- `exec_inc`: running `P.Inc{} <> t` from `s` is running `t` from `1n + s`.
- `exec_twice`: running `P.Twice{} <> t` from `s` is running `t` from `s + s`.
- `clean_opt`: `opt(p, z)` is clean under the same flag `z`.
- `opt_sound`: with flag `False{}`, the optimised program computes the same
  accumulator as `p` from every starting accumulator `s`.
- `opt_sound_zero`: with flag `True{}`, the optimised program computes the same
  accumulator as `p` when both start from `0n`.
- `opt_zero`: optimising `P.Zero{} <> t` under any flag gives `P.Zero{}`
  followed by `t` optimised with flag `True{}`.
- `opt_twice_zero`: optimising `P.Twice{} <> t` with flag `True{}` is
  optimising `t` with flag `True{}`: the `P.Twice{}` is dropped.
