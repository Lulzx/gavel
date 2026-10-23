Implement `lex_le`, then prove the five laws in `LAWS.bend`.

`lex_le(xs, ys)` is `True{}` when `xs` comes at or before `ys` in lexicographic
(dictionary) order: compare element by element, the first position where they
differ decides, and if one list is a prefix of the other the shorter comes
first. The empty list is at or before every list, and a non-empty list is never
at or before the empty list. Equal lists are at or before each other.

    lex_le([1n, 2n], [1n, 3n]) == True{}
    lex_le([2n], [1n, 3n])     == False{}
    lex_le([1n], [1n, 3n])     == True{}
    lex_le([1n, 3n], [1n])     == False{}
    lex_le([4n], [4n])         == True{}

The laws use these prelude names. `P.eq(a, b)` is `True{}` when `a` equals `b`.
`P.lt(a, b)` is `True{}` when `a` is strictly below `b`. `P.append(xs, ys)` is
the list `xs` followed by the list `ys`.

- `lex_le_nil_left`: `lex_le(Nil{}, ys)` is `True{}`.
- `lex_le_nil_right`: `lex_le(h <> t, Nil{})` is `False{}`.
- `lex_le_cons`: `lex_le(h <> t, k <> u)` is `Bool.or` of `P.lt(h, k)` and
  `Bool.and(P.eq(h, k), lex_le(t, u))`: the first head is strictly below the
  second, or the heads are equal and the tails are in order.
- `lex_le_self`: `lex_le(xs, xs)` is `True{}`.
- `lex_le_append`: `lex_le(xs, P.append(xs, ys))` is `True{}`.
