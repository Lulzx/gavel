import Base

# TODO(policy): implement. Recurse on `b`: `0n` returns `1n`, and the step is
# `Nat.mul(a, pow(a, p))`. That step names `a` twice, and a binder is consumed
# on every use, so re-bind it reusable inside the step with `+x = a`.
def pow(a: Nat, b: Nat) -> Nat:
  ?TODO
