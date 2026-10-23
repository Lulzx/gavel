Implement `fact` and `facts`, then prove the five laws in `LAWS.bend`.

`fact(n)` is the factorial of `n`: the product of the numbers `1n` through `n`,
with `fact(0n)` equal to `1n`.

    fact(4n) == 24n
    fact(1n) == 1n
    fact(0n) == 1n

`facts(xs)` is the list of the factorials of the elements of `xs`, in the same
order. The empty list gives the empty list.

    facts([3n, 0n, 2n]) == [6n, 1n, 2n]

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`.

- `fact_zero`: `fact(0n)` is `1n`.
- `fact_succ`: `fact(1n + n)` is `Nat.mul(1n + n, fact(n))`.
- `facts_nil`: `facts(Nil{})` is the empty list.
- `facts_cons`: `facts(x <> xs)` is `fact(x)` in front of `facts(xs)`.
- `facts_len`: `facts(xs)` has as many elements as `xs`.
