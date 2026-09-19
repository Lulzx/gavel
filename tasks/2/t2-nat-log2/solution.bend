import Base
import ./prelude.bend as P

# TODO(policy): implement. `log2_go(w, n)` is the walk. `w` is the width -- how
# many halvings are left to spend -- and it is the argument that shrinks, so it
# comes first and the number is carried along unchanged. Zero and one are both
# below every power of two above `1n`, so they stop the walk at `0n`; anything
# above one is halved and adds one to the walk below it. When the width runs out
# the answer is `0n`: the width only bounds the walk, it is not part of the
# answer.
#
# `w` is matched on and `n` is read by the match and by the recursive call, so
# `n` is declared reusable: `+n`.
def log2_go(w: Nat, +n: Nat) -> Nat:
  ?TODO

# TODO(policy): implement. `nat_log2(n)` is the floor of the base-two logarithm
# of `n`:
#
#   nat_log2(0n)  ==  0n
#   nat_log2(1n)  ==  0n
#   nat_log2(2n)  ==  1n
#   nat_log2(7n)  ==  2n
#   nat_log2(8n)  ==  3n
#
# The `0n` line is a decision rather than a discovery: every power of two is at
# least `1n`, so there is no exponent to report for zero and the task answers
# `0n`.
#
# The walk above is started with `n` itself as the width, which is always
# enough -- halving reaches `1n` within `n` steps for every `n` -- and it is a
# width the answer does not mention, so `nat_log2` is a function of `n` alone.
def nat_log2(+n: Nat) -> Nat:
  ?TODO
