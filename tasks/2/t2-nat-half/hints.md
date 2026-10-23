The reference matches `n` two successors deep: `0n` answers `0n`, `1n+0n`
answers `0n`, and `1n+1n+p` answers `1n + half(p)`.

- `half_zero`, `half_one` and `half_step` close by `{==}`.
- `half_double` and `half_double_succ` are inductions on `n`. `0n` is `{==}`.
  In `1n+p`, `Nat.double` unfolds to `1n + (1n + Nat.double(p))`, so the goal is
  `1n + half(...) == 1n + p`; the hypothesis states `half(...) == p`, so flip it
  with `Equal.sym` before rewriting:

      %Equal.sym(Nat, S.half(Nat.double(p)), p, L.half_double(p)) : {1n + _ == 1n + p : Nat}
      {==}

  `half_double_succ` is the same with `1n + Nat.double(p)` as the argument and
  `L.half_double_succ(p)` as the hypothesis.
