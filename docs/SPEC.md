# Gavel — Technical Specification

**Version:** 0.2
**Status:** As built. Revised 2026-09-20 against the harness in `gavel/`, the
tools in `tools/` and a bank of 239 tasks.
**Summary:** A verifiable-reward reinforcement-learning environment in which a
policy model writes Bend code and proofs against fixed laws, and reward is
issued by the Bend proof checker.

This document describes the system that exists. The 0.1 draft it replaces was
a design written before the checker had been measured; every place a
measurement forced a departure is recorded in `PLAN.md` §1, and the section
numbers here are unchanged so that the citations in `PLAN.md` and in the
source (`SPEC.md 8`, `SPEC.md 5.5`, and so on) still resolve.

---

## 1. Thesis

Post-training for coding and reasoning models needs rewards that cannot be gamed. Unit tests can be overfit; human graders are slow and inconsistent; proof checkers are the only reward signal that is both automatic and unforgeable. Today "proof-checked reward" means Lean, which has two costs for RL: checking a file can take seconds to minutes, capping rollouts per GPU-hour, and the language is far from the code models are trained on.

Bend 2 changes both terms. Its type checker is a proof checker that runs in well under a second on files of the size an episode produces, and its surface syntax is Python with dependent types. Its `law` construct is a first-class specification: a `def` whose type is the law's proposition is a proof, and the checker decides whether it is one.

Gavel packages this into an environment: a bank of tasks, each with a natural-language prompt and a `LAWS.bend` file; a harness that runs episodes and calls the checker; a verifier gate that closes reward-hacking paths; and a curriculum. Every property of Bend that is a liability for products (verbose annotations, no tactics, terse errors, hand-written proofs) is neutral or beneficial for an environment, because the model does the work and the checker is the judge.

The thesis held. What the build found is that the checker is the easy half: the failure modes that matter are in the laws, and most of the engineering is in showing, mechanically, that no wrong solution satisfies a law before it is admitted to the bank (§7.4, §7.5, §11).

## 2. Goals and non-goals

### Goals

- **G1.** Reward is decided solely by the Bend checker on an unmodified `LAWS.bend`. No test cases, no LLM judges in the reward path. *Met: nothing in `gavel/` calls a model, and `tools/calibrate.py`, which does, runs offline and writes metadata only.*
- **G2.** Median reward latency under one second per episode on a single CPU core, excluding model inference. *Met: 907 ms of checker CPU per verdict measured over 10,012 fresh verdicts; the last ten-thousand-episode soak reported a p99 wall of 524 ms.*
- **G3.** A task bank of at least 500 validated tasks across five difficulty tiers by v1.0, each with a hidden reference solution and proof. *Partly met: 239 tasks, every tier populated, 236 at tiers 1–4. The remainder is volume; see §16.*
- **G4.** A verifier gate such that no known construct (unsafe annotations, axioms, law edits, vacuous laws) yields reward without a genuine proof. *Met for the adversarial corpus in `tests/adversarial/`, run under the Linux sandbox from the `Dockerfile` image. One bypass outside that corpus, an empty proof file, paid full reward until 2026-09-20; see §7.3.*
- **G5.** A stable gym-style API usable from any RL framework without Bend knowledge on the caller side. *Met: `gavel.env.GavelEnv` in process, `gavel serve` over a Unix socket or loopback HTTP, and a TypeScript client in `examples/`.*
- **G6.** Reproducible builds: every task, reward, and trajectory is tied to a pinned Bend version and task-bank hash. *Met: the toolchain is vendored and hashed, the bank hash and toolchain hash travel in every verdict and every trajectory record.*

### Non-goals

