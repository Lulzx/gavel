Implement `digit_sum` -- the sum of the base-10 digits of a number -- then prove
the four laws.

`digit_sum(w, n)` adds up the base-10 digits of `n`, reading them least
significant first, looking at at most `w` of them. `digit_sum(0n, n)` is `0n`,
and `digit_sum(1n + p, n)` is `Nat.mod(n, 10n)` plus `digit_sum(p, Nat.div(n,
10n))`. `Nat.mod` and `Nat.div` are in `Base`; nothing here has to write them.
The sum does not care about the order the digits come off in, which is why
reading them backwards is still the right answer.

The argument order is forced and it is the one thing worth reading twice. A
recursive call is only accepted when every argument *before* the one that
shrinks is passed unchanged. The width is what shrinks here -- one digit of
width comes off at each step -- while the number is divided by ten, and a
divided number is a computed term rather than a subterm, so it cannot be the
shrinking argument at all. The width therefore comes first, and the number
second. The number is then an argument that changes at every step, which means
it is used twice in the recursive branch (`Nat.mod(n, 10n)` and `Nat.div(n,
10n)`) and has to be declared `+n`. `def digit_sum(w: Nat, n: Nat)` is rejected
with `observed : n (consumed more than once)`, and `def digit_sum(n: Nat, w:
Nat)` with the recursive call dividing `n` is rejected with `expected : a
decreasing self-call`. The signature in `solution.bend` is the one that works;
the body is yours.

The prelude adds nothing: the laws speak in `Base` terms only.

`digit_sum_no_fuel` says the answer at width zero is `0n`, whatever the number
is. Its left-hand side is a ground term and both sides compute, so it is
definitional. It is the law that pins the *empty case*: a body that answered one
digit there instead would satisfy the other laws at every width above zero, and
that case is reached by a match that has already stopped, so nothing else in the
law set looks at it.

`digit_sum_step` says what the digits are: the low base-10 digit of `n`, then
the digits of `n` divided by ten. Definitional as well, because the reference
body is a match on the width. Note the shape of the statement: the width is
written `1n + w` on the left, so that the reference body's match steps into its
successor case with `p` bound to `w`, and the number is divided by ten in the
recursive call on the right. This is the law with the content: it is what says
the base is ten and the digits are read from the low end.

`digit_sum_123` and `digit_sum_thousand` are closed values, and they are the
laws that keep the recurrence honest about *which* number is being summed. The
first has three different digits and answers `6n`, which catches a body that
counted digits (`3n`) or that read only the low one (`3n`). The second has three
zeros in the middle and answers `1n`, which catches a body that charged a unit
for every position rather than for every digit value: on `1000n` that body
would answer `4n`, and `123n` cannot see the difference.

The numbers in the closed laws are small on purpose. `Nat.divmod.go` steps once
per unit of the number being divided, so the cost of a closed law is linear in
the number itself; a ten-digit number takes on the order of a billion steps and
the checker times out rather than failing.

`digit_sum_step` binds its arguments `+`, because it names each twice in its
statement -- the digit and the recursive call, on the right -- and a `Nat` that
is live twice is not Lone. `digit_sum_no_fuel` binds its number plain: it names
it once, in the recursive call, and never again.

The naming rule the proofs need: the law file imports the prelude as `P` and the
solution as `S`, and the solution does not re-export the prelude, so a law that
means a prelude name must say `P.`; naming `S.` for something the policy is not
being asked to write gets `expected : a defined name / observed : S.<name>`,
which reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.digit_sum_no_fuel(n)`, `def L.digit_sum_step(w, n)`,
`def L.digit_sum_123()` and `def L.digit_sum_thousand()`, and none of
them may cite another. A helper, if one is needed, goes under the reserved
`Policy.` namespace, which the gate ignores and the credit path does not count.
Write the implementation in `solution.bend` and the proofs in `PROOF.bend`.
