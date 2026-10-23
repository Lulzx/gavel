Implement `lcp_list`, then prove the six laws in `LAWS.bend`.

`lcp_list(xs, ys)` is the longest common prefix of `xs` and `ys` as a list: the
leading elements the two lists share, in order, stopping at the first position
where they differ or where either list ends. The result is always a prefix of
both inputs.

    lcp_list([1n, 2n, 3n], [1n, 2n, 4n]) == [1n, 2n]
    lcp_list([1n, 2n], [1n, 2n, 3n])     == [1n, 2n]
    lcp_list([5n], [6n])                 == Nil{}

The laws use two prelude names. `P.is_eq(a, b)` is `1n` when `a` and `b` are
equal and `0n` otherwise. `P.gate_list(c, xs)` is `xs` when `c` is not `0n` and
`Nil{}` when it is.

- `lcp_list_nil_left`: `lcp_list(Nil{}, ys)` is `Nil{}`.
- `lcp_list_nil_right`: `lcp_list(xs, Nil{})` is `Nil{}`.
- `lcp_list_cons_heads`: `lcp_list(h <> t, k <> u)` is `P.gate_list` applied to
  `P.is_eq(h, k)` and `h <> lcp_list(t, u)`: the head stays, in front of the
  tails' common prefix, when the heads are equal, and the result is empty
  otherwise.
- `lcp_list_self`: `lcp_list(xs, xs)` is `xs`.
- `lcp_list_stops_at_a_mismatch`: `lcp_list([1n, 2n, 3n], [1n, 2n, 4n])` is
  `[1n, 2n]`.
- `lcp_list_shorter_runs_out`: `lcp_list([1n, 2n], [1n, 2n, 3n])` is `[1n, 2n]`.