- Teaching Bend to humans; documentation targets the harness, not the language.
- Proving properties of floating-point code (F32 is axiomatic in Bend).
- Multi-agent or tool-augmented episodes in v1 (the policy sees only the checker's output).
- Running episodes on the GPU. Bend's GPU target is irrelevant to checking.
- A persistent checker worker. The 0.1 draft planned one for M3; measurement showed bun startup is not the cost that binds, and it was not built.

## 3. Terminology

| Term | Meaning |
|---|---|
| **Task** | A directory containing a prompt, a `LAWS.bend`, an immutable `prelude.bend`, a `solution.bend` stub, and metadata; plus a hidden reference directory. |
| **Law** | A `law` declaration in `LAWS.bend`: a typed proposition over the implementation. |
| **Proof** | A `def L.<law>` whose type matches the law and which the checker accepts. |
| **Policy target** | A function the policy must implement; a `def` in the stub whose body is `?TODO`. |
| **Episode** | One attempt at a task: the policy submits an implementation and proofs; Gavel returns reward. |
| **Turn** | One submission within an episode. Episodes may be single- or multi-turn. |
| **Verifier gate** | Static checks applied to a submission before the checker runs, plus the mutant tripwire applied after. |
| **Verdict** | The structured result of a turn: reward tier, laws proven and failed, every checker run, gate findings, and the hashes that identify what was checked. |
| **Reference** | The hidden solution and proof that certify a task is solvable. |
| **Mutant** | A wrong solution shipped with a task; its laws must reject it. |
| **Review record** | A file under `reviews/` that says a person read a tier-3+ task's laws. No tool writes one. |

## 4. Architecture

```
                 ┌────────────────────────────────────────────────────┐
                 │                    Task Bank                       │
                 │  tasks/<tier>/<id>/{prompt.md, LAWS.bend,          │
                 │        prelude.bend, solution.bend, meta.json}     │
                 │  references/<id>/{solution.bend, PROOF.bend,       │
                 │        mutants/}          manifest.json            │
                 └───────────────────────┬────────────────────────────┘
                                         │ load by manifest
┌──────────────┐   reset/step   ┌────────▼────────┐    submit    ┌──────────────┐
│  RL trainer  │◄──────────────►│     Harness     │─────────────►│ Verifier gate│
│ (any stack)  │  obs / reward  │ GavelEnv, serve │◄─────────────│  gate.py     │
└──────────────┘                └────────┬────────┘   findings   └──────┬───────┘
                                         │ check.py                     │
                                ┌────────▼────────┐             ┌───────▼───────┐
                                │     Runner      │────────────►│ Bend checker  │
                                │ bwrap | plain   │  stdout,    │ bun main.ts   │
                                │ scrubbed env    │  exit, ms   │ (vendored)    │
                                └─────────────────┘             └───────────────┘
```

Components, each one module or one directory:

1. **Task bank** — a content-addressed directory tree and a manifest. See §5, §13.2.
2. **Harness** — `gavel/env.py` exposes `reset`, `step`, `close`; `gavel/server.py` wraps the same handler for other stacks. See §6.
3. **Verifier gate** — `gavel/gate.py`, a token-level scan over the submission, and the mutant tripwire in `gavel/check.py`. See §7.
4. **Runner** — `gavel/runner.py` runs the vendored checker as one subprocess under a backend that names itself in the verdict. See §9.
5. **Check protocol** — `gavel/check.py` turns one submission into a verdict by a full run and then per-law isolation runs. See §7.3.
6. **Reward function** — `gavel/reward.py`, a pure function from gate result and proven count to a tier and a scalar. See §8.
7. **Authoring pipeline** — `tools/`, offline, none of it in the reward path. See §11.

## 5. Task format

### 5.1 Directory layout

```
tasks/<tier>/<task_id>/
  prompt.md          # natural-language task statement shown to the policy
  LAWS.bend          # laws; immutable during episodes; hashed in meta.json
  prelude.bend       # immutable predicates and helpers the laws refer to; hashed
  solution.bend      # signatures of the policy targets with ?TODO bodies;
                     #   the policy replaces this file
  meta.json          # derived metadata; rewritten by tools/publish.py
references/<task_id>/
  solution.bend      # hidden reference implementation
  PROOF.bend         # hidden reference proofs of every law
  mutants/           # hidden wrong solutions; each must fail at least one law
reviews/<task_id>.json   # a person's review record, tier >= 3 only; see §11
```

The 0.1 draft had one `stub.bend` holding both the immutable helpers and the
holes, with integrity checked as a region diff. It is split because the two
halves have different owners: `prelude.bend` is the task's and is hashed;
`solution.bend` is the policy's and is replaced whole. Integrity is then a
file hash rather than a diff.

The reference directory lives beside the bank rather than inside the task so
that materialising an episode's working directory is a copy of the task
directory and nothing else. A task directory carrying a `HOLD` file is on disk
but not in the bank; see §11.

### 5.2 `LAWS.bend`

A law is written in Bend's law syntax over the task's own imports. Example
(`t3-tree-flatten`, abridged):

```
import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the leaves, left to right, at each constructor.
law flatten_leaf:
  for v: Nat
  {S.flatten(P.Leaf{v}) == v <> Nil{} : List<&2, Nat>}

law flatten_node:
  for l: P.Tree
  for r: P.Tree
  {S.flatten(P.Node{l, r}) == P.append(S.flatten(l), S.flatten(r)) : List<&2, Nat>}

# LAW: the flattened list has one element per leaf.
law flatten_leaves:
  for +t: P.Tree
  {P.len(S.flatten(t)) == P.leaves(t) : Nat}

# LAW: flattening a mirror is reversing a flattening. This is the law that pins the order.
law flatten_mirror:
  for +t: P.Tree
  {S.flatten(P.mirror(t)) == P.rev(S.flatten(t)) : List<&2, Nat>}
```

Rules:

- Laws reference the policy's functions as `S.<name>`, the task's helpers as `P.<name>`, and `Base`. Nothing else is importable (V5).
- Every predicate and helper a law uses is defined in `prelude.bend`, never by the policy. A law whose predicate the policy can redefine is not a law.
- Every policy target is named by at least one law, and at least one law per target has an absolute anchor (a side that does not mention the target). A law set that fails either is refused at authoring time (§11, the `screens` stage).
- Every law is non-vacuous in the measured sense of §7.4: the task ships mutants and a degenerate corpus, and the laws reject all of them.
- A `# LAW:` comment above each law states what it pins and, for tier 3+, why the other laws cannot see it. The comment is part of the file and therefore of the hash.

### 5.3 `solution.bend`

Declares the signatures the policy must satisfy. Every body is the hole
`?TODO`, which is the syntax the pinned checker recognises; the harness refuses
a hole in a credited proof (§7.3) and a stub that ships its reference is caught
by the authoring screens.

```
import Base
import ./prelude.bend as P

# TODO(policy): the leaf values of a tree, left to right.
def flatten(t: P.Tree) -> List<&2, Nat>:
  ?TODO
```

The policy replaces this file. It may add helpers under the `Policy.` prefix
and nothing else (§7.1). Helpers the reference relies on that the policy is
not meant to write are in `prelude.bend`; helpers the policy is forced to
write are declared in the stub as further `?TODO` targets.

### 5.4 `meta.json`

Derived by `tools/publish.py` from the task's files; never edited by hand.

```json
{
  "task_id": "t1-add-plus",
  "tier": 1,
  "title": "S.add(x, y) == x + y",
  "difficulty_weight": 1.0,
  "source": {"benchmark": "custom", "origin": "Bend guide, laws section"},
  "tags": ["nat", "induction", "reflection"],
  "laws": ["add_plus"],
  "policy_targets": ["add"],
  "prelude_defs": [],
  "proof_header": "import Base\nimport ./prelude.bend as P\nimport ./solution.bend as S\nimport ./LAWS.bend as L\n",
  "hashes": {"laws": "<sha256>", "prelude": "<sha256>"},
  "bend_version": "2.0.5"
}
```

`proof_header` is the exact import block a `PROOF.bend` must begin with; it is
in the observation so the policy is not guessing module names. `hashes` are
gate-enforced against the working directory on every submission (§7.1).
`zero_shot_solve_rate` and `reference_check_ms` from the 0.1 draft are not in
the file: the first is a calibration measurement that no task in the bank yet
carries, and the second is measured by validation rather than stored.

### 5.5 Task validity invariants

A task is valid if and only if `gavel/validate.py` reports no problem:

- **Before V1.** The prompt is non-empty, since a task with no prompt is still a perfectly good reward function and a policy is shown nothing; and every `S.<f>` a law cites is a policy target the stub asks for. Both are properties of the files and are checked before any checker run.
- **V1.** `references/<id>/solution.bend` + `PROOF.bend` + `LAWS.bend` type-check under the pinned toolchain, and the reference earns tier 4.
- **V2.** For every mutant in `references/<id>/mutants/`, the reference proof fails to check against it, and at least one mutant exists. This is *proof incompatibility*: it shows the reference proof does not transfer, not that no proof exists. A law's kill count is the number of mutants whose failure was attributed to it. The stronger claim, that a mutant admits no proof at all, is made only where an author probed for one and found none. A mutant that does not type-check is recorded as *weak*, not as a kill.
- **V3.** No submission from the degenerate corpus (§7.5), checked against a `{==}`-only proof, proves every law, and none is rejected by the gate (a gate rejection means V3 tested nothing).
- **V4.** The reference's slowest checker run takes ≤ 2000 ms.
- **V5.** No forbidden construct (§7.2) appears in `LAWS.bend`, `prelude.bend`, or the reference, and the immutable files import only `Base` and each other.

Validation also reports, as warnings rather than problems: a law that no
mutant kills, a tier-3+ task whose review record is missing (`unreviewed`) or
points at other laws (`stale`), and a task with no calibration record.
`--strict` promotes warnings to problems. Validity is re-run on every
toolchain change (§14); failing tasks are quarantined, not deleted.

## 6. Episode protocol

### 6.1 API

Gym-style, transport-agnostic.

```
reset(task_id | None)  -> Observation          # None draws from the sampler
step(Action)           -> (Observation, reward: float, done: bool, info: Verdict)
close()
```

In process: `gavel.env.GavelEnv.from_manifest("manifest.json", mode=..., max_turns=...)`.
Over a socket: `gavel serve` speaks JSON lines with `op` in
`{health, reset, step, close}` and a `session` id, on a Unix socket or
loopback HTTP; `examples/client.ts` is a client that knows nothing about Bend.

### 6.2 Observation

```json
{
  "task_id": "t3-tree-flatten",
  "tier": 3,
  "title": "...",
  "prompt": "<contents of prompt.md>",
  "laws": "<contents of LAWS.bend>",
  "stub": "<contents of solution.bend>",
  "prelude": "<contents of prelude.bend>",
  "proof_header": "import Base\nimport ./prelude.bend as P\n...",
  "policy_targets": ["flatten"],
  "turn": 1,
  "max_turns": 4,
  "feedback": null
}
```

On subsequent turns `feedback` carries the gate findings, if any, and the
checker's own error block from the previous submission, truncated to
`feedback_bytes` (default 2048). Bend's terse messages are passed through
unmodified; they are the training signal for repair.

### 6.3 Action

```json
{
  "files": {
    "solution.bend": "<implementation of policy_targets>",
    "PROOF.bend": "<proof_header, then one def L.<law> per law>"
  }
}
```

Exactly these two files. A submission naming `LAWS.bend`, `prelude.bend` or
any other file is rejected at tier 0 (§7.1).

### 6.4 Multi-turn semantics

- `max_turns` is set at env construction (default 4). An episode ends on a tier-4 verdict or when turns are exhausted.
- `dense` mode pays each turn the improvement of its reward over the best turn so far, so repair is rewarded and regression is not. `sparse` mode pays nothing until a turn solves the task, and then pays that turn's reward; an episode that never solves pays nothing.
- Turns are independent submissions; no state carries over except feedback text.
- A verdict that is a cache hit (§9) is marked `cached: true` and paid normally.

## 7. Verifier gate

The gate exists because a proof checker is only as trustworthy as the surface it checks. Reward hacking against Gavel means getting the checker to accept without proving the law. Each closed path below corresponds to a known or measured attack, and `tests/adversarial/` holds one file per path.

### 7.1 File integrity

- The submission's file set must be exactly `{solution.bend, PROOF.bend}`. Findings: `immutable-file`, `unknown-file`, `missing-file`.
- After the submission is written into the working directory, `LAWS.bend` and `prelude.bend` are hashed and must equal `meta.json`. Finding: `integrity`.
- Top-level names in `solution.bend` must be the policy targets or `Policy.*` helpers; top-level names in `PROOF.bend` must be `L.<law>` for a declared law or `Policy.*`. Any name colliding with the prelude, the laws or `Base` is a finding (`name`, `def`). The check is syntactic and runs before the checker; Bend's own namespace rules are the layer behind it.
- `PROOF.bend` must import `./LAWS.bend`, under any alias (`no-laws-import`). A proof file that does not open the laws cannot discharge them, and since `LAWS.bend` is what imports `solution.bend`, it does not check the implementation either. An empty proof file read tier 4 until this rule existed.
- Each file is at most 64 KiB (`size`).

### 7.2 Forbidden constructs

The gate rejects on the token stream of each submitted file, so a construct inside a string or comment is not mistaken for the real thing and a real one cannot hide behind spacing:

| Construct | Finding | Reason |
|---|---|---|
| `@unsafe` | `unsafe` | Switches off the termination checker; the checker exits 0 with a warning instead of the success line. |
| `law` | `law` | Changes the spec. |
| `main` | `main` | Its output replaces the success line; a file with `main` exits 0 having proven nothing. |
| `import "<string>"` | `foreign-import` | Foreign code. |
| `import 0x...` | `hub-import` | Fetches from the hub. |
| any other `import` than `Base` and the four task files | `import` | Smuggled definitions. |
| a file the lexer cannot read | `unparsable` | Refused at tier 0 rather than raised out of the gate. |

There is no axiom or postulate form in Bend 2 and no compile-time template; the draft's rows for them have nothing to match. `?TODO` in a credited proof is not a gate finding because the check protocol already refuses it (§7.3).

### 7.3 Checker invocation and the check protocol

A "run" is `bun <toolchain>/bend2/main.ts <file>` in a fresh directory holding only the four task files, under the backend of §9. A run is **ok** iff it exits 0, its stdout is exactly `All terms check.`, no `annotated as unsafe` line appears, and it did not time out. Exit code alone is not the signal: two constructs exit 0 without proving anything (§7.2).

The checker reports only the first type error, so one run cannot say which laws passed. A verdict is therefore produced by `gavel/check.py` in stages:

1. **Gate.** Any finding is tier 0; nothing runs.
2. **Full run** of the submitted `PROOF.bend`. Ok means tier 4 only if the file imported the laws and defines a proof for every one of them; a file that checks without having opened the laws proved nothing, and falls through. This is the second layer under the gate's `no-laws-import`, and the one that held the three payloads when the gate was waved through in test.
3. **Solution run** of `solution.bend` alone with the prelude. Failure means tier 1.
4. **Per-law isolation, to a fixed point.** For each uncredited law, write a proof file holding the header, the proofs of every credited law, and this law's proof; run it; credit the law iff the run leaves exactly the uncredited laws open (`Error: K TODOs found.` with K equal to their count, or the success line when K is 0). Repeat until a pass credits nothing. Tier 2 if nothing was credited, tier 3 if a strict subset.

Step 4 is sound because a proof may cite only laws declared earlier in the file and already checked: a proof that leans on an uncredited law fails, cycles get no credit, and a proof with an internal hole inflates K and is never credited. The isolation runs attribute credit; they cannot grant credit the full run could not have earned. Worst case n² runs for n laws, typical n+2, and a hard cap of 64 runs per verdict.

Limits per run: 10 s wall, 30 s CPU, 2 GiB address space, 64 KiB of output. A timeout is a failed run and is recorded as such in the verdict.

### 7.4 Non-vacuity and mutation testing

A law is *vacuous* if it is satisfied independently of the implementation. The obvious test, reading the law, is wrong: `add(x, 0n) == x` is satisfied by `add(a, b) = a`, and `add(x, 1n+y) == 1n+add(x, y)` by `add(a, b) = b`, and both were measured earning full reward for a function nobody wrote. Non-vacuity is therefore a thing that is run, twice:

1. **Authoring-time mutation testing.** Every task ships mutants: wrong solutions, generated by `tools/mutate.py` from the reference (swapped arms, dropped cons, off-by-one, argument swaps) and hand-written where the generator cannot reach the shape. V2 requires each to fail at least one law, and validation reports each law's kill count so a law no mutant kills is visible.
2. **Episode-time tripwire.** If a live submission's `solution.bend` is byte-identical to a shipped mutant and the verdict reaches a proving tier, that is a checker soundness bug: the reward is withheld, the verdict records the incident, and the tier is left as computed because it is the evidence. Metrics count incidents; the soak asserts zero.

### 7.5 Trivial-solution detection

Some laws are satisfiable by degenerate implementations. `gavel/degenerate.py` generates a corpus from the task's own signatures and binders (the projection onto each same-typed parameter, the parameter used twice, the empty container, the constant, the identity) and V3 checks each against a `{==}`-only proof. The three ways this sweep goes wrong were each measured before they were fixed: checking against the reference proof asks whether that proof is brittle rather than whether the laws pin the function; projecting onto only the first parameter misses `add(a, b) = b`; and omitting the twice-used parameter misses `mul(a, b) = b + b`.

Beyond the corpus, the static screens in `tools/screens.py` read the law set without running anything. `anchors` flags a target no law names, a target named only inside a `for e:` premise (the submission then decides whether the premise is inhabitable), and a target with no absolute anchor; `general` and `positions` flag *room*, a target named at one point of its type and left free elsewhere. The first two anchor flags are refusals in the authoring pipeline. Every other flag is triage for a reviewer, and a clean run is not a proof.

### 7.6 Resource and behavior limits

- Submission size ≤ 64 KiB per file.
- No network, no filesystem outside the check's directory, no subprocesses beyond the checker (§9).
- Memory, CPU and output are rlimits on the checker process; on Linux the sandbox adds namespaces. Exceeding any is a failed run.

## 8. Reward function

`gavel/reward.py` is a pure function of the gate result and the proven count. No I/O, no clock, no model.

| Tier | Name | Condition | Reward |
|---|---|---|---|
| 0 | rejected | any gate finding | 0.0 |
| 1 | no-check | `solution.bend` is not a well-typed program | 0.0 |
| 2 | checks | it type-checks; no law proven | 0.1 |
| 3 | partial | a strict subset of laws proven | 0.1 + 0.5 · (proven / total) |
| 4 | complete | every law proven | 1.0 |

Notes:

- Tiers 0 and 1 both pay nothing but stay distinct, so a pipeline can penalise gate failures separately.
- Partial credit is per law, never per proof line. A proof that "almost" checks earns nothing for that law.
- In dense multi-turn mode a turn pays `max(0, reward − best so far)`.
- `difficulty_weight` from `meta.json` travels in the verdict; the harness pays the raw value and leaves weighting to the trainer.
- The tripwire of §7.4 withholds the reward but not the tier.

## 9. Sandbox and runner

Every check is a subprocess with a scrubbed environment (`PATH` to bun only, `HOME` in the temp dir, `BEND_HUB` at an unroutable address so the checker cannot phone home), rlimits, a wall clock, and a process group killed on timeout. The backend it ran under is named in every verdict, along with whether that backend is a security boundary:

- **`bwrap`** (Linux): bubblewrap with every namespace unshared, the root bound read-only with the check's own directory bound back over it, no network. This is the boundary for writes, processes and the network. It is not a boundary for reads: the host filesystem is visible to the checker, so the draft's "no filesystem outside the task directory" is not what it enforces. Narrowing the mount to the runtime, the checker and the task directory is the open change. The `Dockerfile` image has bubblewrap present and `tools/sandbox_check.py` proves a real check runs under it.
- **`plain`**: the scrubbed subprocess alone. It stops the checker reaching the network by convention only, so every verdict it produces carries `dev_only: true`.
- **`auto`** picks the strongest backend the machine can run and *raises* on Linux without bubblewrap rather than silently downgrading, because a silent fallback produces a verdict that looks sandboxed in every field except the one nobody reads. A job that is not about isolation opts out once with `GAVEL_BACKEND=plain`.

The draft's seccomp profile and container-per-version were not built: Bend is a bun script rather than a binary, cannot spawn processes, and the namespaces plus rlimits are the boundary that mattered.

Working directory: each run gets a fresh temp directory holding exactly the four task files; `references/` is never present.

Concurrency: the env is in-process and owns no threads. Throughput comes from running independent envs, which `tools/soak.py` does with `--jobs`.

Caching: `gavel/cache.py` memoises verdicts in sqlite, keyed on a hash of everything a verdict is a function of: the task's bytes, its mutant corpus (which lives outside the task's hash), the toolchain tree hash, the Bend and bun versions, the backend, the limits, the two protocol settings that move a verdict without moving a limit (`attribute_partial`, `max_runs`), the submission, and a schema version. A hit is the verdict a fresh run would have produced and is marked `cached: true` with its original `ms` kept, so latency measurements filter it out.

