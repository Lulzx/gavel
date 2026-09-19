import Base
import ./prelude.bend as P

# TODO(policy): implement. `is_suffix(xs, ys)` answers whether `xs` is the tail
# end of `ys`. Recurse on `ys`, the list that has to be walked to the end: when
# `ys` is empty the answer is whether `xs` is empty too, and when `ys` is a cons
# cell the answer is whether `xs` is the whole of `k <> u` or a suffix of `u`.
# The walk offers `xs` both to the comparison and to the recursive call, so
# `xs` is a `+` parameter, and `u` is read twice, so its binder is `+u`; the
# lists are `List<&2, Nat>` to make those markers legal.
# A body that recurses on `xs` instead is wrong: it reports `[1n, 2n]` as a
# suffix of `[1n, 2n, 2n]`. `P.is_nil`, `P.eq_list`, `P.append` and `Bool.or`
# come from the prelude and `Base`.
def is_suffix(+xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  ?TODO
