import Base
import ./prelude.bend as P

# TODO(policy): implement. `digit_sum(w, n)` is the sum of the base-10 digits of
# `n`, read least significant first, with at most `w` digits looked at. The
# digit that comes off is `Nat.mod(n, 10n)` and what is left is
# `Nat.div(n, 10n)`, which is a computed value rather than a subterm of `n`: the
# argument that shrinks is therefore the width, handed in first, exactly as
# `t2-nat-bits` hands `nat_bits` its width. `0n` of width answers `0n`, because
# there is no digit left to read, and a width of `1n + p` answers the low digit
# plus the same sum over the rest of the number. `n` is read twice there, so it
# is declared reusable: `+n`.
def digit_sum(w: Nat, +n: Nat) -> Nat:
  ?TODO
