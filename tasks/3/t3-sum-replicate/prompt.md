Implement `sum` on lists of `Nat`, then prove all three laws.

`sum(xs)` adds the elements up, starting from `0n` at the empty list. The
prelude is immutable and already has `P.replicate` and `P.mul`, both of which
step on their count or their first factor; the laws are stated in terms of them.

`sum_cons` is definitional -- both sides compute -- and is there to say the
answer is a fold rather than a counting of the list, which the other two laws
would let through on their own.

The two interesting laws are both inductions on `n`. `sum_replicate_mul`'s step
case unfolds the run into a cons and is then a single use of the hypothesis plus
the definition of `P.mul`: `P.mul(1n + k, x)` already *is* `x + P.mul(k, x)`, so
no arithmetic is needed. `sum_replicate_one` is the same induction at the
element `1n`, and its step ends at `1n + k` against `1n+k`, which is the same
term in this syntax.

Two things to watch. First, the hypothesis may not mention a law: no law's proof
may cite another law, so `sum_replicate_one` may not be closed by
`L.sum_replicate_mul` at `1n` even though that would be a correct argument.
Second, every variable is **Lone** by default -- usable live once -- and that
covers parameters of a `def` as well as variables bound by `case 1n+k:`. A
definition that needs a value twice says so with `+` (`def replicate(n: Nat,
+x: Nat)`) or with a rebinding line, `+k = k`, at the top of the branch. These
two proofs only use their pattern binder once, in the hypothesis application,
so no rebinding is required -- but note that `P.replicate` and `P.mul` are
written the way they are for exactly this reason.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_replicate_mul(n, x)`, `def L.sum_replicate_one(n)` and
`def L.sum_cons(h, t)`. Helpers go under the reserved `Policy.` namespace, which
the gate ignores.
