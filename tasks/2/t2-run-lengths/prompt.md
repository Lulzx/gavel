Implement `run_lengths` and `run_lengths_go`, then prove the nine laws in
`LAWS.bend`.

`run_lengths(xs)` is the list of the lengths of the maximal runs of equal
neighbouring elements of `xs`, in order: one entry per run, not per element. The
empty list has no runs, and a one-element list is one run of one. The lists are
`List<&2, Nat>`.

    run_lengths([1n, 1n, 2n]) == [2n, 1n]
    run_lengths([1n, 1n, 2n, 2n, 2n, 1n]) == [2n, 3n, 1n]
    run_lengths([3n]) == [1n]
    run_lengths(Nil{}) == Nil{}

`run_lengths_go(t, cont, cur, h)` reads the rest of a list.
`h` is the element read most recently and `t` is what remains after it. `cur` is
the length of the run just before `h`, and `cont` says whether `h` continues
that run. When `cont` is `True{}`, `h` belongs to that run, which is now
`1n + cur` long. When `cont` is `False{}`, the run of `cur` is finished and
`h` starts a new run of one. It answers the lengths of the finished and
unfinished runs from there to the end, in order.

    run_lengths_go(Nil{}, True{}, 3n, 5n) == [4n]
    run_lengths_go([2n], False{}, 3n, 1n) == [3n, 1n, 1n]

The laws use `P.same(a, b)`, the `Bool` that says `a` equals `b`.

- `run_lengths_nil`: `run_lengths(Nil{})` is `Nil{}`.
- `run_lengths_single`: `run_lengths(x <> Nil{})` is `1n <> Nil{}`.
- `run_lengths_step`: `run_lengths(h <> (h2 <> t2))` is
  `run_lengths_go(t2, P.same(h, h2), 1n, h2)`.
- `run_lengths_go_last_in_run`: `run_lengths_go(Nil{}, True{}, cur, h)` is
  `(1n + cur) <> Nil{}`.
- `run_lengths_go_last_alone`: `run_lengths_go(Nil{}, False{}, cur, h)` is
  `cur <> (1n <> Nil{})`.
- `run_lengths_go_grow`: `run_lengths_go(h2 <> t2, True{}, cur, h)` is
  `run_lengths_go(t2, P.same(h, h2), 1n + cur, h2)`.
- `run_lengths_go_fresh`: `run_lengths_go(h2 <> t2, False{}, cur, h)` is `cur`
  followed by `run_lengths_go(t2, P.same(h, h2), 1n, h2)`.
- `run_lengths_go_same`: `run_lengths_go(a <> t, True{}, cur, a)` is
  `run_lengths_go(t, True{}, 1n + cur, a)`: when the next element equals the one
  in hand, the comparison is `True{}`.
- `run_lengths_three`: `run_lengths([1n, 1n, 2n])` is `[2n, 1n]`.
