import Base

# Immutable, and owned by the task rather than the policy. Both functions this
# task asks for are written over `Nat` and `List<&2, Nat>`, so the laws need no
# vocabulary here: the prelude is the import and this note.
#
# `List<&2, Nat>` rather than `List<Nat>` is what lets a law or a helper read a
# destructured tail twice, which the walk's reset step does.
