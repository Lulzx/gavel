Implement `any`, then prove the three laws in `LAWS.bend`.

`any(xs)` takes a `List<&2, Bool>` and answers `True{}` when at least one
element is `True{}`, and `False{}` otherwise, so the empty list answers
`False{}`:

    any([False{}, True{}, False{}]) == True{}
    any([False{}, False{}]) == False{}
    any(Nil{}) == False{}

The laws use the prelude's `P.append(xs, ys)`, the elements of `xs` followed by
those of `ys`, and Base's `Bool.or`. The lists are `List<&2, Bool>`, not
`List<Nat>`.

- `any_nil`: the empty list answers `False{}`.
- `any_cons`: `any` of `h <> t` is `Bool.or` of the head `h` and `any` of the
  tail `t`.
- `any_append`: `any` of `xs` appended to `ys` is `Bool.or` of `any(xs)` and
  `any(ys)`.
