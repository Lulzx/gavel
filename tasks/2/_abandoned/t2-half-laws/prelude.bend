import Base

# Immutable, and owned by the task rather than the policy. `half` is what the
# policy implements; the prelude is empty because the laws are stated about
# `half` alone. `half` steps two at a time, so it answers on `0n`, on `1n`, and
# on any larger odd number by dropping two and adding one.
