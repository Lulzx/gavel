The reference `exec` matches the program, one case per instruction, recursing
on the tail with `0n`, `1n + s` or `s + s` (and `s` at `Nil{}`). `opt` matches
the program too: `P.Zero{} <> t` gives `P.Zero{} <> opt(t, True{})`,
`P.Inc{} <> t` gives `P.Inc{} <> opt(t, False{})`, and `P.Twice{} <> t` matches
`z`: `opt(t, True{})` under `True{}`, `P.Twice{} <> opt(t, False{})` under
`False{}`.

- The four `exec_*` laws, `opt_zero` and `opt_twice_zero`: `{==}`.
- `clean_opt`: a `Policy` lemma with the law's statement and `+z`, by induction
  on `p` following `opt`'s cases (a match on `z` under `P.Twice{}`). Every case
  is the hypothesis at the tail with the flag that branch passes on.
- `opt_sound` and `opt_sound_zero` need each other: a `P.Zero{}` moves the
  unknown-state goal to the zero-state one, and the two cannot be mutually
  recursive defs. State one lemma over the flag. Define
  `Policy.state(z, +s)` as `0n` under `True{}` and `s` under `False{}`, and
  prove
  `Policy.ok(p, +z, +s) : {S.exec(S.opt(p, z), Policy.state(z, s)) == S.exec(p, Policy.state(z, s))}`
  by induction on `p`:
  - `Nil{}`: `{==}`.
  - `P.Zero{} <> t`: `Policy.ok(t, True{}, s)`.
  - `P.Inc{} <> t`: `Policy.ok(t, False{}, 1n + Policy.state(z, s))`.
  - `P.Twice{} <> t`: match `z`; under `True{}` it is `Policy.ok(t, True{}, s)`
    (`0n + 0n` reduces to `0n`), under `False{}` it is
    `Policy.ok(t, False{}, s + s)`.
  Each recursive call takes the flag and state that branch established, not
  the ones it was handed. Then `opt_sound` is `Policy.ok(p, False{}, s)` and
  `opt_sound_zero` is `Policy.ok(p, True{}, 0n)`.
