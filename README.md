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
gavel/          the harness — gate, runner, check protocol, reward, environment
toolchain/      the vendored, pinned Bend checker (see toolchain/fetch.py)
tasks/<tier>/   task definitions: prompt, LAWS.bend, prelude.bend, stub
references/     hidden reference solutions, proofs, and mutants
tools/          offline authoring tools; none of these run in the reward path
tests/          test suite, including the adversarial corpus
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
uv run gavel list                         # tasks by tier
uv run gavel info t1-add-zero             # prompt, laws, stub
uv run gavel check t1-add-zero --reference
uv run gavel check t1-add-zero --solution my.bend --proof my-proof.bend
uv run gavel validate                     # V1/V4/V5 over the whole bank
uv run gavel bench -n 10                  # check latency distribution
```

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

## Status

M0 — the core harness runs end to end against a hand-authored fixture. The task bank,
the adversarial corpus, and the multi-turn environment are in progress; see the
milestones in `PLAN.md`.
