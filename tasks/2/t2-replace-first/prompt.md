# Replace the first occurrence

`replace_first(xs, k, y)` is the list `xs` with the *first* occurrence of `k`
replaced by `y`. The length does not change; occurrences after the first are
left alone; and a `k` that does not occur at all leaves `xs` unchanged:

    replace_first([1n, 2n, 1n], 1n, 9n)  ==  [9n, 2n, 1n]
    replace_first([1n, 2n, 3n], 5n, 9n)  ==  [1n, 2n, 3n]

The list is the argument the recursion shrinks, so it is the first parameter. Two
functions are already close to this and are not it: `replace_at(xs, i, y)`
replaces by *position* and puts `y` wherever the index says, whether or not `y`
was there before; `delete_at` drops an element and shortens the list. Here the
position is decided by the *value*, and only the first place where it matches.

The prelude hands you the vocabulary:

- `P.eq(a, b) -> Bool` is the comparison the walk decides on. It steps one
  successor off each side at once, so on two variables it does not reduce.
- `P.rp_branch(b, h, y, t, r) -> List<Nat>` is the step with its decision exposed
  as an argument. When `b` is `True{}` it answers `y <> t`; when it is `False{}`
  it answers `h <> r`. Notice that the `True{}` answer is built from `t` -- the
  tail the walk was handed -- and discards `r` entirely. That is the whole of
  what makes the replacement *first*: the rest of the list comes back without
  ever being walked.
- `P.len(xs) -> Nat` counts the elements.

Bend cannot scrutinise the result of a call in a `match`, so the comparison
cannot be made where the two answers are told apart: the cell has to hand
`P.eq(h, k)` on to `P.rp_branch`. The head is read twice in the step (once by the
comparison and once by the step), and `k` and `y` are each read twice (once in
the comparison or the replacement, once in the recursive call), so all three are
declared reusable: `+h`, `+k`, `+y`.

## The laws, and what each one pins

`replace_first_nil` is the anchor: `Nil{}` in, `Nil{}` out, one side computing
without calling you. It is the only law here whose right-hand side does not name
`replace_first`, so it is the one that stops a body which is the reference buried
under a cancelling wrapper.

`replace_first_hit` replaces the head itself. The decision is `True{}` only
because `h` equals `h`, and that is an induction on `h`, not an unfolding --
which is why this law has content and is not a restatement of the prelude.
`replace_first_miss` is the other half of the case split, guarded by a premise
about `P.eq`, a function you do not write, so the premise cannot be falsified by
your submission. Together the two say what one cell does; the head survives and
the walk moves on in one, and is dropped for `y` in front of the untouched tail
in the other.

`replace_first_len` says the length is unchanged, by induction. It is what
separates a replacement from a deletion or a duplication.

`replace_first_three` and `replace_first_absent` are closed. The first is what
"first" means: the second `1n` in the input is still `1n` in the output. The
second walks the whole list without a hit and pins what comes back at the end --
a body that answered `y <> xs` when nothing matched passes every other law.

## What the policy implements

One function, `replace_first`, in `solution.bend`. `LAWS.bend`, `prelude.bend`
and everything under `references/` are immutable.
