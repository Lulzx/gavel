Implement `absdiff`, then prove the five laws in `LAWS.bend`.

`absdiff(a, b)` is the distance between `a` and `b`: the larger minus the
smaller, so it is never negative and does not depend on the order.

    absdiff(2n, 5n) == 3n
    absdiff(5n, 2n) == 3n
    absdiff(4n, 4n) == 0n

The prelude's `P.sub(a, b)` is truncated subtraction: `a - b` when `a` is at
least `b`, and `0n` otherwise. Only `absdiff` is under test.

- `absdiff_zero_left`: the distance from `0n` to `b` is `b`.
- `absdiff_zero_right`: the distance from `a` to `0n` is `a`.
- `absdiff_self`: a number's distance from itself is `0n`.
- `absdiff_comm`: the distance is the same either way round.
- `absdiff_succ_succ`: adding one to both numbers leaves the distance unchanged.
