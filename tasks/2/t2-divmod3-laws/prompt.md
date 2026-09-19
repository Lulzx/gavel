Implement `divmod3` on `Nat`, then prove the five laws about it.

`divmod3(n)` must divide `n` by three, answering a `P.Pair` of quotient and
remainder: `divmod3(7n)` is `MkPair{2n, 1n}`, because seven holds two threes
with one left over. Three is the divisor the recursion consumes, so there are
four cases: `0n`, `1n` and `2n` answer themselves with a zero quotient, and an
input of three or more steps down by three and passes the answer through
`P.shift`, which adds one to the quotient. Write that larger case as the pattern
`case 3n++k:`, which binds `k` to the input less three.

The prelude is immutable and holds `P.Pair`, `P.shift` and `P.snd`. `shift` is
supplied rather than asked for, so that the laws pin the division itself; `snd`
is what lets the laws about the remainder name the second half of the answer.

`divmod3_zero`, `divmod3_one` and `divmod3_two` are the three pins. Each is
definitional, and each fixes one of the three answers the step law does not
reach: `divmod3_succ3` is stated at `3n + k`, so a body that answered a zero
remainder for every input below three satisfies it.

`divmod3_succ3` is the step, and it is definitional too. It fixes the quotient:
three more than an input fits one more time, and `P.shift` is what says so. A
body that added to the remainder rather than the quotient, or that counted the
threes somewhere the recursion never reaches, leaves the two sides of this law
unconvertible.

`divmod3_rem` is the law that is not definitional. With `n` a variable, neither
side computes -- `divmod3` is stuck until its argument is a numeral -- so the
induction is the proof, and the case that carries the work is `3n++k`, where the
answer is `P.shift` of the answer at `k`. It is the law that says the answer is
a division rather than any pair with the right quotient: everything above fixes
which quotient comes out and says nothing about how large the remainder may be,
so a body that carried the input through as its own remainder satisfies them
all and fails here.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.divmod3_zero()`, `def L.divmod3_one()`, `def L.divmod3_two()`,
`def L.divmod3_succ3(k)` and `def L.divmod3_rem(n)`.

The proof of `divmod3_rem` needs one fact the prelude does not state: that
`P.shift` leaves the remainder alone. Write it in `PROOF.bend` as a helper
named `Policy.snd_shift`, not as a law, since a law that cited another law would
make the credit for both depend on the citation. Note that a rewrite step goes
from the helper's right-hand side to its left, so a helper oriented the way the
goal needs it may have to be read backwards with `Equal.sym`; annotate the step
with the goal in which the term that is being rewritten has been replaced by
`_`.
