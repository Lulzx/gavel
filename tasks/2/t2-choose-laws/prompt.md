Implement `choose` on two `Nat`s, then prove the four laws.

`choose(n, k)` is the number of ways to choose `k` items out of `n`. It is `1n`
for `k` of `0n`, `0n` when there is nothing left to choose from and the count is
not `0n`, and a pair of successors splits into the selections that leave the
first item out and the selections that take it -- Pascal's recurrence. So
`choose(5n, 2n)` is `10n` and `choose(4n, 5n)` is `0n`.

The recursion is on the first argument, and it is a structural descent:
matching `1n++p` binds the predecessor, and the self-calls pass `p`, which is a
subterm of what was matched. The second argument is matched too, but in each arm
of the first match, and Bend matches its parameters in order, so the first
argument is matched before the second.

The self-calls need the pair and the pair with its count one smaller, and the
one-smaller count is a computed value: the pattern that bound the count is not a
name that can be handed on, so it is written `Nat.sub(k, 1n)`. A computed
argument is accepted here because the *first* argument of each self-call is `p`,
which is already smaller, and the checker stops comparing arguments once one of
them shrinks. The count itself is read twice in the step -- once as itself and
once inside its predecessor -- so it is declared reusable: `+k`.

The law `choose_zero_left` is the pin on the arm where there is nothing left to
choose from, and `choose_zero_right` the pin on the arm where the count has run
out. The second is an induction rather than a computation: the first argument is
a variable there, so the two sides are not equal by definition.

`choose_step` is Pascal's step and the law with the content -- the two pins fix
only the arms where one count has run out, and this one fixes what happens
before either has. It is definitional, so its proof closes with `{==}`.

`choose_five_two` is the closed one: both sides are literals, so the checker
computes them. A body with the right recurrence can still be wrong about which
number is the selection and which is the pool, and this is the law that sees it,
because both answers are written out.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.choose_zero_left(k)`, `def L.choose_zero_right(n)`, `def L.choose_step(n,
k)` and `def L.choose_five_two()`.
