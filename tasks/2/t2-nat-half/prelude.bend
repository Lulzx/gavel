import Base

# Immutable, and owned by the task rather than the policy. It holds no helper
# defs: every law below is stated over the policy's own `half` and over
# `Nat.double`, which `Base` supplies. `Nat.double` is the encoder the
# round-trip laws are stated against, and it is `Base`'s rather than a copy here
# because its recursion is already the shape those laws need -- it steps two at
# a time, exactly as `half` does.
