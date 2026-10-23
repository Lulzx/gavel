Implement `unzip`, then prove the five laws in `LAWS.bend`.

The prelude declares a pair `P.Mk{a, b}` of two `Nat` (type `P.Pair`) and a
record `P.MkZ{as, bs}` of two lists of `Nat` (type `P.ZP`).

`unzip(ps)` takes a list of pairs and returns a `P.MkZ` of two lists, each as
long as `ps`: the first holds the first component `a` of every pair and the
second holds the second component `b` of every pair, both in the order the pairs
come. The empty list gives two empty lists.

    unzip([P.Mk{1n, 2n}, P.Mk{3n, 4n}]) == P.MkZ{[1n, 3n], [2n, 4n]}
    unzip([P.Mk{7n, 8n}]) == P.MkZ{[7n], [8n]}
    unzip(Nil{}) == P.MkZ{Nil{}, Nil{}}

The laws use four prelude names. `P.zfst(z)` and `P.zsnd(z)` are the first and
second list of a `P.MkZ` record `z`. `P.plen(ps)` is the number of pairs in
`ps`, and `P.llen(xs)` the number of elements of a list of `Nat`.

- `unzip_nil`: the empty list gives `P.MkZ{Nil{}, Nil{}}`.
- `unzip_cons_fst`: the first list of `unzip(P.Mk{a, b} <> t)` is `a` followed
  by the first list of `unzip(t)`.
- `unzip_cons_snd`: the second list of `unzip(P.Mk{a, b} <> t)` is `b` followed
  by the second list of `unzip(t)`.
- `unzip_len_fst`: the first list of `unzip(ps)` has `P.plen(ps)` elements.
- `unzip_len_snd`: the second list of `unzip(ps)` has `P.plen(ps)` elements.
