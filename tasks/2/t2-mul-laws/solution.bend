import Base

# TODO(policy): implement both. `add` recurses on `a`, and `mul` recurses on
# `a` too, adding `b` once per step. Keep the `+b` quantity on `mul`'s second
# parameter exactly as written: both laws need to name `b` more than once.
def add(a: Nat, b: Nat) -> Nat:
  ?TODO

def mul(a: Nat, +b: Nat) -> Nat:
  ?TODO
