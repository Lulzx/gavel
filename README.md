# Gavel

An RL environment where the reward is a proof checker.

Each task is a small set of laws about a function. A policy writes the
function and a proof that the laws hold, and the [Bend](https://github.com/HigherOrderCO/Bend)
checker decides what it earned. There is no model in the reward path and no
learned verifier to game.

## Why this works

Most verifiable-reward setups fail on one of two things: the verifier is too
slow to sit inside a training loop, or the verifier can be satisfied by
something that is not a solution. Gavel's answer to each is simple.

1. **Speed.** Bend's checker is a small TypeScript program. A cold check of a
   two-law inductive proof takes well under a second, so a check can sit
   inside a training loop.
2. **Soundness.** A proof may only cite laws declared earlier in the file, so
   circular proofs are structurally impossible. And a law is only admitted to
   the bank once it has been shown, mechanically, that no wrong solution can
   satisfy it. Most of the engineering here is in that second half.

The failure modes worth worrying about are in the laws, not the checker.
A law like `add(x, 0) == x` is satisfied by `add(a, b) = a`, and it earns full
reward for a function nobody wrote. The bank exists to make that impossible,
and [the laws page](docs/04-laws.md) is the reasoning behind how.

## Quick start

```
uv sync
uv run gavel list                                   # tasks by tier
uv run gavel info t1-add-plus                       # prompt, laws, stub
uv run gavel check t1-add-plus --reference          # the reference earns 1.0
uv run gavel check t1-add-plus --solution my.bend --proof my-proof.bend
```

```python
from gavel.env import Action, GavelEnv

env = GavelEnv.from_manifest("manifest.json", mode="dense", max_turns=4)
obs = env.reset("t1-add-plus")
obs, reward, done, verdict = env.step(
    Action(files={"solution.bend": ..., "PROOF.bend": ...}))
env.close()
```

## Reward

| tier | meaning | reward |
|------|---------|--------|
| 0 | rejected by the gate | 0.0 |
| 1 | does not type-check | 0.0 |
| 2 | solution checks, no law proven | 0.1 |
| 3 | some laws proven | 0.1 + 0.5 * proven/total |
| 4 | every law proven | 1.0 |

Details in [reward](docs/03-reward.md).

## Layout

```
gavel/          the harness: gate, runner, check protocol, reward, env, cache, server
toolchain/      the vendored, pinned checker
tasks/<tier>/   task definitions: prompt, LAWS.bend, prelude.bend, stub
references/     hidden reference solutions, proofs and mutants
tools/          offline authoring tools, none of which run in the reward path
tests/          the suite, including the adversarial corpus
docs/           the pages indexed below
```

`SPEC.md` is the design. `PLAN.md` is the build log, including every place a
measurement of the real checker forced a departure from the spec.

## Docs

1. [The checker as a reward](docs/01-checker.md). The two measured properties that shape the harness.
2. [Pinning](docs/02-pinning.md). Why the `bend` on your PATH is not usable, and what is.
3. [Reward](docs/03-reward.md). Tiers, partial credit and the multi-turn rule.
4. [What makes a law worth training on](docs/04-laws.md). The failure mode that matters, and the test for it.
5. [Authoring a task](docs/05-authoring.md). The pipeline, and the review checkpoint only a person can clear.
6. [Running episodes](docs/06-episodes.md). The env, the cache, the log and the soak.
7. [Isolation](docs/07-isolation.md). What a verdict says about the process that produced it.
8. [Commands](docs/08-commands.md). Every entry point, in one place.

## Status

The harness runs end to end and has been soaked for ten thousand episodes.
The bank holds 239 tasks across five tiers. What it still owes is in
`PLAN.md`, and the largest item is a human reading of every tier-3+ law set.
