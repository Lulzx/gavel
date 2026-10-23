Implement `pairs`, then prove the four laws in `LAWS.bend`.

`pairs(xs)` is the list of the neighbouring pairs of `xs`, left to right: each
element is paired with the one after it, as `P.MkPair{a, b}`. A list of `n`
elements gives `n - 1` pairs, and a list of fewer than two elements gives
`Nil{}`. The pairs overlap, so a middle element appears in two of them.

    pairs([1n, 2n, 3n]) == P.MkPair{1n, 2n} <> P.MkPair{2n, 3n} <> Nil{}
    pairs([5n]) == Nil{}
    pairs([4n, 7n]) == P.MkPair{4n, 7n} <> Nil{}

The result is a `List<&2, P.Pair>`. The laws use `P.len(xs)`, the number of
elements of a `List<Nat>`, and `P.plen(ps)`, the number of pairs in a list of
`P.Pair`.

- `pairs_nil`: `pairs(Nil{})` is `Nil{}`.
- `pairs_single`: `pairs(x <> Nil{})` is `Nil{}`.
- `pairs_cons`: `pairs(a <> (b <> t))` is `P.MkPair{a, b}` followed by
  `pairs(b <> t)`.
- `pairs_len`: `pairs(x <> xs)` has `P.len(xs)` pairs.
