Implement `len` and `map`, then prove the three laws in `LAWS.bend`.

`len(xs)` is the number of elements of `xs`.

    len([4n, 5n, 6n]) == 3n
    len(Nil{})        == 0n

`map(xs)` is the successor map: the list of the same length in which every
element `h` is replaced by `1n + h`.

    map([0n, 4n]) == [1n, 5n]
    map(Nil{})    == Nil{}

The prelude adds nothing: the laws use only `Base` terms and the two targets.

- `len_map_cons`: `len(map(h <> t))` is `1n + len(t)`.
- `map_cons`: `map(h <> t)` is `(1n + h) <> map(t)`.
- `len_single`: `len(h <> Nil{})` is `1n`.
