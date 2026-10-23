The reference reads the front in the pattern rather than with a nested match:
`push` has cases `P.Q{Nil{}, b}` (answer `P.Q{x <> Nil{}, b}`) and
`P.Q{h <> t, b}` (answer `P.Q{h <> t, x <> b}`); `pop` has `P.Q{Nil{}, b}`,
`P.Q{h <> Nil{}, b}` (answer `P.Q{P.rev(b), Nil{}}`) and
`P.Q{h <> (h2 <> t2), b}`.

- `push_wf`: split `q` the same two ways; each is `{==}`.
- `pop_wf`: the same three-way split. The middle case leaves
  `P.imp(P.is_nil(P.rev(b)), True{}) == True{}`, closed by a `Policy` lemma
  `P.imp(x, True{}) == True{}` (match on `x`). The others are `{==}`.
- `pop_empty`, `push_empty`: `{==}`.
- `push_contents`: split `q`. On a cons front the goal is `h <>` of
  `app(t, rev(x <> b)) == app(app(t, rev(b)), x <> Nil{})`, lifted with
  `Equal.cong(..., l => h <> l, ...)` from a lemma by induction on `t`. Its
  base case is `rev(x <> xs) == app(rev(xs), x <> Nil{})`, which is the
  accumulator lemma `rev_go(xs, acc) == app(rev_go(xs, Nil{}), acc)` at
  `acc = x <> Nil{}`. The accumulator lemma is an induction on `xs`
  generalised over `acc`; its step uses the hypothesis at `h <> Nil{}` and at
  `h <> acc`, plus `app` associativity (induction on the first list). On an
  empty front, match the back: `Nil{}` is `{==}`; on `h <> t` the premise has
  reduced to `{False{} == True{}}`, and the goal follows by transport:
  `Equal.cong(Bool, List<&2, Nat>, c => Policy.list_ite(c, R, L), False{}, True{}, e)`
  with `list_ite` an if-then-else on `c`.
- `pop_contents`: match `t`. A cons is `{==}`. On `Nil{}` the goal is
  `app(rev(b), Nil{}) == rev(b)`, the lemma `app(xs, Nil{}) == xs` by induction.
