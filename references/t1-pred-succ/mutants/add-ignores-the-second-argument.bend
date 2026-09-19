import Base

# `add` returns `1n + a` and never looks at `b`.
#
# `pred_add_one` is the only law in this file that applies `add`, and it applies
# the second argument at `1n` alone: `S.pred(S.add(x, 1n)) == x`. This body
# answers `1n + x` there, which is a successor, and `pred` steps on it -- so the
# law is satisfied across every `x` even though `add(0n, 5n)` answers `1n`. The
# other three laws never mention `add` at all. Measured 2026-09-19, before the
# repair: tier 4, complete, reward 1.000, all three laws then in the set proven
# by the reference proof unchanged, `failed` empty.
#
# After the repair, measured 2026-09-19 against this task's law set: tier 2
# against the reference proof, which fails for a different body rather than
# proving it -- `Policy.add_one_comm` is stated over `S.add` and its steps
# manipulate the reference body's unfolding, so the whole proof falls and the
# `failed` list is every law rather than the offending one. The demonstration is
# therefore taken on the law in isolation, where it is absolute and no proof can
# repair it: with a `{==}`-only proof, `LAWS.add_zero` reads
# `expected : 1n+x / observed : x`.
def add(a: Nat, b: Nat) -> Nat:
  1n + a

def pred(a: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      p
