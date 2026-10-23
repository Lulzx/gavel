Implement `run_starts` and `run_starts_go`, then prove the six laws in
`LAWS.bend`.

`run_starts(xs)` is the list of positions, counting from `0n`, at which a new
run of equal neighbouring elements begins, in increasing order. The first
element of a nonempty list always begins a run; a later element begins one
exactly when it differs from the element before it. The empty list gives `Nil{}`.
The lists are `List<&2, Nat>`.

`run_starts_go(rest, prev, i)` does the same for the elements of `rest`, where
`prev` is the element just before `rest` and `i` is the position of `rest`'s
first element. The positions it reports are counted from `i`, and it gives
`Nil{}` on the empty list.

    run_starts([1n, 1n, 2n, 2n, 3n, 1n]) == [0n, 2n, 4n, 5n]
    run_starts([7n]) == [0n]
    run_starts(Nil{}) == Nil{}
    run_starts_go([1n, 2n, 2n], 1n, 4n) == [5n]

The laws use `P.same(a, b)`, the `Bool` that says `a` equals `b`, and
`P.put_start(i, r, k)`, which is `r` when `k` is `True{}` and `i <> r` when it is
`False{}`.

- `run_starts_nil`: `run_starts(Nil{})` is `Nil{}`.
- `run_starts_single`: `run_starts(x <> Nil{})` is `0n <> Nil{}`.
- `run_starts_go_nil`: `run_starts_go(Nil{}, prev, i)` is `Nil{}`.
- `run_starts_go_cons`: `run_starts_go(h <> t, prev, i)` is `P.put_start` at position `i`,
  with the result of `run_starts_go(t, h, Nat.add(i, 1n))` and the test
  `P.same(h, prev)`.
- `run_starts_go_same`: when the head equals the element before it,
  `run_starts_go(a <> t, a, i)` is `run_starts_go(t, a, Nat.add(i, 1n))`.
- `run_starts_three`: `run_starts([1n, 1n, 2n])` is `[0n, 2n]`.
