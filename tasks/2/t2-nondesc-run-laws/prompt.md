Implement `nondesc_run`, then prove the five laws in `LAWS.bend`.

`nondesc_run(xs)` is the length of the longest prefix of `xs` whose elements
never decrease from one to the next (equal neighbours are fine). The empty list
gives `0n`, and a nonempty list gives at least `1n`. The lists are
`List<&2, Nat>`.

    nondesc_run([1n, 2n, 2n, 1n, 5n]) == 3n
    nondesc_run([3n, 1n]) == 1n
    nondesc_run([4n]) == 1n
    nondesc_run(Nil{}) == 0n

The laws use `P.le(a, b)`, the `Bool` that says `a` is at most `b`, and
`P.len(xs)`, the number of elements of `xs`.

- `nondesc_run_nil`: `nondesc_run(Nil{})` is `0n`.
- `nondesc_run_single`: `nondesc_run(x <> Nil{})` is `1n`.
- `nondesc_run_up`: when `P.le(x, y) == True{}`, `nondesc_run(x <> y <> t)` is
  `1n + nondesc_run(y <> t)`.
- `nondesc_run_down`: when `P.le(x, y) == False{}`, `nondesc_run(x <> y <> t)` is
  `1n`.
- `nondesc_run_le_len`: the run of `x <> t` is at most its length:
  `P.le(nondesc_run(x <> t), P.len(x <> t)) == True{}`.
