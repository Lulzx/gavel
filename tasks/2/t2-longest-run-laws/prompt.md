Implement `longest_run_len`, then prove the five laws in `LAWS.bend`.

`longest_run_len(xs)` is the length of the longest block of consecutive equal
elements of `xs`: the largest number of neighbours in a row that all hold the
same value. A list with no equal neighbours has runs of length one, so a
non-empty list gives at least `1n`. The empty list gives `0n`.

    longest_run_len([1n, 1n, 2n, 2n, 2n, 1n]) == 3n
    longest_run_len([1n, 2n, 3n])             == 1n
    longest_run_len([7n])                     == 1n
    longest_run_len(Nil{})                    == 0n

The laws use the prelude's `P.run_len(xs)`, the length of the block of equal
elements that starts at the first element of `xs`, and `0n` for the empty list.

- `longest_run_len_nil`: `longest_run_len(Nil{})` is `0n`.
- `longest_run_len_single`: `longest_run_len(x <> Nil{})` is `1n`.
- `longest_run_len_cons`: `longest_run_len(h <> t)` is `Nat.max` of
  `P.run_len(h <> t)` and `longest_run_len(t)`: the longest run starts at the
  head or lies inside the tail.
- `longest_run_len_one_pair`: `longest_run_len([1n, 1n])` is `2n`.
- `longest_run_len_no_pair`: `longest_run_len([1n, 2n, 3n])` is `1n`.
