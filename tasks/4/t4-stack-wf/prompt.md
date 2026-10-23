Implement `step`, then prove the four laws in `LAWS.bend`.

A stack is a `List<&2, P.Sym>` read bottom-first, so its last element is the
most recent symbol. A `P.Sym` is `P.Op{}` (an opening bracket) or `P.Cl{}` (a
closing one). `step(xs, s)` reads the symbol `s` and pushes it: the answer is
`xs` with `s` added at the end, whichever symbol `s` is.

    step([P.Op{}], P.Cl{}) == [P.Op{}, P.Cl{}]
    step(Nil{}, P.Op{}) == [P.Op{}]

Prelude names: `P.snoc(xs, s)` is `xs` with `s` added at the end, and `P.len`
is a list's length. `P.wf(xs)` says `xs` is a prefix of a balanced bracket
word: reading from the bottom, every `P.Cl{}` closes an earlier unmatched
`P.Op{}`. `P.depth(xs)` is the number of openings still unmatched after reading
all of `xs`, and `P.closable(xs)` says that number is greater than `0n`.
`P.wf_go(xs, n)` and `P.depth_go(xs, n)` are the same scans started with `n`
openings already unmatched; `P.wf` and `P.depth` start them at `0n`.

- `step_op`: a step on `P.Op{}` is `P.snoc(xs, P.Op{})`.
- `step_cl`: a step on `P.Cl{}` is `P.snoc(xs, P.Cl{})`.
- `step_len`: a step makes the stack exactly one longer, whatever the symbol.
- `step_wf`: when `xs` is well-formed and closable, `step(xs, s)` is
  well-formed, for either symbol `s`.
