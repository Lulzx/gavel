Implement `cube_all`, then prove the two laws in `LAWS.bend`.

`cube_all(xs)` replaces every element of `xs` by its cube (`n * n * n`),
keeping the order. The empty list stays empty.

    cube_all([2n, 3n]) == [8n, 27n]
    cube_all([0n, 1n]) == [0n, 1n]
    cube_all(Nil{}) == Nil{}

The prelude's `P.cube(n)` is the cube of `n`. `P.append(xs, ys)` is `xs`
followed by `ys`.

- `cube_all_single`: a one-element list `h <> Nil{}` becomes `P.cube(h) <> Nil{}`.
- `cube_all_append`: cubing an append is the append of the cubed lists,
  `cube_all(P.append(xs, ys)) == P.append(cube_all(xs), cube_all(ys))`.
