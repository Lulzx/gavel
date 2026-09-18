import Base

# Immutable, and owned by the task rather than the policy. `inc` is supplied
# here rather than being asked for, so that this task's laws pin `map` itself
# rather than delegating the element function to the policy.
def inc(x: Nat) -> Nat:
  x + 1n
