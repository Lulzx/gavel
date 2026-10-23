Implement `init`, then prove the three laws in `LAWS.bend`.

`init(xs)` is `xs` without its last element. The empty list and a one-element
list both give the empty list.

    init([1n, 2n, 3n]) == [1n, 2n]
    init([4n])         == Nil{}
    init(Nil{})        == Nil{}

The laws use the prelude's `P.append(xs, ys)`, the list `xs` followed by the
list `ys`.

- `init_nil`: `init(Nil{})` is `Nil{}`.
- `init_single`: `init(h <> Nil{})` is `Nil{}`.
- `init_snoc`: `init(P.append(xs, x <> Nil{}))` is `xs`.
