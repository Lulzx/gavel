# Is `xs` a suffix of `ys`?

Implement

```
def is_suffix(+xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
```

so that it answers `True{}` exactly when `xs` appears as the tail end of `ys`:
some prefix of `ys` can be removed and what is left is `xs`. `Nil{}` is a
suffix of every list, including itself; a non-empty list is not a suffix of
`Nil{}`.

The lists are `List<&2, Nat>` -- the element is many, so a list binder may be
marked `+` and read twice. That is not decoration: the walk below has to offer
`xs` both to the comparison and to the recursive call, and read the tail of
`ys` both as part of the list it compares against and as the list it steps
into, so those binders have to be `+`.

The prelude gives you four helpers, and the laws below are all stated in terms
of them:

- `P.is_nil(xs)` -- whether `xs` is empty.
- `P.eq(a, b)` -- whether two numbers are equal.
- `P.eq_list(xs, ys)` -- whether two lists are equal, element for element.
- `P.append(xs, ys)` -- `xs` followed by `ys`.

`Native.or` is in `Base`.

## The laws

Your body has to satisfy all five of these, for every list and number:

- **`is_suffix_nil`** -- `is_suffix(Nil{}, ys)` is `True{}` for every `ys`.
- **`is_suffix_nil_right`** -- `is_suffix(h <> t, Nil{})` is `False{}`. This is
  the case a recursion on `ys` reaches with `ys` already stopped, so it is the
  only law that pins the empty answer; a body that answers `True{}` there makes
  `Nil{}`-versus-non-empty indistinguishable.
- **`is_suffix_cons`** -- `is_suffix(xs, k <> u)` is
  `Bool.or(P.eq_list(xs, k <> u), is_suffix(xs, u))`. This pins the decision to
  test the whole of `k <> u` first and to walk one cell down otherwise.
- **`is_suffix_self`** -- `is_suffix(xs, xs)` is `True{}`.
- **`is_suffix_append`** -- `is_suffix(xs, P.append(ys, xs))` is `True{}`. With
  `is_suffix_self`, this is the positive direction: a list is found when the
  walk down `ys` arrives at it.

## Notes

- Recurse on `ys`. The recursion has to reach the end of `ys` because any
  prefix of `ys` may be the part that is discarded; a body that recurses on
  `xs` instead answers `True{}` for `is_suffix([1n, 2n], [1n, 2n, 2n])`, which
  is wrong.
- `P.eq_list` and `P.append` match on their first argument. A goal that needs
  their value at a list you cannot name does not reduce on its own.
