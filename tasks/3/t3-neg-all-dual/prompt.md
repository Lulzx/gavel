Implement `neg_all`, then prove the five laws in `LAWS.bend`.

`neg_all(xs)` is `xs` with every element negated, in the same order.

    neg_all([True{}, False{}, False{}]) == [False{}, True{}, True{}]
    neg_all(Nil{}) == Nil{}

The list type is the prelude's `List<&2, Bool>`; a statement written over
`List<Bool>` will not unify with the laws. `P.all_bool(xs)` is `True{}` when
every element of `xs` is `True{}` (so `True{}` on the empty list), and
`P.any_bool(xs)` is `True{}` when at least one element is `True{}` (so
`False{}` on the empty list).

- `neg_all_nil`: negating every element of the empty list gives the empty list.
- `neg_all_cons`: negating every element of `h <> t` gives `Bool.not(h)` in
  front of the negation of every element of `t`.
- `neg_all_involutive`: negating every element twice gives back `xs`.
- `neg_all_all`: every element of the negated list is `True{}` exactly when no
  element of `xs` is `True{}`.
- `neg_all_any`: some element of the negated list is `True{}` exactly when not
  every element of `xs` is `True{}`.
