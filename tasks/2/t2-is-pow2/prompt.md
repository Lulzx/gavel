Implement `is_pow2` -- whether a number is a power of two -- then prove the six
laws.

`is_pow2(w, n)` says whether `n` is a power of two, looking at at most `w`
halvings. `is_pow2(0n, n)` is `False{}` whatever the number is. Above zero,
match the number: `0n` is `False{}`, `1n` is `True{}`, and `1n + 1n + q` is
`Bool.and(P.is_even_b(n), is_pow2(p, P.half(n)))`, where `p` is the width one
unit shorter.

The argument order is forced. A recursive call is only accepted when every
argument *before* the one that shrinks is passed unchanged, and the number is
halved rather than taken apart, so a halved number is a computed term and cannot
be the shrinking argument at all. The width therefore comes first, and the
number second. The number is then used twice in the recursive branch
(`P.is_even_b(n)` and `P.half(n)`) and has to be declared `+n`. `def
is_pow2(w: Nat, n: Nat)` is rejected with `observed : n (consumed more than
once)`, and `def is_pow2(n: Nat, w: Nat)` with the recursive call halving `n` is
rejected with `expected : a decreasing self-call`. The signature in
`solution.bend` is the one that works; the body is yours.

The prelude has `P.is_even_b` and `P.half`, and they are there for a reason
about the checker rather than for convenience: a `match` cannot scrutinise a
computed value, so `Nat.mod(n, 2n)` is stuck for a variable `n` and a branch on
parity is impossible. The parity is therefore a *term*, and the prelude's two
helpers are what it is built out of. Both match on `n` one constructor at a
time, so with a variable they are stuck -- which is what keeps the step law
definitional.

The width is a budget, not part of the answer: `is_pow2(3n, 4n)` is `True{}` and
`is_pow2(2n, 4n)` is `False{}`, because the walk is `4n`, `2n`, `1n` and the
`1n` case has to be reached. The laws state the width they mean; the two closed
ones are stated at three, which is exactly `log2` of the number plus one for
`4n`.

`is_pow2_no_fuel` says an exhausted width answers `False{}`, whatever the number
is. Its left-hand side is ground in the width and both sides compute, so it is
definitional. It is the law that pins the *stopped* answer: a body that
answered `True{}` there would satisfy every other law, because none of them
reaches width zero.

`is_pow2_zero` and `is_pow2_one` are the two absolute anchors -- the answers the
function has to give, which nothing else relates to anything. Zero is `False{}`
at any width, and one is `True{}` at any width above zero. `is_pow2_zero` is
inductive in the width, because with a variable width the left-hand side does
not reduce on its own; `is_pow2_one` writes the width as `1n + w`, which makes
it definitional, and deliberately excludes zero width, where the answer is
`False{}`.

`is_pow2_step` is the law with the content: a number above one is a power of two
exactly when it is even and half of it is one. Definitional, because the outer
match steps on `1n + w` and the inner match steps on `1n + 1n + q`. It binds its
arguments `+`, because each is named twice in the statement and a `Nat` live
twice is not Lone.

`is_pow2_four` and `is_pow2_six` are closed values, and they are what pins the
two arms of the inner match. `4n` is `True{}` -- a body that answered `False{}`
on the `1n` case would satisfy every law above. `6n` is `False{}` even though it
is even: it halves to `3n`, which is odd. That second one is the law that
separates a power-of-two test from a parity test, which would get every power of
two right.

The naming rule the proofs need: the law file imports the prelude as `P` and the
solution as `S`, and the solution does not re-export the prelude, so a law that
means a prelude name must say `P.`; naming `S.` for something the policy is not
being asked to write gets `expected : a defined name / observed : S.<name>`,
which reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.is_pow2_no_fuel(n)`, `def L.is_pow2_zero(w)`,
`def L.is_pow2_one(w)`, `def L.is_pow2_step(w, q)`, `def L.is_pow2_four()` and
`def L.is_pow2_six()`, and none of them may cite another. A helper, if one is
needed, goes under the reserved `Policy.` namespace, which the gate ignores and
the credit path does not count. Write the implementation in `solution.bend` and
the proofs in `PROOF.bend`.
