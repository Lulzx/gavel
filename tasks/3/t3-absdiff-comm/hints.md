The reference is `P.sub(a, b) + P.sub(b, a)`: one of the two truncated
subtractions is always `0n`, so their sum is the distance. Both parameters are
used twice, so both are declared `+`.

`P.sub` steps on both arguments at once, so with a variable on either side the
body does not reduce. Each law is a case analysis or an induction:

- `absdiff_zero_left` and `absdiff_zero_right`: match on the variable. Each case
  then computes, though `absdiff_zero_right`'s successor case leaves `a + 0n`,
  which needs a `Policy.` lemma `a == a + 0n` proved by induction on `a`.
- `absdiff_self`: after `P.sub(a, a)` the goal is about a variable pair that no
  zero case reaches. Prove `P.sub(a, a) == 0n` by induction as a helper.
- `absdiff_comm`: the two sides are the same two subtractions added in the other
  order, so this is commutativity of `+`. That needs `a + 0n == a` and
  `a + (1n + b) == 1n + (a + b)`, both inductions on `a`, and then
  `a + b == b + a` by induction on `a`.
- `absdiff_succ_succ`: `P.sub(1n + x, 1n + y)` steps to `P.sub(x, y)` on both
  sides, so it closes by `{==}`.
