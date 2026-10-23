Implement `is_pal`, then prove the four laws in `LAWS.bend`.

`is_pal(xs)` takes a `List<&2, Nat>` and is `True{}` exactly when `xs` reads
the same backwards as forwards, that is, when `P.eq_list` compares it equal to
its own reverse:

    is_pal([1n, 2n, 1n]) == True{}
    is_pal([1n, 2n]) == False{}
    is_pal(Nil{}) == True{}

The prelude's `P.rev(xs)` is `xs` reversed (built from `P.snoc(xs, y)`, which
adds `y` on the right), `P.eq_nat(a, b)` is `True{}` when two numbers are
equal, and `P.eq_list(xs, ys)` is `True{}` when two lists have the same
elements in the same order.

- `is_pal_nil`: the empty list is a palindrome.
- `is_pal_single`: every one-element list `h <> Nil{}` is a palindrome.
- `is_pal_two_distinct`: the list `[0n, 1n]` is not a palindrome.
- `is_pal_rev`: `P.rev(xs)` is a palindrome exactly when `xs` is.
