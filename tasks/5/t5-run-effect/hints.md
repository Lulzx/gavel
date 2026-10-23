The reference `step` matches the instruction. `run` is a left fold: `Nil{}`
answers `s` and `h <> t` answers `run(t, step(s, h))`. `effect` matches the
program with the instruction in the pattern: `0n`, `1n + effect(t)` and
`n + effect(t)`.

- `step_inc`, `step_add`, `run_inc`, `run_add`, `effect_inc`: `{==}`.
- `effect_add`: the goal is `n + 0n == n`, stuck on `n`. Rewrite with a
  `Policy` lemma `a == a + 0n` (induction on `a`), then `{==}`.
- `run_compose`: a `Policy.run_cat(+p, +q, +s)` by induction on `p`, at an
  arbitrary `s`. `Nil{}` is `{==}`. On `P.Inc{} <> t` (and `P.Add{n} <> t`)
  both sides unfold one instruction, and rewriting with the hypothesis at
  `1n + s` (or `n + s`) closes it with `{==}`.
- `effect_hom`: a `Policy.effect_cat(+p, +q)` by induction on `p`. In each cons
  case rewrite with the flipped hypothesis, then with
  `a + (b + c) == (a + b) + c` (induction on `a`) at `1n` or `n`, then `{==}`.
- `run_effect`: a `Policy.run_effect(prog, +s)` by induction on `prog`,
  generalised over `s`.
  - `Nil{}`: the goal is `s == s + 0n`; rewrite with `a == a + 0n`.
  - `P.Inc{} <> t`: rewrite the left side with the flipped hypothesis at
    `1n + s`, giving `(1n + s) + effect(t) == s + (1n + effect(t))`, then with a
    swap lemma `(a + b) + c == b + (a + c)` at `1n, s, effect(t)`, then `{==}`.
    The swap is an induction on `a` using
    `b + (1n + p) == 1n + (b + p)` (induction on `b`).
  - `P.Add{+n} <> t`: the same with `n` in place of `1n`.
  Each law is then its `Policy` lemma applied to the law's arguments.
