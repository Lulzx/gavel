# Gavel

A verifiable-reward RL environment in which the [Bend](https://github.com/HigherOrderCO/Bend)
proof checker is the sole reward signal. Each task pairs a fixed set of laws with a
policy-written solution and proof; the checker decides the reward. There is no model
in the reward path and no learned verifier to reward-hack.

`SPEC.md` is the design. `PLAN.md` is the build plan, including the places where
measurement of the real checker forced a departure from the spec.

## Why the checker can be the reward

Bend's checker is a small, dependency-free TypeScript program driven by bun. A cold
check of a two-law inductive proof completes in well under a second, which is the
property that makes an RL loop possible at all — a Lean-based version of this would
spend its budget waiting.

Two consequences of how the checker is built shape everything else:

- **Only the first type error is reported.** One run cannot say which laws passed, so
  per-law partial credit is attributed by a fixed-point loop of isolation runs
  (`gavel/check.py`).
- **A proof may only cite laws declared earlier in the file.** `book_valid` registers
  each definition into the namespace *after* checking it, so circular and backward
  references are structurally impossible. A full proof that passes is therefore sound
  on its own; the isolation runs only ever *attribute* credit that the full run
  already earned.

## Layout

```
gavel/          the harness — gate, runner, check protocol, reward, environment,
                verdict cache, episode log, metrics, socket server
toolchain/      the vendored, pinned Bend checker (see toolchain/fetch.py)
tasks/<tier>/   task definitions: prompt, LAWS.bend, prelude.bend, stub
references/     hidden reference solutions, proofs, and mutants
tools/          offline authoring tools; none of these run in the reward path
examples/       client in another stack (TypeScript, on the pinned bun)
tests/          test suite, including the adversarial corpus
Dockerfile      the Linux environment, with bubblewrap, for the sandboxed run
```

## Pinning

The `bend` on `PATH` is a launcher that contacts a hub and self-updates — it moved
from 2.0.4 to 2.0.5 while this project was being started. It is not usable as a
reward signal. Gavel vendors the real checker (`bend2/`) at a fixed version, records
the SHA-256 of the vendored tree, pins the bun version, and invokes
`bun bend2/main.ts` directly. `gavel.toolchain.Toolchain.load` refuses to run if
either pin has drifted.

## Usage

```
uv run python -m tools.publish            # derive metadata, rebuild manifest.json
uv run python -m tools.author tasks/2/t2-thing   # the authoring stages, in order
uv run gavel list                         # tasks by tier
uv run gavel info t1-add-plus             # prompt, laws, stub
uv run gavel check t1-add-plus --reference
uv run gavel check t1-add-plus --solution my.bend --proof my-proof.bend
uv run gavel validate                     # V1-V5 over the whole bank
uv run gavel bench -n 10                  # check latency distribution
uv run python -m tools.mutate --check     # author mutants and see which are strong
uv run python -m tools.calibrate --dry-run
uv run python -m tools.sandbox_check      # prove the sandbox runs a real check
uv run python -m tools.migrate --from ~/.bend/app/2.0.4/rRKuW7 --label 2.0.4
uv run python -m tools.soak -n 10000 -j 8 --out runs/soak   # unattended
uv run gavel serve --socket /tmp/gavel.sock --http 127.0.0.1:8765
bun run examples/client.ts                # a non-Python client
```

## Authoring a task

`tools/author.py` runs the stages in `PLAN.md` §M2 in order — files, derive,
V1–V5, episode, review, publish — and refuses to carry a task past one it has
not passed. Translating a module and inventing the laws stay human (or agent)
work; everything after that is a measurement, so it is a gate rather than a
maxim. A tier ≥ 3 task stops for a named reviewer, and the approval is recorded
against the hashes of `LAWS.bend` and `prelude.bend`, so editing either reopens
the checkpoint.

Validation reports the same record independently: a tier ≥ 3 task reads
`unreviewed`, `stale` or `current`, and `tools/validate.py` prints the stale
and unreviewed task ids under its summary. Both are warnings, so they promote
under `--strict` rather than reddening the bank now — `stale` is about the
evidence attached to a task and not about the reward function. What neither
check can do is authenticate the name in the record: a record written by a
person and one written by whoever ran `--reviewer` are the same bytes.

## Running episodes

```python
from gavel.cache import VerdictCache
from gavel.env import Action, GavelEnv
from gavel.trajectory import Trajectory

env = GavelEnv.from_manifest("manifest.json", mode="dense", max_turns=4,
                             cache=VerdictCache("cache.sqlite"),
                             trajectory=Trajectory("runs/trajectory.jsonl"))
obs = env.reset("t1-add-plus")
obs, reward, done, info = env.step(Action(files={"solution.bend": ..., "PROOF.bend": ...}))
env.close()          # ends any open episode, flushes the log
env.metrics.write("runs/metrics.json")
```

`tools/soak.py` drives that loop unattended, with a scripted policy standing in
for a model so that what the run exercises is the harness. Each episode's task
and script come from `Random(seed + index)`, so the same seed produces the same
ten thousand episodes at any `--jobs` — a soak whose contents depend on how it
was parallelised cannot be compared to a re-run of itself. `--policy noisy`
(the default) marks each submission so no two are byte-identical and the
latency percentiles are the checker's; `--policy scripted` re-sends identical
bytes and measures the cache instead. At the end it reads its own log back and
checks it against the report the run produced while it was happening.

`info` is the full `Verdict`. The cache is keyed on everything a verdict is a
function of — the task's bytes, the mutant corpus, the toolchain, the backend,
the limits, and the submission — so a hit is the verdict a fresh run would have
produced, and `verdict.cached` says it was reused. The log is one JSON object
per episode; a half-written final line is skipped rather than fatal. Metrics
are derived from the same records the log holds, so a run watched live and the
same run read back afterwards cannot disagree.

## Isolation

Every check is a subprocess with a scrubbed environment, rlimits and a wall
clock. On Linux it is wrapped in bubblewrap: `--unshare-all`, the whole root
bound read-only with the check's own directory bound back over it, no network.
Every verdict names the backend it ran under and whether that backend is a
security boundary, because a reward is only as trustworthy as the process that
produced it.

`auto` picks the strongest backend the machine can run, and **fails rather than
downgrades** — a silent fallback would produce a verdict that looks sandboxed in
every field except the one nobody reads. A job that is not about isolation
(macOS development, a lint job) opts out once with `GAVEL_BACKEND=plain`, and
the verdicts it produces carry `dev_only: true`. `Dockerfile` and the CI
`sandbox` job run the adversarial corpus under the real thing.

`tools/validate.py` and `tools/mutate.py` exit non-zero on failure, so they can gate a
merge. `tools/calibrate.py --dry-run` prints a prompt without spending anything;
without `--dry-run` it measures zero-shot solve rate against a model.

## Reward tiers

| tier | meaning | reward |
|------|---------|--------|
| 0 | gate failure — a forbidden construct or a modified law file | 0.0 |
| 1 | does not type-check | 0.0 |
| 2 | solution checks, no law proven | 0.1 |
| 3 | a strict subset of the laws proven | 0.1 + 0.5·proven/total |
| 4 | every law proven | 1.0 |

Tier 2 exists so that a policy which produces well-typed but unproven code gets a
non-zero step rather than an all-or-nothing cliff.

## What makes a law worth training on

A task is only as good as its laws, and the obvious way to write a law is wrong. A
law whose right-hand side is a constant or a bare variable does not determine the
function it is about. On `t1-add-zero` — `law add_zero: for x: Nat {S.add(x, 0n) == x : Nat}`
— this submission earns full reward:

```
def add(a: Nat, b: Nat) -> Nat:
  a

def L.add_zero(x):
  {==}
```

The projection `add(a, b) = a` satisfies the law definitionally, so `{==}` proves it.
The checker agrees: exit 0, `All terms check.` The same applies to a base-case law
(`f(0n) == 0n` is satisfied by `f = 0n`) and to any right-identity law
(`f(x, e) == x` is satisfied by `f(a, b) = a`). `t1-add-zero` was written that way
and has been retired.

Having both sides depend on the arguments is neither necessary nor sufficient, and the
counterexample is the bank's own first task. This law was written for it:

```
law add_succ: for x: Nat  for y: Nat  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
```

Both sides depend on both arguments, and it pins nothing: `add(a, b) = b` satisfies it,
because the goal becomes `1n+y == 1n+y`. That submission was measured at tier 4, reward
1.000, for a function nobody had implemented.

The reason generalizes, which is why the *shape* is worth recognising rather than the
task. A single equation cannot pin a two-argument function whose arguments share a type.
The law survives the projection `add(a, b) = b` whenever the substitution makes the two
sides equal — and it does whenever both applications of `add` receive the same term in
the position `b` occupies. `add(x, 1n+y)` and `add(x, y)` both take `x` first, so they
collapse to `1n+y` and `y`, which the `1n +` on the right relates. The projection onto
`a` satisfies it for the same reason. One law, two escaping projections.

What does pin `add` in one law is putting a term that never mentions `add` on the right,
which is what the task now carries and why it is now called `t1-add-plus`:

```
law add_plus: for x: Nat  for y: Nat  {S.add(x, y) == x + y : Nat}
```

Under `add(a, b) = b` the goal is `y == x + y`, which is false; under `add(a, b) = a` it
is `x == x + y`, also false. That shape does not carry over to a container, though,
because there the projection is a homomorphism:

```
law append_cons: for x, xs, ys  {S.append(x <> xs, ys) == x <> S.append(xs, ys) : List<Nat>}
```

The projection `append(a, b) = a` satisfies that at tier 4 with `{==}`, because it maps
`x <> xs` to itself on both sides. What pins a container-valued function is putting the
**empty value on the left** — `append(Nil{}, ys) == ys` becomes `Nil{} == ys` under the
projection, which is false — not the right-hand form `append(xs, Nil{}) == xs`.

So the bank is built two ways: **tier 1 = one law whose right-hand side never mentions
the function, or a base law and a cons law together where neither pins on its own; tier 2
= a weak base law plus the inductive law.**

The reliable test is mechanical, not a reading of the laws: **a law pins its function
only if no argument-ignoring body satisfies it.** Checking a bad solution against the
*reference* proof would not have caught it — that asks whether the reference proof is
brittle, not whether the laws pin the function down.

**A pair of laws can pin at most two functions**, and a single law pins neither argument
of a two-argument function unless one side avoids mentioning it. Three things make the
sweep easy to get wrong, all of them measured here. It must be run against a `{==}`-only
proof, or it is a question about the reference proof's reach rather than about the laws.
It must try **every** same-typed parameter, not the first: `V3` originally built its
identity solution from `_ignore_arguments`, which returns the first, so it projected the
task then called `t1-add-succ` onto `a` and never tried `add(a, b) = b`. And it must
include the body that
uses a parameter twice — `mul(a, b) = b + b` satisfies `mul_two` and nothing in the other
two families does.

The corpus now covers all three: a `vary-*` family degenerates one function at a time
with the rest of the file left at the reference, in the projecting, doubling and zero
forms, beside the whole-solution cross product.

## Status

The core harness runs end to end: gate, check protocol, reward, multi-turn environment,
verdict cache, JSONL trajectories, metrics, and a socket/HTTP server for non-Python
clients. `gavel bench` reports check latency; see `PLAN.md` for what each milestone
still owes.
