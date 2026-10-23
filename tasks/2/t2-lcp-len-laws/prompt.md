Implement `lcp_len`, then prove the five laws in `LAWS.bend`.

`lcp_len(xs, ys)` is the length of the longest common prefix of `xs` and `ys`:
the number of leading positions at which the two lists hold equal elements,
stopping at the first position where they differ or where either list ends. It
is a `Nat`.

    lcp_len([1n, 2n, 3n], [1n, 2n, 4n]) == 2n
    lcp_len([1n, 2n], [3n, 2n])         == 0n
    lcp_len([1n, 2n], [1n, 2n, 5n])     == 2n
    lcp_len(Nil{}, [1n])                == 0n

The laws use these prelude names. `P.is_eq(a, b)` is `1n` when `a` and `b` are
equal and `0n` otherwise. `P.gate(c, n)` is `n` when `c` is not `0n` and `0n`
when it is. `P.len(xs)` is the number of elements of `xs`.

- `lcp_len_nil_left`: `lcp_len(Nil{}, ys)` is `0n`.
- `lcp_len_nil_right`: `lcp_len(xs, Nil{})` is `0n`.
- `lcp_len_equal_singletons`: `lcp_len(1n <> Nil{}, 1n <> Nil{})` is `1n`.
- `lcp_len_cons`: `lcp_len(h <> t, k <> u)` is `P.gate` applied to
  `P.is_eq(h, k)` and `1n + lcp_len(t, u)`: one more than the tails' common
  prefix when the heads are equal, `0n` otherwise.
- `lcp_len_self`: `lcp_len(xs, xs)` is `P.len(xs)`.
