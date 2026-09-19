Implement `collatz_len` on `Nat`, then prove the five laws about it.

`collatz_len(fuel, n)` is the number of steps that take `n` to `1n` under the
Collatz map: halve an even number, send an odd one to `3n*n + 1n`, and count a
step each time. So `collatz_len(30n, 6n)` is `8n` -- `6n`, `3n`, `10n`, `5n`,
`16n`, `8n`, `4n`, `2n`, `1n` -- and `collatz_len(200n, 27n)` is `111n`.

The loop does not descend on any subterm of the number: the next value is a
computed one, and a self-call written as `collatz_len(nat_next(n))` is rejected,
because the checker only accepts a recursive call whose arguments are unchanged
until one of them *shrinks*, and a value the map produced is not smaller than
the number it came from by construction. So the step budget is handed in as the
first argument and is the subterm the recursion consumes, exactly as
`t2-gcd-laws` hands `gcd` its fuel.

`collatz_len(fuel, n)` is that walk with `fuel` steps left. `0n` of budget
answers `0n`, because no steps were taken. A number of `0n` answers `0n`, and so
does `1n`: those are the two values the walk stops at. Everything else takes one
step, which is `1n +` the walk on the budget below at the next value, and the
next value is `Bool.pick` over whether the number is even -- `P.half(n)` when it
is, `3n*n + 1n` when it is not.

The number is read in four places in that step, so the parameter is declared
reusable: `+n`. The parity test itself is not written as a `match`, and cannot
be: a `match` cannot scrutinise a computed value, so a branch on the parity
would leave the law stuck at a variable. `P.is_even_b` and `P.half` are supplied
by the prelude for that reason, and the step that uses them is a *term* the law
can carry unchanged on both sides.

The law `collatz_len_no_fuel` is the pin on the empty budget: it is the first
arm of the outer match, and no other law here reaches it, because every other
law either hands the walk a budget above zero or names a number it stops at.

`collatz_len_zero` and `collatz_len_one` are the pins on the two values the
inner match answers without recursing. The second is not implied by the first:
`1n` is the other answer the match gives, and a body that sent `1n` on to `4n`
-- which is what one Collatz step does with it -- keeps the first law and fails
this one. Both are case splits on the budget rather than computations, because
the outer match has to see the budget as a numeral before the inner one is
reached.

`collatz_len_step` is where the content is. It says one more unit of budget buys
one more step, that a step costs exactly one, and what the next value is. It is
definitional: `1n + f` and `1n + 1n + p` are both successors, so both matches
take a step case and the two sides are left with the same step term. A body that
recursed at the same number, or that took the odd branch for even numbers, or
that forgot to count, is separated here.

`collatz_len_six` and `collatz_len_fifteen` are the closed values. The laws
above fix the recurrence and the two answers it stops at; these fix what the
recurrence is a recurrence *of*, on two numbers whose paths are known, and state
the walk at a budget it does not exhaust.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.collatz_len_no_fuel(n)`, `def L.collatz_len_zero(f)`,
`def L.collatz_len_one(f)`, `def L.collatz_len_step(f, p)`,
`def L.collatz_len_six()` and `def L.collatz_len_fifteen()`.