## 10. Curriculum

Five tiers, defined by the proof technique required rather than by code length.

| Tier | Proof technique | The bank's example | Tasks |
|---|---|---|---|
| 1 | Reflexivity, direct computation, one law whose right side never mentions the function | `t1-add-plus` | 29 |
| 2 | Single structural induction, one rewrite; a weak base law plus the inductive law | `t2-rev-append` | 171 |
| 3 | Induction with auxiliary lemmas the policy must state | `t3-tree-flatten` | 31 |
| 4 | Invariant preservation over a data structure, or a domain premise | `t4-stack-wf`, `t4-queue-rep`, `t4-nth-maybe` | 5 |
| 5 | Program-level laws with state and several interacting functions, all of them the policy's own | `t5-run-effect`, `t5-compile-word`, `t5-opt-drop` | 3 |

Sampling is a `Sampler` callable passed to the env: `uniform_sampler` (default), `tier_sampler(tiers)` for a fixed mixture, and `easiest_first`. The draft's automatic upward shift on a solve-rate threshold is a trainer-side policy over the same hook and is not built into the harness, which has no view of solve rates across runs.

## 11. Authoring pipeline

Translating a module and inventing the laws is human or agent work. Everything after that is a measurement, and `tools/author.py` runs the measurements in a fixed order and refuses to carry a task past a stage it has not passed:

