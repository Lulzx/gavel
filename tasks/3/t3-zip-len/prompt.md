Implement `zip` on the prelude's two list types, then prove all three laws.

`zip(xs, ys)` pairs the elements of `xs` and `ys` in order and stops as soon as
either list runs out. The prelude is immutable and already has the vocabulary the
laws are stated in: the pair type `P.P2` with its constructor `P.Mk{a, b}`,
`P.len` for the number list, `P.zlen` for the list of pairs, and `P.min`.
Constructors are written positionally and reached through the prelude alias --
`P.Mk{hx, hy}`, in patterns and in terms alike -- and a `List<&2, Nat>` cannot
hold two numbers at once, which is why the result is a list of pairs and why the
length of that list is `P.zlen` and not `P.len`.

The two nil laws are the weak half. `zip_nil_l` fixes what an empty left list
zips to, and both sides compute, so `{==}` closes it. `zip_nil_r` is the mirror
image and is *not* an unfolding when the left list is a variable: the match in
`zip` is stuck, so the two sides are proved equal by an induction on `xs` whose
step case is the branch the body already took. Together they say which list is
read first and that running out on either side ends the result, which is what a
body that paired the first elements and stopped would get wrong.

`zip_len` is the law the task is named for, and it is the one that says *which*
list runs out: `zip` has as many elements as the shorter of the two, not as the
first one and not as the longer one. A body that answered `P.len(xs)` satisfies
both pins and leaves the two sides here unconvertible whenever `ys` is shorter.
The proof is an induction over both lists at once, because both of them shrink on
the way down -- the hypothesis is needed at the two tails, not at one of them and
something else -- and it mirrors `zip`'s own recursion, so each step lands on the
same branch the body took:

    case hy <> ty:
      -- zlen(zip(hx <> tx, hy <> ty)) reduces to 1n + zlen(zip(tx, ty))
      -- min(len(hx <> tx), len(hy <> ty)) reduces to 1n + min(len(tx), len(ty))
      -- so the hypothesis at (tx, ty) closes it, with no arithmetic of its own

Two of the three cases need nothing but the branch: an empty left list and an
empty right list both reduce to `0n` on both sides, because `P.min` matches on
its first argument and then on its second. A variable is Lone by default -- usable
live once per branch -- and the helper's lists are `+` only because the
destructured pair is read again when the recursive call is built.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.zip_nil_l(ys)`, `def L.zip_nil_r(xs)` and `def L.zip_len(xs, ys)`,
and the last one cites the `Policy.` helper that carries the induction. Helpers
go under the reserved `Policy.` namespace, which the gate ignores and the credit
path does not count; a helper may call `P.*`, `S.*` and other `Policy.*`, but
never a law, since a helper that cited one would make an isolated law depend on a
law that has not been credited yet and the credit for both would be lost.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits. A motive with the hole anywhere else is rejected
with `expected`/`observed` about the hole's type, which reads like a bug in the
lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `min` must say
`P.min`; naming `S.min` gets `expected : a defined name / observed : S.min`,
which also reads like a proof bug and is not one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`.
