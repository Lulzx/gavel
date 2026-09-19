Implement `longest_run_len` on a list of `Nat`, then prove the five laws about
it.

`longest_run_len(xs)` is the length of the longest block of consecutive equal
elements of `xs`: the largest number of neighbours in a row that all hold the
same value. It is a `Nat`, not a list and not a list of blocks. An empty list
answers `0n`, and any list with at least one element answers `1n` or more, so
`longest_run_len([1n, 2n, 3n])` is `1n` -- no two neighbours agree, and a single
element is still a block of one -- while `longest_run_len([1n, 1n, 2n, 2n, 2n])`
is `3n`.

Recurse on `xs`: `Nil{}` answers `0n`, and a cons cell answers the better of two
things -- the block that starts at its first element, and the longest run inside
its tail. Every block either starts at the first element or lies inside the
tail. The tail is read twice, by both of those, so the cons pattern marks it
reusable and the list type is `List<&2, Nat>`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.run_len(xs)` is the length of the block of equal elements that starts at the
first element of `xs`, `0n` on the empty list and at least `1n` otherwise.
`P.is_eq(a, b)` is `1n` when two elements are equal and `0n` otherwise, and
`P.gate(c, n)` is `n` when `c` is non-zero and `0n` when it is zero; together
they are how `P.run_len` decides whether a block continues, which is why
`run_len` comes out as the prelude's answer rather than yours to write.

The law `longest_run_len_nil` fixes the empty answer at `0n`. Both sides
compute, so it is definitional, and it is the anchor: the step law names its
argument as a cons cell, so nothing else here reaches the empty input.

The law `longest_run_len_single` fixes the one-element answer at `1n`, the other
half of the anchor: a list whose neighbours never agree is not a list with no
run at all, it is a list of blocks of one.

The law `longest_run_len_cons` is the step, and it is where the maximum is
stated: the block starting at the head against the longest run in the tail. It
is the law a body that kept the first block and stopped, or that forgot the
positions after it, fails. Both sides compute.

The law `longest_run_len_one_pair` says two equal elements are a block of two,
and `longest_run_len_no_pair` says three elements with no equal neighbours are a
block of one repeated. They are written with no variables at all, and they are
where the comparison is read as equality of *neighbours*: the first is the
smallest input with a block longer than one, and the second is the smallest
input where every block ends as soon as it starts.

Together the five determine `longest_run_len` on every input, by induction on
the length: the first two fix the empty and one-element answers, the step law
fixes every longer list from its tail, and the last two are the readings of what
the step law says about neighbours.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.longest_run_len_nil()`, `def L.longest_run_len_single(x)`, `def
L.longest_run_len_cons(h, t)`, `def L.longest_run_len_one_pair()` and `def
L.longest_run_len_no_pair()`. Helpers go under the reserved `Policy.` namespace,
which the gate ignores, and none of them may cite a law.
