The reference matches on both arguments at once, with four cases: `0n 0n` and
`0n 1n+bp` give `0n`, `1n+ap 0n` gives `1n+ap`, and `1n+ap 1n+bp` gives
`sub(ap, bp)`.

- `sub_zero`: match on `x`; both cases (`0n` and `1n+p`) close by `{==}`.
- `sub_succ`: induction on `x`, but the match on two arguments leaves terms
  stuck on a variable, so the cases split further.
  - `x = 0n`: split `y` into `0n` and `1n+q`; both close by `{==}`.
  - `x = 1n+p`: split `p`.
    - `p = 0n`: split `y`. `0n` closes by `{==}`. For `1n+q`, `sub(0n, q)` is
      stuck on the variable, so split `q` into `0n` and `1n+qq`; both close by
      `{==}`.
    - `p = 1n+pp`: split `y`. `0n` closes by `{==}`. For `1n+q`, both sides
      step to terms about `pp` and `q`, and the hypothesis at `(1n+pp, q)`
      finishes it:

          %L.sub_succ(1n+pp, q) : {S.sub(1n+pp, 1n+q) == _ : Nat}
          {==}
