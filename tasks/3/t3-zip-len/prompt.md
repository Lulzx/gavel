Implement `zip`, then prove the four laws in `LAWS.bend`.

`zip(xs, ys)` pairs the elements of `xs` and `ys` in order, the element of `xs`
first in each pair, and stops as soon as either list runs out. Each pair is the
prelude's `P.Mk{a, b}`.

    zip([1n, 2n, 3n], [4n, 5n]) == [P.Mk{1n, 4n}, P.Mk{2n, 5n}]
    zip([1n], Nil{}) == Nil{}

The input lists are `List<&2, Nat>` and the result is a `List<&2, P.P2>`.
`P.len(xs)` is the number of elements of a number list, `P.zlen` is the same
for a list of pairs, and `P.min(a, b)` is the smaller of `a` and `b`.

- `zip_nil_l`: an empty left list zips to `Nil{}`.
- `zip_nil_r`: an empty right list zips to `Nil{}`.
- `zip_cons`: zipping `hx <> tx` with `hy <> ty` gives `P.Mk{hx, hy}` followed
  by the zip of `tx` and `ty`.
- `zip_len`: the zipped list has as many elements as the shorter of the two
  lists.
