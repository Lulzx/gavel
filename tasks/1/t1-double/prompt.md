Implement `add` and `double` on `Nat`, then prove the law about them.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`double(a)` must return `a + a`. Recurse on `a`: `0n` is the base case and the
step is `1n+1n+double(p)`.

The law `double_eq_add` says that doubling is adding a number to itself. It is
inductive in `x`, but the step does not close with the hypothesis alone: the
step goal speaks about `add(p, 1n+p)` where the hypothesis is about `add(p, p)`,
and the only thing relating them is the successor law for `add`,

    1n + add(x, y) == add(x, 1n+y).

So prove that as an auxiliary lemma and cite it. A helper in `PROOF.bend` is a
def named `Policy.` and, unlike a law, it must carry its type:

    def Policy.add_succ_rev(x: Nat, y: Nat)
      -> {1n+S.add(x, y) == S.add(x, 1n+y) : Nat}:

It is itself inductive in `x`. The law's step cites it at `(p, p)`, which names
`p` twice; a binder is consumed on every use, so re-bind it reusable first with
`+p = p`, the same way `mul` declares a repeated parameter `+b`.

The second law, `double_succ`, is the step `double` recurses with: one more on
the argument is two more on the result. It closes by reduction, so `{==}` is
its whole proof.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.double_eq_add(x)` and `def L.double_succ(x)`.
