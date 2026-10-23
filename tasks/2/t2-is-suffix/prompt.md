Implement `is_suffix`, then prove the five laws in `LAWS.bend`.

`is_suffix(xs, ys)` is `True{}` when `xs` is the tail end of `ys`: `ys` ends
with exactly the elements of `xs`, in order. The empty list is a suffix of every
list, and every list is a suffix of itself. A non-empty list is not a suffix of
the empty list.

    is_suffix([2n, 3n], [1n, 2n, 3n]) == True{}
    is_suffix([1n, 2n], [1n, 2n, 2n]) == False{}
    is_suffix(Nil{}, [1n])            == True{}
    is_suffix([1n], Nil{})            == False{}
    is_suffix(Nil{}, Nil{})           == True{}

The laws use these prelude names. `P.eq_list(xs, ys)` is `True{}` when the two
lists are equal element for element. `P.append(xs, ys)` is the list `xs`
followed by the list `ys`. The prelude also has `P.is_nil` (is a list empty),
which the laws do not mention.

- `is_suffix_nil`: `is_suffix(Nil{}, ys)` is `True{}`.
- `is_suffix_nil_right`: `is_suffix(h <> t, Nil{})` is `False{}`.
- `is_suffix_cons`: `is_suffix(xs, k <> u)` is `Bool.or` of
  `P.eq_list(xs, k <> u)` and `is_suffix(xs, u)`: `xs` is the whole list, or it
  is a suffix of the tail.
- `is_suffix_self`: `is_suffix(xs, xs)` is `True{}`.
- `is_suffix_append`: `is_suffix(xs, P.append(ys, xs))` is `True{}`.
