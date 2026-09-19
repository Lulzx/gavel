Implement `pred` and `add` on `Nat`, then prove both laws.

`pred(n)` must return the predecessor of `n`, and `0n` when `n` is `0n`. It is
the deconstructor of `Nat`, so it matches rather than recurses. `add(a, b)`
must return the sum of `a` and `b`; recurse on the first argument.

`pred_succ` says the predecessor of a successor is the number itself, which
`pred` already computes. `add_one` says that adding one on the right is the same
as adding one on the left; it is inductive in `x`, and its step case rewrites
with the induction hypothesis at `p`.

`add_one` does not, on its own, determine `add`, and this is worth saying
plainly, because the obvious reading is that it does. It observes `add`'s second
argument at `1n` and nowhere else, so `add(a, b) = 1n + a` — an `add` that never
looks at `b` — satisfies it at every `x`. Two more laws close that off:

    law add_zero:  for x: Nat  {S.add(x, 0n) == x : Nat}
    law add_succ:  for a: Nat  for b: Nat
      {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}

`add_zero` is the closed-value anchor, and it needs an auxiliary lemma

    def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:

whose hypothesis is its goal: Base's `+` does not reduce on a variable, so
`x + 0n` is stuck and `S.add`'s first-argument recursion is what removes it.

`add_succ` is the step, and one value is not the function — `add_zero` alone
still leaves `add` free from `2n` up. It is the one law here that is neither
definitional nor closed by reduction, because `add` recurses on its *first*
argument: it is an induction in `a` with `b` carried through, the same shape as
`add_one` at an arbitrary `b` rather than at `1n`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.pred_succ(x)`, `def L.add_one(x)`, `def L.pred_zero(x)`,
`def L.add_zero(x)` and `def L.add_succ(a, b)`.
