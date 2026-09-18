import Base
import ./prelude.bend as P

# The count is matched and then ignored: both branches answer the list, so
# `drop` is the identity. Rejected by `drop_succ`, whose left-hand side reduces
# to `h <> t` where its right-hand side is `drop(k, t)`, and by
# `drop_append_len`: at the cons step the body hands back `xs <> ys`, where the
# law wants `ys`.
def drop(n: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      xs
    case 1n+k:
      xs
