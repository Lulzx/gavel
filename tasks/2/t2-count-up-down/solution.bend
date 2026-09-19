import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_up(n)` is the list `[0n, 1n, ..., n - 1n]`,
# counting up: `Nil{}` for nothing, and one more than `count_up(k)` with `k`
# appended at the end for `1n + k`. `k` is used twice -- once as the number the
# recursive call stops below and once as the element appended -- so the pattern
# marks it reusable.
def count_up(n: Nat) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. `count_down(n)` is the list `[n - 1n, ..., 1n, 0n]`,
# counting down: `Nil{}` for nothing, and `k` on the front of `count_down(k)`
# for `1n + k`. `k` is used twice here as well.
def count_down(n: Nat) -> List<&2, Nat>:
  ?TODO
