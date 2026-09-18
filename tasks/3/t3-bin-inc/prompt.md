Implement `inc_bin` on the prelude's bit lists, then prove all three laws.

A natural number is written here as a `List<&2, P.Bit>`, least significant bit
first, and the prelude is immutable. It owns the bit type (`P.O{}` and `P.I{}`),
`P.to_nat`, which reads a bit list back as the `Nat` it denotes, `P.bit_val`,
which is the number a single bit contributes, and `P.double`, which is twice a
number. `List<&2, P.Bit>` is the list type here, and a law or helper written
over `List<Nat>` will not unify with these.

`inc_bin(bs)` is one more than `bs`, as a bit list. The increment enters at the
low bit: a low `O{}` becomes `I{}` and stops, and a low `I{}` becomes `O{}` and
leaves a carry to be added to the next bit up. The empty list is the number
zero, so incrementing it gives the one-bit number `I{} <> Nil{}`.

The two pins are definitional. `inc_bin_nil` fixes the empty number, and
`inc_bin_zero` fixes what an `O{}` low bit does. Both sides of each compute, so
`{==}` closes them, and the reason they are worth stating is that they are what
says the increment enters at the *low* end: a body that carried into the high
end, or that answered `Nil{}` everywhere, satisfies one of them only by
breaking the other, and leaves `to_nat_inc` out of reach.

The real work is `to_nat_inc`: reading back the incremented list is one more
than reading back the original. The `I{}` case is the whole of it, and it is
what the carry does to the goal:

    case I{} <> t:
      -- goal: to_nat(inc_bin(I{} <> t)) == 1n + to_nat(I{} <> t)
      -- unfolds to: to_nat(O{} <> inc_bin(t)) == 1n + (1n + double(to_nat(t)))
      -- which is: double(to_nat(inc_bin(t))) == 2n + double(to_nat(t))

so the goal is about the *recursive* `inc_bin(t)`, nested inside `double`.
`inc_bin(t)` is a computed value, so `to_nat` of it cannot reduce: the induction
hypothesis is the only thing that can rewrite it, and it has to be applied to
both of the occurrences `double` makes. What is left over is arithmetic the
prelude does not have -- `x + (1n + x)` is `1n + (x + x)` -- and that fact is
stuck on a variable, because `Nat.add` matches on its *left* argument and `x` is
not a constructor. It needs an induction of its own, which belongs in a helper.

The list binder of the work law is `+bs`: the tail is live twice in the step,
once for each `inc_bin(t)` that `double` duplicates. `P.double`'s own parameter
is `+` for the same reason, and a body that used a Lone binder twice is rejected
with `consumed more than once`, which reads like a bug in the prelude and is not
one.

The helpers belong under the reserved `Policy.` namespace, which the gate
ignores and the credit path does not count. A helper may call `P.*`, `S.*` and
other `Policy.*`, but never a law, since a helper that cited one would make an
isolated law depend on a law that has not been credited yet and the credit for
both would be lost.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare while one stating it the other way needs `Equal.sym` around it. A motive
with the hole anywhere else is rejected with `expected`/`observed` about the
hole's type, which reads like a bug in the lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the
solution does not re-export the prelude, so a law that means the prelude's
`to_nat` must say `P.to_nat`; naming `S.to_nat` gets `expected : a defined name
/ observed : S.to_nat`, which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.inc_bin_nil()`, `def L.inc_bin_zero(t)` and
`def L.to_nat_inc(bs)`, and each may cite the earlier helpers but never one of
the other laws. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
