import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a pad of zero leaves the list alone. Both sides compute, so this is a
# definitional companion: it fixes the empty case and rules out a body that
# extended every list it was handed.
law pad_nil:
  for x: Nat
  for xs: List<Nat>
  {S.pad(0n, x, xs) == xs : List<Nat>}

# LAW: padding one element onto nothing gives that element. Also definitional,
# and also a companion: with the length law alone, the element the pad is
# filled with could be anything.
law pad_single:
  for x: Nat
  {S.pad(1n, x, Nil{}) == x <> Nil{} : List<Nat>}

# LAW: the padded list is as long as the target length or as long as the input,
# whichever is larger. This is the induction, and it is stated exactly rather
# than as a bound. The identity body -- `pad(n, x, xs) = xs`, the first
# parameter of the return type -- fails it as soon as the target length
# outruns the list, and the constant body `Nil{}` fails it everywhere. Its
# step case is one use of the hypothesis plus a fact about `P.max` at a
# variable on the right, which is not definitional.
law pad_len:
  for n: Nat
  for x: Nat
  for xs: List<Nat>
  {P.len(S.pad(n, x, xs)) == P.max(n, P.len(xs)) : Nat}

# LAW: a non-empty list keeps its own head and the pad continues on the tail.
# `pad_nil` fixes the zero count, `pad_single` only ever asks about `Nil{}` and
# `pad_len` counts, so before this law no case of the step was constrained and a
# body that overwrote every element with the filler -- `x <> pad(k, x, t)` --
# proved all three at full reward. Definitional, and it is also the statement
# that the input survives as a prefix of the result.
law pad_step:
  for n: Nat
  for x: Nat
  for y: Nat
  for ys: List<Nat>
  {S.pad(1n + n, x, y <> ys) == y <> S.pad(n, x, ys) : List<Nat>}

# LAW: the empty list's step. `pad_len` counts and `pad_step` needs a cons, so
# the one case neither reaches is a target that outruns an *empty* input: the
# count says how many elements the answer has, and nothing says which ones.
# **Measured 2026-09-19:** a body whose empty case answers `P.max(k, x)` in
# front of the recursion instead of `x` -- so the filler is replaced by the
# remaining count wherever that is larger -- reads **tier 4, complete, reward
# 1.000, all four laws proven by the reference proof unchanged**, and it is
# wrong: `pad(2n, 0n, Nil{})` is `[1n, 0n]` where the reference answers
# `[0n, 0n]`. It satisfies `pad_single` because `P.max(0n, x)` reduces to `x`,
# and `pad_len` because `max` does not change a length. This law is the empty
# case read back, and it is what makes the filler the only thing that can be
# put there.
#
# The body needs `case 1n++k:` -- the owned binding -- because `k` is used
# twice in it, in the `max` and in the recursive call. Written as the plain
# `case 1n+k:` it does not compile, and a non-compiling body measures tier 1,
# which is evidence of nothing; that spelling was the earlier record's gap.
law pad_nil_step:
  for n: Nat
  for x: Nat
  {S.pad(1n + n, x, Nil{}) == x <> S.pad(n, x, Nil{}) : List<Nat>}

