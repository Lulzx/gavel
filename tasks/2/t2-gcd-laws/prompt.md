Implement `gcd` on `Nat`, then prove the four laws about it.

`gcd` must return the greatest common divisor of `a` and `b` by Euclid's
algorithm: while the divisor is not zero, replace `a` by `b` and `b` by the
remainder of `a` by `b`. That loop does not descend on any subterm of its
arguments -- the remainder is a computed value, and a self-call written as
`gcd(a, Nat.mod(a, b))` is rejected, because the checker only accepts a
recursive call whose arguments are unchanged until one of them *shrinks*, and
`Nat.mod(a, b)` is not smaller than `a` by construction. The step budget is
therefore handed in as the first argument and is the subterm the recursion
consumes.

`gcd(fuel, a, b)` is that loop with `fuel` steps left. `0n` of budget answers
the divisor found so far -- which is just `a`, since nothing has been divided
out yet. A divisor of `0n` answers `a`, because the loop has finished. For
`1n + f` of budget and a divisor `1n + b`, one step of the algorithm has
happened and the answer is what the loop answers on the budget below it, with
the divisor and the remainder swapped in.

The divisor is read twice in that step, once as the new `a` and once inside the
remainder, so it is declared reusable: `+b`. Both matches are on `Nat`, so the
budget is written `case 1n++k:` and the divisor `case 1n++j:`.

`gcd(30n, 12n, 18n)` is `6n`. Thirty is enough budget for twelve and eighteen:
the pair walks `12, 18`, then `18, 12`, then `12, 6`, then `6, 0`, and the
answer is the six that was left when the divisor ran out.

The law `gcd_no_fuel` is the pin on the empty budget: it is the first arm of the
match, and no other law here reaches it. `gcd_zero_divisor` is the pin on the
empty divisor, and it is an induction rather than a computation, because `gcd`
cannot look at the budget until it is a numeral -- one of the two laws that
still has something to prove.

`gcd_step` is where the content is. It says what one step of the loop is, and
it is definitional: `1n + f` and `1n + b` are both successors, so both matches
take their step arm and the two sides are the same self-call. A body that
recursed on `a` instead of on `b`, or that took the remainder the other way
round, agrees with both pins and fails this law.

`gcd_twelve_eighteen` is the closed one: both sides are numerals, so the two
sides must compute to the same number. The laws above fix the recurrence and
the two answers it stops at; this one fixes what the recurrence is a recurrence
*of*.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.gcd_no_fuel(a, b)`, `def L.gcd_zero_divisor(f, a)`, `def L.gcd_step(f, a,
b)` and `def L.gcd_twelve_eighteen()`.
