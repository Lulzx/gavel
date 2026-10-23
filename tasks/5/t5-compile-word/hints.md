The reference `compile` maps `P.Empty{}` to `Nil{}`, `P.Sym{n}` to
`P.Emit{n} <> Nil{}` and `P.Cat{a, b}` to
`P.splice(compile(a), compile(b))`. `exec` walks the program with the word as
an accumulator: `Nil{}` answers `w`, and `P.Emit{n} <> t` answers
`exec(t, P.glue(w, n <> Nil{}))`.

- `exec_nil`, `exec_emit`: `{==}`.
- `exec_splice`: induction on `p`, at an arbitrary word `w`. `Nil{}` is `{==}`.
  On `h <> t`, match `h` as `P.Emit{n}`; both sides step once, and the
  hypothesis `L.exec_splice(t, q, P.glue(w, n <> Nil{}))`, flipped with
  `Equal.sym`, rewrites the left side, then `{==}`. The hypothesis has to be
  taken at the new word, which is why `w` stays a parameter of the induction.
- `exec_compile`: a `Policy.exec_compile(e, +w)` with the law's statement,
  by induction on `e`, which may cite `L.exec_splice` since it is declared after
  that law's proof. The law just calls it.
  - `P.Empty{}`: the goal is `w == P.glue(w, Nil{})`; rewrite with
    `P.glue(xs, Nil{}) == xs` (induction on `xs`), then `{==}`.
  - `P.Sym{n}`: `{==}`.
  - `P.Cat{+a, +b}`: four rewrites. First `exec_splice` (flipped) turns the
    left side into `exec(compile(b), exec(compile(a), w))`. Then the
    hypothesis at `a` and `w` (flipped) replaces the inner run by
    `P.glue(w, P.eval(a))`. Then the hypothesis at `b` and that word (flipped)
    gives `P.glue(P.glue(w, P.eval(a)), P.eval(b))`. Last,
    `P.glue(P.glue(xs, ys), zs) == P.glue(xs, P.glue(ys, zs))` (induction on
    `xs`) reassociates the right side, and `{==}` closes it.
