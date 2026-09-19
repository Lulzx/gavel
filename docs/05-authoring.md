# Authoring a task

Translating a module and inventing the laws is human or agent work.
Everything after that is a measurement, so it is a gate rather than a maxim.

`tools/author.py` runs the stages in order and refuses to carry a task past
one it has not passed:

```
files, derive, screens, mutants, V1-V5, episode, review, publish
```

The `screens` stage refuses the two shapes where nothing constrains a target
at all: a target named only inside a premise, and a target no law names. A
refusal there costs a two-line fix. The same defect found after a mutant
corpus has been written against it costs the corpus too.

## The review checkpoint

A tier-3 or higher task stops at `review`, and the pipeline cannot clear it.

A review record lives at `reviews/<task_id>.json`, outside both the task
directory and the reference directory. No tool in this repository opens a path
under `reviews/` for writing. `gavel/reviews.py` is a reader, and a test
asserts the writer does not exist. A record names its reviewer and carries the
hashes of `LAWS.bend` and `prelude.bend`, so editing either one leaves the
record pointing at laws the task no longer ships and reopens the checkpoint.

This replaced a worse shape. The record used to be a key inside `meta.json`,
written by a `--reviewer` flag, which meant the pipeline that published a task
was also able to attest that a person had read it. Eleven tasks were
registered that way by the agent that had just written them, and nothing in
the bytes distinguished those records from a person's.

Validation reads the same record independently. A tier-3+ task reads
`unreviewed`, `stale` or `current`, and both of the first two are warnings
that promote to failures under `--strict`. What no check can do is
authenticate the name in the file. The change removed the pipeline's ability
to create it, not a person's ability to hand-write one.

## Holding a task

A task directory carrying a `HOLD` file is on disk but not in the bank. A bare
`tools/publish` skips it, naming it explicitly is refused, and the only way to
register it is to delete the marker, so a hold cannot be lifted by a
command-line argument.
