# The square root of a number, rounded down

`nat_sqrt(n)` is the largest `k` whose square is at most `n`:

    nat_sqrt(0n)  ==  0n
    nat_sqrt(1n)  ==  1n
    nat_sqrt(4n)  ==  2n
    nat_sqrt(8n)  ==  2n
    nat_sqrt(9n)  ==  3n
    nat_sqrt(15n) ==  3n

The answer is the count of the squares `1n, 4n, 9n, ...` that still fit under
`n`. Nothing below `1n` has a square under it, so the answer there is `0n`.

The bank has neighbours of this function and none of them is this one. The bank's
`sq(n)` is `Nat.mul(n, n)` -- it *makes* a square, where this *recovers* the
number a square came from -- and `sq_sum` and its neighbours sum the squares of a
*list*, which is neither of those directions. The bank's `is_prime`, `lcm` and
`nat_log2` are number-theoretic neighbours of a different answer: none of them
reads a square. Nothing in the bank recovers a square root.

One function to implement. The match is on `n`: `0n` answers `0n`, and for a
successor the answer is the answer for `n - 1` plus the decision `P.le_ind(a, b)`
makes -- `1n` when `a` is at most `b` and `0n` otherwise. The decision is taken
on the square of the *next* number against this `n`: adding one to `n` raises the
square root by at most one, so the answer either stays at the answer for `n - 1`
or is one more than it. `Nat.mul` builds the square, `Nat.add` adds the decision,
and there is no other arithmetic in the task.

The successor argument is the argument the recursion shrinks, and the answer for
`n - 1` is read more than once on that path -- it is the base of the sum and it is
squared to test the next square -- so bind it once and reuse the name rather than
calling `nat_sqrt` once per read. A second call would double the work at every
step and the reference is measured against a latency budget.

`nat_sqrt_zero` fixes the empty input, and it is a pin: the step law below is
stated at `1n + n`, so it never reaches `0n`, and a body that started its walk at
one, or that answered the number of steps taken rather than the count of them,
would be caught only here.

`nat_sqrt_succ` is the step, and it is definitional: it says which square is
tested and against what. A body that tested the square of the answer instead of
the square of the next number -- which never grows -- or that tested it against a
bound other than this `n`, leaves the two sides unconvertible.

`nat_sqrt_mono` is the law with content: the answer never falls as `n` grows. It
is the only law whose two sides do not both compute, because `n` is a variable and
the match in the body does not reduce -- it is proved from the answer's own step,
and it reads the answer as an order rather than as a number.

`nat_sqrt_four`, `nat_sqrt_eight` and `nat_sqrt_nine` are closed numbers read on
their own: `4n` is `2n * 2n`, so the last decision there has nothing to spare;
`9n` is `3n * 3n`, the same again one square further out; and `8n` is the number
just below `9n`, where the next square does *not* fit and the answer stays at `2n`.
A body that stopped one short on an exact square, or that drifted over the run of
numbers between two squares -- raising the answer one step early -- satisfies the
monotonicity law and is separated by the law for the gap it drifted into.

Together the laws determine the body: `0n` is `nat_sqrt_zero`, and a successor is
`nat_sqrt_succ`, which hands a strictly smaller number to the same answer.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.nat_sqrt_zero()`, `def L.nat_sqrt_succ(n)`, `def L.nat_sqrt_mono(n)`,
`def L.nat_sqrt_four()`, `def L.nat_sqrt_eight()` and `def L.nat_sqrt_nine()`.
