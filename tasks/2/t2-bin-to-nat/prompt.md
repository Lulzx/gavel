Implement `bin_to_nat`, the reader that turns a list of bits back into the
number those bits came from, then prove the laws that pin it.

A bit list here is `List<&2, Nat>`, least significant bit first, in the
representation the prelude's `nat_bits` produces. `bin_to_nat(bs)` must return
the number the list is worth. Recurse on `bs`: `Nil{}` is the base case and is
worth `0n`, and `h <> t` is worth `h + 2n * bin_to_nat(t)`, because a bit one
position further from the front is one position more significant -- one place
to the left is twice the weight.

The law `bin_to_nat_nil` fixes the answer the recursion reaches on the empty
list. It is the weak companion that pins the base case: `bin_to_nat_cons` says
what a cons cell answers in terms of its tail, so a body that got `Nil{}` wrong
still satisfies it.

The law `bin_to_nat_cons` is the step, written out. It is definitional -- the
reader matches on the cons cell -- and it is what fixes the position of a bit:
a reader that read the bits the other way round, or that scaled the tail by
anything but two, does not have these two sides equal.

The law `bin_to_nat_nat_bits` is the round trip, and it is the reason this task
exists. The prelude supplies both the bank's encoder `nat_bits(w, n)` -- the low
`w` bits of `n`, least significant first -- and `low(w, n)`, what those bits are
worth. The law says that encoding a number to its low `w` bits and reading the
result back with your reader gives `low(w, n)`, for every width and every
number. It is an induction in the width: the encoder matches on the width, so
its successor case leaves you with a cons whose tail is the encoder at the
halved number, and the hypothesis at that number is the rewrite you need.
`Nat.mod` and `Nat.div` stay symbolic throughout, so no arithmetic lemma is
required.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.bin_to_nat_nil()`, `def L.bin_to_nat_cons(h, t)` and
`def L.bin_to_nat_nat_bits(w, n)`.
