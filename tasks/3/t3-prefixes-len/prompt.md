Implement `prefixes`, then prove the three laws in `LAWS.bend`.

`prefixes(xs)` is every prefix of `xs`, shortest first: it starts with the
empty list and ends with `xs` itself, so it holds one more prefix than `xs` has
elements. The result is the prelude's `P.Prefixes`, a list of lists with
constructors `P.PNil{}` and `P.PCons{p, rest}`.

    prefixes([1n, 2n]) == P.PCons{Nil{}, P.PCons{[1n], P.PCons{[1n, 2n], P.PNil{}}}}
    prefixes(Nil{}) == P.PCons{Nil{}, P.PNil{}}

The list type is the prelude's `List<&2, Nat>`. `P.llen(ps)` is the number of
lists in `ps`, `P.len(xs)` is the number of elements of `xs`, and
`P.cons_all(x, ps)` is `ps` with `x` put on the front of every list, in the
same order.

- `prefixes_nil`: the empty list has exactly one prefix, the empty list.
- `prefixes_cons`: the prefixes of `h <> t` are the empty list followed by the
  prefixes of `t`, each with `h` put on the front.
- `prefixes_len`: `xs` has one more prefix than it has elements.
