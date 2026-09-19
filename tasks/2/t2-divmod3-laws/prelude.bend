import Base

# Immutable, and owned by the task rather than the policy. The laws look inside
# the answer `divmod3` gives, so the pair is stated here rather than left to the
# policy, and the two accessors the laws need are stated over it.

# The quotient and the remainder `divmod3` answers with, in that order. A `Nat`
# cannot hold both halves, so the laws are stated over a pair of them.
type Pair is Data:
  MkPair{q: Nat, r: Nat}

# One more three fits: the quotient goes up by one and the remainder is left
# alone. This is `divmod3`'s step, so it is the prelude's job rather than the
# policy's -- the policy is asked for the division, not for the arithmetic on
# the answer.
def shift(p: Pair) -> Pair:
  match p:
    case MkPair{q, r}:
      MkPair{1n + q, r}

# The remainder half of the answer. The laws about the remainder are the ones
# that say the answer is a division rather than any pair with the right
# quotient, so they have to be able to name it.
def snd(p: Pair) -> Nat:
  match p:
    case MkPair{q, r}:
      r