```
files → derive → screens → mutants → V1–V5 → episode → review → publish
```

1. **files.** The task and reference directories hold the files of §5.1, the stub carries `?TODO` per target, the prelude is byte-identical to the reference's, and no function set collides with a registered task's.
2. **derive.** `meta.json` is derived from the files.
3. **screens.** The static readings of §7.5. Refuses on a target no law names and on a target named only inside a premise; the same defect found after the corpus exists costs the corpus too.
4. **mutants.** `tools/mutate.py` generates the corpus unless `mutants/` already holds hand-authored files, in which case generation is skipped so it cannot wipe them. Each mutant's tier is measured and the strong ones are counted.
5. **V1–V5.** `gavel/validate.py` (§5.5).
6. **episode.** One real episode through the env with the reference as the submission; it must earn 1.0.
7. **review.** A tier ≥ 3 task stops here unless `reviews/<task_id>.json` exists and its hashes match the shipped laws and prelude. **No tool in this repository writes under `reviews/`**, `gavel/reviews.py` is a reader, and a test asserts the writer does not exist. The record was once a key inside the derived `meta.json`, written by a flag, which let the pipeline attest to its own review; eleven such records were deleted rather than migrated. `tools/docket.py` assembles the reading a reviewer needs (laws, kill counts, screens, corpus) into one block per task and writes nothing.
8. **publish.** `tools/publish.py` rehashes the task and rebuilds `manifest.json`. A task directory carrying a `HOLD` file is skipped by the bare publish and refused when named explicitly; the only way to register it is to delete the marker.

