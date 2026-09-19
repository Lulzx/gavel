Implement `lcp_len` on two lists of `Nat`, then prove the five laws about it.

`lcp_len(xs, ys)` is the length of the longest common prefix of `xs` and `ys`:
the number of leading positions at which the two lists agree, stopping at the
first pair that differs or at the end of whichever list runs out first. It is a
`Nat`, not a `Bool` and not a list. `lcp_len([1n, 2n, 3n], [1n, 2n, 4n])` is `2n`,
`lcp_len([1n, 2n], [1n, 2n])` is `2n`, and `lcp_len([1n], [2n])` is `0n`.

Walk both lists at once: the empty list on either side ends the walk at `0n`,
and two cons cells answer the common prefix of their tails, plus one when the
two heads agree. Both list types are `List<&2, Nat>`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.is_eq(a, b)` is `1n` when the two elements are equal and `0n` otherwise, and
`P.gate(c, n)` is `n` when `c` is non-zero and `0n` when it is zero -- together
they turn "the heads agree or they do not" into a length, which is what the step
law uses. `P.len(xs)` is the length of a list.

The law `lcp_len_nil_left` fixes the answer when the first list is empty, and
`lcp_len_nil_right` fixes it when the second one is. They are not the same law:
the walk looks at the left list first, so the right-hand one is the branch that
says a list running out on the right ends the walk too, and it is inductive in
`xs` because the left list is a variable there.

The law `lcp_len_equal_singletons` is the other half of the anchor, written with
no variables at all: two one-element lists holding the same element have a
common prefix of length one, so a matching pair is counted rather than skipped.
No law about the empty list can say that.

The law `lcp_len_cons` is the step, and it is where the comparison lives: a
common prefix either starts with two equal heads -- and is then one longer than
the tails' own prefix -- or it is empty. This is the law a body that counted a
matching pair without checking that the elements agree fails.

The law `lcp_len_self` says the longest common prefix of a list with itself is
the whole list, which is `P.len` of it. It pins the walk as a *prefix* rather
than a comparison of one pair of elements, and it is the law a body that stopped
early, or that skipped matching positions, leaves unconvertible.

Together the five determine `lcp_len` on every input: the two anchors fix the
empty cases, the step law fixes the cons cells, and the last one is the reading
of what the first four say.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.lcp_len_nil_left(ys)`, `def L.lcp_len_nil_right(xs)`, `def
L.lcp_len_equal_singletons()`, `def L.lcp_len_cons(h, t, k, u)` and `def
L.lcp_len_self(xs)`. Helpers go under the reserved `Policy.` namespace, which
the gate ignores, and none of them may cite a law.
