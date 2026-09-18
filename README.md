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
uv run gavel list                         # tasks by tier
uv run gavel info t1-add-succ             # prompt, laws, stub
uv run gavel check t1-add-succ --reference
uv run gavel check t1-add-succ --solution my.bend --proof my-proof.bend
uv run gavel validate                     # V1-V5 over the whole bank
uv run gavel bench -n 10                  # check latency distribution
uv run python -m tools.mutate --check     # author mutants and see which are strong
uv run python -m tools.calibrate --dry-run
uv run python -m tools.sandbox_check      # prove the sandbox runs a real check
uv run python -m tools.migrate --from ~/.bend/app/2.0.4/rRKuW7 --label 2.0.4
```

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

Having both sides depend on the arguments is necessary but not sufficient. The
inductive law for a `Nat`-valued function does pin it:

```
law add_succ: for x: Nat  for y: Nat  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
```

but the same shape does not pin a container:

```
law append_cons: for x, xs, ys  {S.append(x <> xs, ys) == x <> S.append(xs, ys) : List<Nat>}
```

The projection `append(a, b) = a` satisfies that at tier 4 with `{==}`, because it maps
`x <> xs` to itself on both sides. What pins a container-valued function is putting the
**empty value on the left** — `append(Nil{}, ys) == ys` becomes `Nil{} == ys` under the
projection, which is false — not the right-hand form `append(xs, Nil{}) == xs`.

So the bank is built from pairs: **tier 1 = the inductive law alone where it pins, or a
base law and a cons law together where neither does on its own; tier 2 = a weak base law
plus the inductive law.**

The reliable test is mechanical, not a reading of the laws: **a law pins its function
only if no argument-ignoring body satisfies it.** `gavel/validate.py` V3 applies it by
crossing every degenerate solution with every degenerate proof — a projection or a
constant, paired with a `{==}` proof — and failing the task if any combination reaches
tier 4. Checking a bad solution against the *reference* proof would not have caught it:
that asks whether the reference proof is brittle, not whether the laws pin the function
down.

## Status

M0 — the core harness runs end to end against a hand-authored fixture. The task bank,
the adversarial corpus, and the multi-turn environment are in progress; see the
milestones in `PLAN.md`.
