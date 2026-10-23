Implement `run_max`, then prove the three laws in `LAWS.bend`.

`run_max(xs, m)` is the list of running maxima of `xs` starting from `m`: it has
one entry per element of `xs`, and the entry for each element is the largest of
`m` and every element up to and including that one. The empty list gives `Nil{}`.

    run_max([3n, 1n, 5n], 2n) == [3n, 3n, 5n]
    run_max([1n], 4n) == [4n]
    run_max(Nil{}, 2n) == Nil{}

The laws use `P.max(a, b)`, the larger of two numbers; `P.append(xs, ys)`, the
concatenation of two lists; and `P.after_max(xs, m)`, the largest of `m` and
every element of `xs`.

- `run_max_nil`: `run_max(Nil{}, m)` is `Nil{}`, whatever `m` is.
- `run_max_single`: `run_max(h <> Nil{}, m)` is `P.max(m, h) <> Nil{}`.
- `run_max_append`: `run_max(P.append(xs, ys), m)` is
  `run_max(xs, m)` followed by `run_max(ys, P.after_max(xs, m))`: the second
  half continues from where the first left off.
