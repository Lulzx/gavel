# Authoring a task

Translating a module and inventing the laws is human or agent work.
Everything after that is a measurement, so it is a gate rather than a maxim.

`tools/author.py` runs the stages in order and refuses to carry a task past
one it has not passed:

```
files, derive, screens, mutants, V1-V6, episode, review, publish
```

The `screens` stage refuses the two shapes where nothing constrains a target
at all: a target named only inside a premise, and a target no law names. A
refusal there costs a two-line fix. The same defect found after a mutant
corpus has been written against it costs the corpus too.

## The problem statement

A task's text is three files with three readers:

- `tasks/PRIMER.md`, shared by every task: the file layout, the naming rules,
  and how the checker reads a proof. Every observation carries it.
- `prompt.md`, the specification: what each target computes, with worked
  examples, and each law in words. It is all a policy is shown by default.
- `hints.md`, how the reference was written and proved. An observation carries
  it only when the env is built with `hints=True`, so a guided run is a
  setting and not a property of how much a prompt gave away.

The prompts used to be all three at once, and the same paragraphs on Lone
variables and rewrite direction were written out in dozens of them. Validation
holds `prompt.md` to a contract (`_prompt_contract` in `gavel/validate.py`):
every law named, any stated law count right, no line of the reference body, and
none of the words a proof is described in. Before the split, 16 prompts stated
the wrong number of laws, 36 quoted the reference body, and about 10 never
named one of their laws. `tools/prompts.py check` also evaluates every worked
example (`    f(args) == value`) against the reference. The law file and the
stub are shown without their comments, which are the author's notes.

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
