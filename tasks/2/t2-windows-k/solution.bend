import Base
import ./prelude.bend as P

# TODO(policy): implement. `windows_go(ys, k, xs)` is the loop: `ys` has one
# element per window still to emit, and each step emits the window of length `k`
# that starts at the front of `xs`, then continues one element along `xs` and one
# window along `ys`. When `ys` runs out there are no windows left. `xs` and `k`
# are declared `+` because the loop names each of them twice.
def windows_go(ys: List<&2, Nat>, +k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  ?TODO

# TODO(policy): implement. `windows(k, xs)` returns every consecutive sublist of
# `xs` of length `k`, in order. There are none when `k` is `0n`; otherwise the
# loop above, started at the pointer the prelude's `lookahead` computes.
def windows(+k: Nat, +xs: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  ?TODO
