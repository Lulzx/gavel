import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the flattened list has as many elements as the pieces have between them.
# This is the induction, and its step case folds a `len` over an `append` whose
# right side is the flattened tail -- a list the hypothesis describes but that
# nothing here can match on. The body that ignores its argument, `Nil{}`, fails
# it: the left-hand side is `0n` and the right-hand side is `P.sum_lens(xss)`,
# which is stuck on a variable.
law concat_len:
  for xss: List<List<Nat>>
  {P.len(S.concat(xss)) == P.sum_lens(xss) : Nat}

# LAW: and it holds the same elements, not merely the same number of them. A
# body that flattened to the right length of zeros satisfies `concat_len`; this
# one is stated with `P.sum`, which adds the elements themselves, and the step
# case needs the same fold over `append` at the element type. It is not implied
# by the length law alone, and it is not implied by `concat_single` either,
# which speaks only about a one-piece list.
law concat_sum:
  for xss: List<List<Nat>>
  {P.sum(S.concat(xss)) == P.sum_sums(xss) : Nat}

# LAW: a list of one piece is that piece. The two laws above are about measures
# of the answer and would both be satisfied by a body that returned the right
# measure of the wrong list -- the pieces in the wrong order, say, or one of
# them dropped and another repeated. Here both sides compute, so the answer
# itself is what is constrained. This is also the law that needs the right
# identity for `P.append`, since `concat(xs <> Nil{})` unfolds to
# `P.append(xs, Nil{})`.
law concat_single:
  for xs: List<Nat>
  {S.concat(xs <> Nil{}) == xs : List<Nat>}

# LAW: a piece goes in front of the rest. The three laws above constrain two
# measures of the answer and its value on one-piece lists, and that leaves the
# order of the pieces free: `P.append(concat(t), h)` has the same length and the
# same sum, and a one-piece list cannot tell the order apart. **Measured** by
# `tools/holes.py`: the shipped mutant `concat-reversed-pieces` satisfies every
# instance of the three and answers `[1n, 0n]` for `[[0n], [1n]]`. V2 had read it
# as killed by `concat_len`, because the reference proof's step rewrites with
# `len_append` in the reference's order -- a fact about that proof, not about
# the law. With this law the answer is determined: the empty list is pinned by
# `concat_len`, since a list of length `0n` is `Nil{}`.
law concat_cons:
  for h: List<Nat>
  for t: List<List<Nat>>
  {S.concat(h <> t) == P.append(h, S.concat(t)) : List<Nat>}
