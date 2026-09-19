Implement `count_below` and `count_above`, then prove all four laws.

`count_below(x, xs)` is how many elements of `xs` are at most `x`;
`count_above(x, xs)` is how many are above it. On `[3n, 1n, 2n]` with `x = 2n`,
`count_below` is `2n` and `count_above` is `1n`. Both recurse on `xs`: `Nil{}`
counts nothing, and a cons cell hands the tail's count and the predicate's answer
for the head to `P.cb_put` or `P.ca_put`.

The two helpers exist because a `match` cannot scrutinise a *computed* value. The
predicate `P.le(h, x)` is stuck while `h` and `x` are variables, so the cons cell
recurses on the list first and defers the decision to a helper that takes the
answer as an argument -- `P.cb_put(r, k)` answers `1n + r` when `k` is `True{}`
and `r` otherwise, and `P.ca_put(r, k)` is the same with the two answers swapped.
The two helpers are the only difference between the two functions.

The list type is `List<&2, Nat>`, the prelude's `P.le`, `P.cb_put`, `P.ca_put`
and `P.len` are immutable, and a `List<Nat>` will not unify with these. `x` is
read twice in a cons cell -- once for the predicate and once for the recursion --
so it is declared `+x`, and a variable is **Lone** by default, exactly as in
`t2-span-below`.

`count_below_nil` fixes the empty answer -- `Nil{}` is a list constructor, so both
sides compute -- and the two cons laws are what fix `count_below` completely.
Neither reaches the empty case, which is why `count_below_nil` is stated
separately. Each cons law carries the predicate's answer as a **premise**: with
`h` and `x` variables neither side reduces without it, and the premise is about
`P.le` over universally quantified values, so no submission can falsify it.
`count_below_keep` is the head that is counted; `count_below_drop` is the head
that is not, and without it a body that counted every element would keep the
first law.

`count_below_split` is the interaction law and the whole of what pins
`count_above`: every element is on one side of `x` or the other and none is
counted twice, so the two counts add up to the length of the list. The three laws
above fix `count_below` completely, and this one then fixes `count_above` to be
however many are left, on every input at once. With a variable list neither side
reduces -- both calls are stuck -- so this is an induction on `xs`. It is the
only law here that is not an unfolding.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_below_nil(x)`, `def L.count_below_keep(h, t, x, e)`,
`def L.count_below_drop(h, t, x, e)` and `def L.count_below_split(xs, x)`.