Calibration (`tools/calibrate.py`, k zero-shot attempts by a fixed model, writing a solve rate) exists and has not been run over the bank; validation reports the absence per task. Migration (`tools/migrate.py`) re-validates the whole bank against a candidate toolchain and writes a quarantine report; it was used to confirm the bank against 2.0.3 and 2.0.4.

## 12. Metrics

Harness-level, from `gavel/metrics.py`, derived from the same records the trajectory log holds so a run watched live and the same run read back cannot disagree: episodes, solve rate, mean reward, mean turns, tier distribution per episode and per turn, cache hits, gate rejections, incidents, and check latency (count, p50, p95, p99) over fresh checks only. `tools/soak.py` adds verdicts per CPU-minute from the checker's own `RUSAGE_CHILDREN`, which is the load-independent figure, and reads its own log back at the end to check it against the live report.

Environment-quality, from `tools/validate.py` over whatever it was given: task count per tier, mean and minimum mutant kills per law, fraction of tier-3+ tasks with a current review record, and fraction with a calibration record. The current bank reads 239 tasks, minimum kill count 1 on every law, 0 of 39 reviewed, 0 of 239 calibrated.

## 13. Data formats

### 13.1 Trajectory record (JSONL, one line per episode)

```json
{
  "episode": 12, "episode_id": "…", "run_id": "…",
  "task_id": "t3-tree-flatten", "tier": 3, "mode": "dense",
  "bank_hash": "…", "bend_version": "2.0.5", "seed": 0,
  "turns_used": 2, "solved": true, "total_reward": 1.0, "best_tier": 4,
  "cache_hits": 0, "ms": 812, "at": "2026-09-19T…",
  "turns": [
    {"turn": 1, "reward": 0.35, "done": false, "tier": 3, "verdict": {…}},
    {"turn": 2, "reward": 0.65, "done": true,  "tier": 4, "verdict": {…}}
  ]
}
```

