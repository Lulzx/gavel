Implement `even`, then prove the two laws in `LAWS.bend`.

`even(n)` is `True{}` when `n` is even and `False{}` when it is odd. `0n` is
even.

    even(0n) == True{}
    even(3n) == False{}
    even(4n) == True{}

- `even_flip`: `even(x)` is `Bool.not(even(1n+x))`, so adding one flips the
  answer.
- `even_zero`: `even(0n)` is `True{}`. The law takes an `x` that it does not
  use.
