The reference matches on `xss`: `Nil{}` answers `Nil{}`, and `a <> rest`
answers `P.append(a, concat(rest))`.

`concat_nil` closes by `{==}`.

`concat_append` is an induction on `xss` and needs two `Policy.` lemmas, both
inductions on the first list. Mark `ys` and `zs` as erased (`-ys`) in the
second so calling it does not consume the caller's lists.

- `Policy.append_nil(xs)`: `P.append(xs, Nil{}) == xs`.
- `Policy.append_assoc(xs, ys, zs)`:
  `P.append(xs, P.append(ys, zs)) == P.append(P.append(xs, ys), zs)`.

In the `Nil{}` case the goal reduces to `P.append(ys, Nil{}) == ys`; rewrite
with `Policy.append_nil(ys)`, then `{==}`. In the `a <> rest` case the
hypothesis `L.concat_append(rest, ys)` has `concat(append_ll(rest, ys))` on its
left, which is the form the goal has, so flip it with `Equal.sym` before
rewriting. That leaves `P.append(a, P.append(S.concat(rest), ys))` on the left
against `P.append(P.append(a, S.concat(rest)), ys)`; a second rewrite with
`Policy.append_assoc(a, S.concat(rest), ys)` aligns them, then `{==}`.