One line per episode rather than per turn: fields that do not vary within a run sit at the episode level once, and concurrent envs no longer interleave turns from different episodes in one file. Each turn's `verdict` is the full `Verdict` (tier, reward, laws proven and failed, gate findings, every checker run with its exit, output and ms, toolchain and task and submission hashes, backend, `cached`). Actions are stored only when `store_actions` is set. The writer flushes per line and the reader skips a half-written final line, so a killed run is still readable.

### 13.2 Bank manifest

```json
{
  "version": 1,
  "bend_version": "2.0.5",
  "toolchain_hash": "<sha256 of the vendored tree>",
  "bun_version": "1.3.14",
  "tasks": [
    {"task_id": "t1-add-plus", "tier": 1, "path": "tasks/1/t1-add-plus",
     "reference": "references/t1-add-plus", "hash": "<sha256>"}
  ]
}
```

Paths are repo-root-relative and are resolved against the repository, not the manifest's own location. Trainers load by manifest, never by scanning the tree, so a held or quarantined task is excluded deterministically. The bank hash in a verdict is the hash of this file.

## 14. Versioning

- The checker is vendored under `toolchain/<version>/` and pinned by the SHA-256 of that tree plus the bun version string; `Toolchain.load` refuses to run if either has drifted, and the test suite checks the bun it runs under against the pin. The `bend` launcher on a PATH is never called: it contacts a hub and updates itself, and did so during this project's first week.
- A bank is valid for exactly one pinned toolchain. On a Bend release, `tools/migrate.py` re-validates the full bank against the candidate tree and reports what quarantines; the bank was confirmed against 2.0.3 and 2.0.4 with nothing quarantined.
- The cache schema is part of the cache key, so a format change invalidates rather than misreads.
- Gavel itself follows semver. A reward function change is a major version, since it changes the meaning of historical trajectories.

