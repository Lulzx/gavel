Implement `step`, `run` and `effect`, then prove the nine laws in `LAWS.bend`.

A program is a `List<&2, P.Instr>` read left to right, run on a machine holding
one number, the accumulator. The instructions are the prelude's `P.Inc{}`, which
adds one, and `P.Add{n}`, which adds `n`.

`step(s, i)` is the accumulator `s` after the one instruction `i`: `1n + s` for
`P.Inc{}` and `n + s` for `P.Add{n}`. `run(prog, s)` is the accumulator after
running `prog` from `s`, first instruction first; the empty program returns
`s`. `effect(prog)` is the total amount `prog` adds to the accumulator,
computed from the program text alone: `0n` for the empty program, one for each
`P.Inc{}` and `n` for each `P.Add{n}`.

    step(3n, P.Add{2n}) == 5n
    run([P.Inc{}, P.Add{3n}], 1n) == 5n
    effect([P.Inc{}, P.Add{3n}]) == 4n
    effect(Nil{}) == 0n

The prelude's `P.cat(p, q)` is `p` followed by `q` (`<>` is the list
constructor, not append).

- `step_inc`: a step on `P.Inc{}` from `s` gives `1n + s`.
- `step_add`: a step on `P.Add{n}` from `s` gives `n + s`.
- `run_inc`: running the one-instruction program `[P.Inc{}]` from `s` gives
  `1n + s`.
- `run_add`: running the one-instruction program `[P.Add{n}]` from `s` gives
  `n + s`.
- `effect_inc`: the effect of `[P.Inc{}]` is `1n`.
- `effect_add`: the effect of `[P.Add{n}]` is `n`.
- `run_compose`: running `P.cat(p1, p2)` from `s` is running `p1` from `s` and
  then `p2` from the result.
- `effect_hom`: the effect of `P.cat(p1, p2)` is the effect of `p1` plus the
  effect of `p2`.
- `run_effect`: running `prog` from `s` gives `s + effect(prog)`.
