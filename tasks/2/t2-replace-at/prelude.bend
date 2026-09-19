import Base

# Immutable, and owned by the task rather than the policy. This task's laws
# speak in `List<Nat>` terms only -- every helper `replace_at` could want is a
# `match` on its own count and list -- so there is nothing to add here.
