Implement `digit_sum`, then prove the four laws in `LAWS.bend`.

`digit_sum(w, n)` is the sum of the base-10 digits of `n`, looking at no more
than `w` digits, taken from the least significant end. With a width of `0n` no
digit is looked at and the answer is `0n`. Each extra unit of width adds one
more digit: the low digit of `n` (`Nat.mod(n, 10n)`) plus the digit sum of what
remains after dividing by ten (`Nat.div(n, 10n)`), with one less unit of width.
The width is the first parameter and the number the second.

    digit_sum(3n, 407n) == 11n
    digit_sum(2n, 999n) == 18n
    digit_sum(0n, 55n)  == 0n

The prelude adds nothing: the laws use only `Base`'s `Nat.mod` and `Nat.div`.
Keep the numbers small, because `Nat.div` and `Nat.mod` take a step per unit of
the number.

- `digit_sum_no_fuel`: at width `0n` the answer is `0n`, whatever the number.
- `digit_sum_step`: at width `1n + w`, the answer is `Nat.mod(n, 10n)` plus
  `digit_sum(w, Nat.div(n, 10n))`.
- `digit_sum_123`: `digit_sum(3n, 123n)` is `6n`.
- `digit_sum_thousand`: `digit_sum(4n, 1000n)` is `1n`.
