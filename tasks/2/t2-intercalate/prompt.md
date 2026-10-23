Implement `intercalate`, then prove the four laws in `LAWS.bend`.

`intercalate(sep, xss)` joins the lists in `xss` into one list, putting `sep`
between each pair of neighbours. The separator appears only between lists, never
before the first or after the last. With no lists the answer is the empty list,
and with exactly one list it is that list.

    intercalate([0n], [[1n], [2n, 3n], [4n]]) == [1n, 0n, 2n, 3n, 0n, 4n]
    intercalate([0n], [[1n]])                 == [1n]
    intercalate([0n], Nil{})                  == Nil{}
    intercalate(Nil{}, [[1n], [2n]])          == [1n, 2n]

The laws use two prelude names. `P.append(xs, ys)` is the list `xs` followed by
the list `ys`. `P.concat(xss)` is all the lists in `xss` joined end to end with
nothing between.

- `intercalate_nil`: `intercalate(sep, Nil{})` is `Nil{}`.
- `intercalate_single`: `intercalate(sep, xs <> Nil{})` is `xs`.
- `intercalate_cons`: for two or more lists `a <> (b <> t)`, the answer is `a`,
  then `sep`, then `intercalate(sep, b <> t)`, joined with `P.append`.
- `intercalate_nil_sep`: with an empty separator, `intercalate(Nil{}, xss)` is
  `P.concat(xss)`.
