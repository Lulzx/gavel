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

The last three laws are anchors, and they are here because the two above do not
pin the functions on their own. `pred_zero` names the case neither of them
reaches: both apply `pred` to a successor, so a `pred` answering `1n` at `0n`
satisfies them both.

`add_zero` and `add_succ` together are what pin `add`, and neither is enough
alone. `pred_add_one` applies `add` at the second argument `1n` and nowhere
else, so an `add` that ignores `b` entirely answers `1n + x` there and is a
successor, and `pred` steps on it — the law holds while `add(0n, 5n)` is `1n`.
`add_zero` is the closed-value anchor that rejects that body. But one value is
not the function: an `add` answering `a` at `0n`, `1n + a` at `1n` and `a + b +
1` from `2n` up agrees with everything above, which is why `add_succ` states the
step of the argument none of the others steps.

    law pred_zero:  for x: Nat  {S.pred(0n) == 0n : Nat}
    law add_zero:   for x: Nat  {S.add(x, 0n) == x : Nat}
    law add_succ:   for a: Nat  for b: Nat
      {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}

`pred_zero` closes by unfolding. `add_zero` is inductive in `x` and needs the
auxiliary lemma

    def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:

whose hypothesis is its goal, for the same reason `add_one_comm` is: Base's `+`
does not reduce on a variable, so `x + 0n` is stuck and `S.add`'s
first-argument recursion is what removes it.

`add_succ` is the one law here that is neither definitional nor closed by
reduction: `add` recurses on its *first* argument, so its second-argument step
is an induction in `a` with `b` carried through — the same shape as
`add_one_comm`, at an arbitrary `b` rather than at `1n`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pred_succ(x)`, `def L.pred_add_one(x)`, `def L.pred_zero(x)`,
`def L.add_zero(x)` and `def L.add_succ(a, b)`.