## 15. Security considerations

- The policy's output is untrusted. Everything it submits passes through the static gate before the checker sees it, and the checker runs under §9 regardless.
- A checker that accepts is not evidence that a law was discharged unless the harness has established that the law was opened. The one reward bypass found in this harness was exactly that gap: a proof file that imported nothing checked, and was read as complete. Every reading of a checker result in `gavel/check.py` is now conditional on what the file opened.
- The Bend compiler is described by its authors as largely AI-written and not fully audited, and the Lean formalisation and implementation are known to mismatch. Gavel therefore treats the checker as a component that *can* be unsound: success is keyed on the exact success sentence rather than the exit code, and the mutant tripwire (§7.4) is the runtime alarm. A confirmed soundness bug pins the affected tasks and bumps the bank.
- Reference solutions are never present in the episode working directory and are stored apart from the public task tree.
- A review record is evidence only of a commit that added a file; nothing authenticates the name in it. What the design guarantees is that the pipeline cannot manufacture one, so the act of claiming a review leaves a diff.

## 16. Roadmap

| Milestone | Deliverable | Exit criterion | State on 2026-09-20 |
|---|---|---|---|
| M0 — Feasibility | 20 tasks (tiers 1–3), CLI harness, latency numbers | p50 check < 1 s; frontier-model zero-shot solve rate between 10% and 60% | Done except calibration, which was never run |
| M1 — Gate | Static scanner with adversarial suite, mutant pipeline, sandbox image | No known bypass; mutants killed on all tasks | Done; the sandbox is exercised by hand from the `Dockerfile` image |
| M2 — Bank v0.5 | 200 tasks across tiers 1–4, calibration data, manifest | V1–V5 green on every task | Done for 236 tasks at tiers 1–4; calibration still open |
| M3 — API | In-process and socket harness, JSONL trajectories, metrics export | An external RL loop runs 10k episodes unattended | Done; a 10,000-episode soak ran with zero incidents |
| M4 — Bank v1.0 | 500+ tasks including tier 5, human-reviewed laws for tiers ≥ 3, published throughput benchmark | First external training run reports a solve-rate curve | Benchmark published; tier 5 populated; 239 of 500; 0 of 39 tier-3+ tasks reviewed; no external run yet |

