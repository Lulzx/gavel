import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over `List<&2, Nat>`, the representation the bank's
# `nat_bits` produces, and the one law that quantifies over a number binds it
# `+`: it names that number twice -- once inside the encoder call and once
# inside `P.low` -- and a `Nat` binder that is live twice is not Lone. Anything
# that is not the function the policy writes is `P.` -- the solution module
# re-exports nothing, so `S.low` is not a name.

# LAW: the empty list of bits is worth nothing. The left-hand side is a ground
# term and both sides compute, so this is definitional: it fixes the answer the
# recursion reaches when there is nothing left to read, and a body that
# answered a bit there would satisfy `bin_to_nat_cons` at every non-empty list.
# An empty case is an answer a stopped match gives rather than a step, so
# nothing else in this file looks at it.
law bin_to_nat_nil:
  {S.bin_to_nat(Nil{}) == 0n : Nat}

# LAW: the head of a bit list is worth its face value, and the tail is worth
# twice what it is worth on its own. Both sides compute, so this is
# definitional, and it is the law that fixes the *position*: a body that read
# the bits most significant first, or that scaled the tail by anything but two,
# leaves the two sides unconvertible.
law bin_to_nat_cons:
  for h: Nat
  for t: List<&2, Nat>
  {S.bin_to_nat(h <> t) == h + 2n * S.bin_to_nat(t) : Nat}

# LAW: reading back the low `w` bits of a number gives what those bits are
# worth. This is the round trip: the left side encodes `n` to a bit list with
# the bank's encoder and decodes it with the policy's reader, and the right side
# is the prelude's own statement of the answer. It is an induction in the width,
# not a crossing of `Nat.div`: the encoder matches on the width, so the
# successor case hands the reader a cons whose tail is the encoder at the
# halved number, and the hypothesis at that halved number -- a term the match
# never named -- is what rewrites it. `Nat.mod` and `Nat.div` are never
# evaluated on a variable, so nothing here needs an arithmetic lemma.
law bin_to_nat_nat_bits:
  for +w: Nat
  for +n: Nat
  {S.bin_to_nat(P.nat_bits(w, n)) == P.low(w, n) : Nat}
