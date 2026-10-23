Implement `len` and `map`, then prove the four laws in `LAWS.bend`.

`len(xs)` is the number of elements of `xs`. `map(xs)` is the list of the
results of applying `P.inc` to each element of `xs`, in the same order. `P.inc`
adds one to a number.

    len([4n, 5n, 6n]) == 3n
    len(Nil{})        == 0n
    map([1n, 2n])     == [2n, 3n]
    map(Nil{})        == Nil{}

- `len_cons`: `len(x <> xs)` is `1n + len(xs)`.
- `len_single`: `len(x <> Nil{})` is `1n`.
- `len_map`: `map(xs)` has the same length as `xs`.
- `map_cons`: `map(x <> xs)` is `P.inc(x) <> map(xs)`.
