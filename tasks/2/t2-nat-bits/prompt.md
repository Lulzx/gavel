Implement `nat_bits` -- the low bits of a number, as a list -- then prove the
three laws.

`nat_bits(w, n)` is the low `w` bits of `n`, least significant first:
`nat_bits(0n, n)` is `Nil{}`, and `nat_bits(1n + p, n)` is `Nat.mod(n, 2n)`
followed by `nat_bits(p, Nat.div(n, 2n))`. `Nat.mod` and `Nat.div` are in
`Base`; nothing here has to write them.

The argument order is forced and it is the one thing worth reading twice. A
recursive call is only accepted when every argument *before* the one that
shrinks is passed unchanged. The width is what shrinks here -- one bit of width
comes off at each step -- while the number is halved, and a halved number is a
computed term rather than a subterm, so it cannot be the shrinking argument at
all. The width therefore comes first, and the number second. The number is then
an argument that changes at every step, which means it is used twice in the
recursive branch (`Nat.mod(n, 2n)` and `Nat.div(n, 2n)`) and has to be declared
`+n`. `def nat_bits(w: Nat, n: Nat)` is rejected with
`observed : n (consumed more than once)`, and `def nat_bits(n: Nat, w: Nat)`
with the recursive call halving `n` is rejected with `expected : a decreasing
self-call`. The signature in `solution.bend` is the one that works; the body is
yours.

The prelude has `P.len`, the number of elements a list of numbers has. Nothing
else in it is needed to state the laws.

`nat_bits_zero` says the answer at width zero is the empty list, whatever the
number is. Its left-hand side is a ground term and both sides compute, so it is
definitional. It is the law that pins the *empty case*: a body that answered one
bit there instead would satisfy the other two at every width above zero, and
that case is reached by a match that has already stopped, so nothing else in the
law set looks at it.

`nat_bits_succ` says what the bits are: the low bit of `n`, then the low `p`
bits of `n` halved. Definitional as well, because the reference body is a match
on the width. Note the shape of the statement: the width is written `1n + w` on
the left, so that the reference body's match steps into its successor case with
`p` bound to `w`, and the number is halved in the recursive call on the right.

`nat_bits_len` is the induction and the only law that is not an unfolding: the
answer has one element per unit of width. `P.len` of a cons is one more than
`P.len` of its tail, so the successor case turns the goal into
`1n + P.len(nat_bits(p, Nat.div(n, 2n))) == 1n + p`, and the hypothesis is what
rewrites the `P.len` occurrence. That hypothesis is cited at the *halved*
number, which no match ever bound: it is available because the number is
quantified alongside the width, and the induction is on the width alone. A
proof that tries to use the hypothesis only at the `n` the law started with will
not close.

`nat_bits_succ` and `nat_bits_len` bind their arguments `+`, because each names
an argument twice in its statement -- the recursive call and the goal -- and a
`Nat` that is live twice is not Lone. `nat_bits_zero` binds its number plain: it
names it once, in the recursive call, and never again.

The naming rule the proofs need: the law file imports the prelude as `P` and the
solution as `S`, and the solution does not re-export the prelude, so a law that
means the prelude's length must say `P.len`; naming `S.len` gets
`expected : a defined name / observed : S.len`, which reads like a proof bug and
is not one. Anything the policy is not being asked to write is `P.`.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.nat_bits_zero(n)`, `def L.nat_bits_succ(w, n)` and
`def L.nat_bits_len(w, n)`, and none of the three may cite another. A helper, if
one is needed, goes under the reserved `Policy.` namespace, which the gate
ignores and the credit path does not count. Write the implementation in
`solution.bend` and the proofs in `PROOF.bend`.
