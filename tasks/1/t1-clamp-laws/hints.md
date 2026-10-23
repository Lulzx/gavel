The reference is a cascade: match on `klo`; `True{}` answers `lo`, and
`False{}` matches on `khi`, answering `hi` for `True{}` and `x` for `False{}`.
Each decision is read once, as a scrutinee.

All three laws close by `{==}`, with no match and no rewrite in the proof:
each law supplies its decisions as literals (`khi` stays a variable in
`clamp_below`, but the first match never reaches it), so the cascade takes its
branch and both sides are the same term.