What M4 still owes, in the order it is blocked: a person reading 39 law sets
and writing 39 files under `reviews/` (the docket makes this one command's
output); a calibration pass over the bank; 261 more tasks, most of which
should be tier 4 and 5 because that is where the bank is thin and where the
RL signal is; and a training run by someone other than the harness's own
scripted policy.

## 17. Open questions

Each was open in the 0.1 draft. The build answered four; the fifth is still a question.

- **Proof feedback granularity.** *Answered:* the harness reports law-level pass/fail and passes the checker's first error block through raw, truncated to a byte budget. Nothing is enriched. The per-law attribution exists because the checker stops at the first error, not to help the policy.
- **Helper lemmas.** *Answered as the default said:* only laws count. A `Policy.*` lemma that is proven and unused earns nothing and is not tracked.
- **Termination checker scope.** *Answered:* `@unsafe` stays forbidden. Tasks that need non-structural recursion are written with fuel, and shapes the fuel cannot reach (sorts on computed arguments) are excluded from the bank.
- **Cross-version transfer.** *Moot so far:* the bank re-validated against two earlier checker versions with no quarantine, so no trajectory has yet been invalidated by a syntax change. The question returns with the first release that does.
- **Law-writing as a task.** *Still open.* Inverting the environment so the policy writes laws and is paid when they kill the mutant set would be valuable for specification generation. The authoring pipeline already measures exactly that, so the pieces exist, but the reward would no longer be a pure checker verdict and it is not in v1.

---

*Every code example in this document was taken from a task in the bank and checks under the pinned toolchain.*
