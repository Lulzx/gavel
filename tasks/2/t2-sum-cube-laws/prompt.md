Implement `sum_cube`, then prove the two laws in `LAWS.bend`.

`sum_cube(xs)` is the sum, over every element of `xs`, of the cube of each element. The empty list
gives `0n`.

    sum_cube([2n, 0n, 3n]) == 35n
    sum_cube([4n]) == 64n
    sum_cube(Nil{}) == 0n

The laws use the prelude's `P.cube(n)`, which is the cube `n * n * n` of `n`, and `P.append(xs, ys)`,
the list `xs` followed by the list `ys`.

- `sum_cube_nil`: the empty list gives `0n`.
- `sum_cube_snoc`: putting one element `x` on the end of `xs` gives the result for
  `xs` plus `P.cube(x)`.
