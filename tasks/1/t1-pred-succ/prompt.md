Implement `add` and `pred` on `Nat`, then prove the laws about them.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`pred(a)` must return the predecessor of `a`: `0n` is the base case and the
step returns `p`.

The first law, `pred_succ`, is the predecessor of a successor. `pred` steps on
its argument, so it closes by reduction and `{==}` is its whole proof.

The second law, `pred_add_one`, is the same statement with the successor built
by `add` instead of `1n+`. It is inductive in `x`, and the base case closes by
reduction: `add(0n, 1n)` is `1n` and `pred` of that is `0n`.

The step is the interesting one. `add` recurses on its first argument, so
`add(1n+p, 1n)` reduces to `1n + add(p, 1n)`, and `pred` of `1n + _` is the
thing it wraps. The step goal therefore asks for

    add(p, 1n) == 1n+p

while the hypothesis is about `pred(add(p, 1n))`, which does not help. What
relates the two is that adding one on the right is adding one on the left:

    S.add(x, 1n) == 1n + x

Prove that as an auxiliary lemma and cite it. A helper in `PROOF.bend` is a def
named `Policy.` and, unlike a law, it must carry its type:

    def Policy.add_one_comm(x: Nat) -> {S.add(x, 1n) == 1n + x : Nat}:

It is itself inductive in `x`, and its hypothesis is exactly its goal.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pred_succ(x)` and `def L.pred_add_one(x)`.
