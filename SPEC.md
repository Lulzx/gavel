# Gavel — Technical Specification

**Version:** 0.1 (draft)
**Status:** Design
**Summary:** A verifiable-reward reinforcement-learning environment in which a policy model writes Bend code and proofs against fixed laws, and reward is issued by the Bend proof checker.

---

## 1. Thesis

Post-training for coding and reasoning models needs rewards that cannot be gamed. Unit tests can be overfit; human graders are slow and inconsistent; proof checkers are the only reward signal that is both automatic and unforgeable. Today "proof-checked reward" means Lean, which has two costs for RL: checking a file can take seconds to minutes, capping rollouts per GPU-hour, and the language is far from the code models are trained on.

Bend 2 changes both terms. Its type checker is a proof checker that runs in under a second on files that take Lean minutes, and its surface syntax is Python with dependent types. Its `law` construct is a first-class specification: an implementation may not ship until a `def` proving the law type-checks.

Gavel packages this into an environment: a bank of tasks, each with a natural-language prompt and a `LAWS.bend` file; a harness that runs episodes and calls the checker; a verifier gate that closes reward-hacking paths; and a curriculum. Every property of Bend that is a liability for products (verbose annotations, no tactics, terse errors, hand-written proofs) is neutral or beneficial for an environment, because the model does the work and the checker is the judge.

## 2. Goals and non-goals

### Goals

- **G1.** Reward is decided solely by the Bend checker on an unmodified `LAWS.bend`. No test cases, no LLM judges in the reward path.
- **G2.** Median reward latency under one second per episode on a single CPU core, excluding model inference.
- **G3.** A task bank of at least 500 validated tasks across five difficulty tiers by v1.0, each with a hidden reference solution and proof.
- **G4.** A verifier gate such that no known construct (unsafe annotations, axioms, law edits, vacuous laws) yields reward without a genuine proof.
- **G5.** A stable gym-style API usable from any RL framework without Bend knowledge on the caller side.
- **G6.** Reproducible builds: every task, reward, and trajectory is tied to a pinned Bend version and task-bank hash.

### Non-goals

- Teaching Bend to humans; documentation targets the harness, not the language.
- Proving properties of floating-point code (F32 is axiomatic in Bend).
- Multi-agent or tool-augmented episodes in v1 (the policy sees only the checker's output).
- Running episodes on the GPU. Bend's GPU target is irrelevant to checking.

## 3. Terminology

| Term | Meaning |
|---|---|
| **Task** | A directory containing a prompt, a `LAWS.bend`, a stub, hidden references, and metadata. |
| **Law** | A `law` declaration in `LAWS.bend`: a typed proposition over the implementation. |
| **Proof** | A `def` whose name and type match a law and which the checker accepts. |
| **Episode** | One attempt at a task: the policy submits an implementation and proofs; Gavel returns reward. |
| **Turn** | One submission within an episode. Episodes may be single- or multi-turn. |
| **Verifier gate** | Static and dynamic checks applied to a submission before and after the Bend checker runs. |
| **Verdict** | The structured result of an episode: reward tier, checker output, gate findings. |
| **Reference** | The hidden solution and proof that certify a task is solvable. |

## 4. Architecture

```
                 ┌────────────────────────────────────────────────────┐
                 │                    Task Bank                       │
                 │  tasks/<tier>/<id>/{prompt.md, LAWS.bend, stub.bend │
                 │            reference/, meta.json}                   │
                 └───────────────────────┬────────────────────────────┘
                                         │ load
┌──────────────┐   reset/step   ┌────────▼────────┐    submit    ┌──────────────┐
│  RL trainer  │◄──────────────►│     Harness     │─────────────►│ Verifier gate│
│ (any stack)  │  obs / reward  │  (gym API, JSON)│◄─────────────│ (static+dyn) │
└──────────────┘                └────────┬────────┘   findings   └──────┬───────┘
                                         │ run                          │
                                ┌────────▼────────┐             ┌───────▼───────┐
                                │     Sandbox     │────────────►│ Bend checker  │
                                │ (pinned bend,   │  exit code, │ `bend PROOF`  │
                                │  no net, quotas)│  stderr     │  (pinned ver) │
                                └─────────────────┘             └───────────────┘
```

Components:

1. **Task bank** — versioned, content-addressed directory tree. See §5.
2. **Harness** — the only public interface. Exposes `reset`, `step`, `close`. See §6.
3. **Verifier gate** — pre-check static analysis of the submission and post-check semantic tests. See §7.
4. **Sandbox** — isolated execution of the pinned `bend` binary. See §9.
5. **Reward function** — pure function from gate findings and checker result to a scalar and tier. See §8.
6. **Authoring pipeline** — offline tooling that produces validated tasks. See §11.

## 5. Task format

### 5.1 Directory layout

```
tasks/<tier>/<task_id>/
  prompt.md          # natural-language task statement shown to the policy
  LAWS.bend          # laws; immutable during episodes; hashed in meta.json
  stub.bend          # signatures the policy must implement; may include helpers
  meta.json          # metadata, hashes, provenance, difficulty
  reference/
    solution.bend    # hidden reference implementation
    PROOF.bend       # hidden reference proofs of every law
    mutants/         # hidden mutated solutions; each must FAIL at least one law
```

### 5.2 `LAWS.bend`

A law is written in Bend's law syntax. Example (list sorting, tier 3):

```
import Base

# LAW: the output of sort is ascending.
law sort_ascending:
  for xs: List<U32>
  {List.is_sorted(sort(xs)) == True{} : Bool}

# LAW: the output of sort is a permutation of the input.
law sort_permutes:
  for xs: List<U32>
  {List.is_perm(xs, sort(xs)) == True{} : Bool}
```

Rules:

- Laws reference only names declared in `stub.bend` or `Base`.
- Predicates used in laws (`List.is_sorted`, `List.is_perm`) are defined in `stub.bend` or a task-local prelude, never by the policy. A law whose predicate the policy can redefine is not a law.
- Every law must be non-vacuous: see §7.4.

### 5.3 `stub.bend`

Declares the types and signatures the policy must satisfy. Bodies are left as holes or a marker the harness recognizes. Helpers that laws depend on are fully defined here and marked immutable.

```
import Base

# Provided; immutable.
def List.is_sorted(xs: List<U32>) -> Bool:
  ...

# Provided; immutable.
def List.is_perm(xs: List<U32>, ys: List<U32>) -> Bool:
  ...

# TODO(policy): implement.
def sort(xs: List<U32>) -> List<U32>:
  ???
```

### 5.4 `meta.json`

```json
{
  "task_id": "sort-u32-001",
  "tier": 3,
  "source": {"benchmark": "custom", "origin": "MBPP-adjacent"},
  "bend_version": "2.0.3",
  "hashes": {
    "laws": "sha256:...",
    "stub": "sha256:...",
    "prelude_defs": ["List.is_sorted", "List.is_perm"]
  },
  "policy_targets": ["sort"],
  "laws": ["sort_ascending", "sort_permutes"],
  "reference_check_ms": 412,
  "mutant_count": 6,
  "zero_shot_solve_rate": {"model": "<id>", "rate": 0.23, "n": 64},
  "tags": ["lists", "induction", "sorting"]
}
```

### 5.5 Task validity invariants

A task is valid if and only if:

- **V1.** `reference/solution.bend` + `reference/PROOF.bend` + `LAWS.bend` type-check under the pinned Bend version.
- **V2.** Every mutant in `reference/mutants/` fails at least one law (i.e. the reference proof does not type-check against it, and no proof was found by the authoring pipeline within budget).
- **V3.** Every law is non-vacuous per §7.4.
- **V4.** `reference_check_ms` ≤ 2000.
- **V5.** No forbidden constructs (§7.2) appear in `LAWS.bend`, `stub.bend`, or the reference.

Validity is re-run on every Bend version bump; failing tasks are quarantined, not deleted.

## 6. Episode protocol

### 6.1 API

Gym-style, transport-agnostic (in-process Python, or JSON over a Unix socket / HTTP for other stacks).

```
reset(task_id | sampler) -> Observation
step(Action)             -> (Observation, reward: float, done: bool, info: Verdict)
close()
```

### 6.2 Observation

```json
{
  "task_id": "sort-u32-001",
  "prompt": "<contents of prompt.md>",
  "laws": "<contents of LAWS.bend>",
  "stub": "<contents of stub.bend>",
  "turn": 1,
  "max_turns": 4,
  "feedback": null
}
```

On subsequent turns, `feedback` carries the checker's stderr from the previous submission (truncated to a configurable byte limit) and the gate findings. Bend's terse error messages are passed through unmodified; they are the training signal for repair.

### 6.3 Action

```json
{
  "files": {
    "solution.bend": "<implementation of policy_targets>",
    "PROOF.bend": "<one def per law>"
  }
}
```

The policy may not submit `LAWS.bend` or `stub.bend`. Submissions that include them are rejected by the gate with tier 0 reward (see §7.1).

### 6.4 Multi-turn semantics

- `max_turns` is task-configurable (default 4). An episode ends on full proof or when turns are exhausted.
- Reward is issued per turn (dense) or only at episode end (sparse), selectable at harness construction. Dense mode uses the tiered function in §8; sparse mode issues the final tier only.
- Turns are independent submissions; no state carries over except feedback text.

## 7. Verifier gate

The gate exists because a proof checker is only as trustworthy as the surface it checks. Reward hacking against Gavel means getting the checker to accept without proving the law. Each closed path below corresponds to a known or anticipated attack.

### 7.1 File integrity

- `LAWS.bend`, `stub.bend`, and the prelude definitions are concatenated in canonical order and hashed. The hash must match `meta.json` at check time.
- The submission may define only the names listed in `policy_targets` plus new helper names in a reserved namespace (`Policy.*`). Redefining any prelude, Base, or law name is a gate failure.
- Shadowing is checked syntactically before the Bend checker runs.

### 7.2 Forbidden constructs

The following are rejected by static scan of every submitted file:

| Construct | Reason |
|---|---|
| `@unsafe` | Disables the termination checker; non-terminating "proofs" type-check. |
| Any axiom or postulate form | Assumes the goal. |
| `import` of anything other than `Base` and the task prelude | Prevents smuggling definitions. |
| Foreign function declarations | Escape from the type system. |
| Modification or redefinition of `law` blocks | Changes the spec. |
| Compile-time templates that expand to any of the above | Same paths via metaprogramming. |

The scan is a conservative tokenizer over the submission, not a regex over text; it is maintained against each pinned Bend version's grammar and has its own test suite of adversarial submissions.

### 7.3 Checker invocation

- `bend PROOF.bend` is run in the sandbox against `LAWS.bend` + `stub.bend` + `solution.bend` + submitted `PROOF.bend`.
- Exit code and stderr are captured. Any nonzero exit is a failed proof.
- Wall-clock limit: 10 s (well above the 1 s target; proofs that exceed it are treated as failures and logged for review, since they indicate either a pathological submission or a checker regression).

### 7.4 Non-vacuity and mutation testing

A law is *vacuous* if it is provable independently of the implementation (e.g. `for x: Nat  {x == x : Nat}`) or if its predicate is trivially true. Two mechanisms guard against this:

1. **Authoring-time mutation testing.** Every task ships mutants: reference solutions with one deliberate semantic bug each (off-by-one, dropped element, swapped branch). Task validity (V2) requires each mutant to be rejected by the laws. A law set that accepts all mutants constrains nothing and the task is rejected.
2. **Episode-time consistency.** If a submission's `solution.bend` is byte-identical to a known mutant and the submitted proof type-checks, that is a checker soundness bug; the episode is flagged, reward is withheld, and the case is filed to the Bend issue tracker with the task pinned.

### 7.5 Trivial-solution detection

Some laws are satisfiable by degenerate implementations (e.g. `sort` returning the empty list satisfies `sort_ascending` alone). Authoring must pair such laws with a constraining partner (`sort_permutes`). The authoring pipeline flags any task where a degenerate implementation from a fixed library (empty list, identity, constant zero, first element) proves the full law set.

### 7.6 Resource and behavior limits

- Submission size ≤ 64 KiB per file.
- No network, no filesystem outside the task directory, no subprocesses (§9).
- The checker's own memory ceiling is enforced by cgroup; exceeding it is a failure.

## 8. Reward function

Reward is a deterministic function of gate findings and checker outcome.

| Tier | Condition | Reward |
|---|---|---|
| 0 | Gate failure (forbidden construct, file tampering, size, timeout) | 0.0 |
| 1 | Gate pass; submission does not type-check as a program | 0.0 |
| 2 | `solution.bend` type-checks; no law proven | 0.1 |
| 3 | `solution.bend` type-checks; a strict subset of laws proven | 0.1 + 0.5 · (proven / total) |
| 4 | All laws proven | 1.0 |

Notes:

- Tier 0 and tier 1 both score 0.0 but are distinguished in the verdict so that training pipelines can penalize gate failures separately if desired.
- Partial credit (tier 3) is per law, not per proof line; there is no credit for a proof that "almost" checks.
- In multi-turn dense mode, per-turn reward is the tier delta relative to the best prior turn, so repair is rewarded and regression is not.
- A per-task `difficulty_weight` in `meta.json` may scale reward for curriculum purposes; the harness exposes both raw and weighted values.

## 9. Sandbox and runner

- One container image per pinned Bend version, built from the official installer at a fixed commit, with `bend` on the path and nothing else network-reachable.
- Each episode runs in a fresh working directory copied from the task, with the submission written in and the `reference/` directory absent.
- Isolation: no network namespace, read-only root, tmpfs working dir, seccomp profile denying `fork`/`exec` beyond the checker, CPU and memory cgroups.
- Concurrency: episodes are independent; the runner is a work queue with N workers per core. Because checking is sub-second, a 64-core host is expected to sustain thousands of verdicts per minute; this number is measured and published per release.
- Caching: `(bend_version, task_hash, submission_hash) -> verdict` is memoized. Identical resubmissions do not re-run.

## 10. Curriculum

Five tiers, each defined by the proof technique required rather than by code length.

| Tier | Proof technique | Example task |
|---|---|---|
| 1 | Reflexivity, direct computation | `add_zero`, list length of a literal |
| 2 | Single structural induction, one rewrite | `add_comm`, `append_nil`, `reverse_reverse` |
| 3 | Induction with auxiliary lemmas the policy must state | Sorting is ascending and a permutation |
| 4 | Invariant preservation over a data structure | Balanced tree stays balanced under insert; stack machine preserves a well-formedness predicate |
| 5 | Program-level laws with state and multiple interacting functions | The homepage `you_cant_win` game law; a ledger where balances sum to zero across transfers |

Sampling policy is configurable; the default is a difficulty-weighted mixture that shifts mass upward as the policy's tier-k solve rate crosses a threshold (default 0.6). Solve rates are tracked per task and per tier in the trainer-visible `info` field.

## 11. Authoring pipeline

Tasks are produced offline by a semi-automated pipeline. Every stage is logged; a task's provenance is part of its metadata.

1. **Source selection.** Problems are drawn from existing benchmarks (HumanEval, MBPP, LeetCode-style sets, Software Foundations exercises, Bend's own `demos/` and `tests/`), or written fresh for tiers 4–5.
2. **Translation.** An LLM agent, given `bend guide`, writes `stub.bend` and a candidate `LAWS.bend` from the source problem.
3. **Law review.** A second pass (LLM plus human for tiers ≥ 3) checks that laws capture the intent of the prompt and are not degenerate (§7.5). Rejected laws go back to step 2.
4. **Reference generation.** An agent produces `solution.bend` and `PROOF.bend` under the same gate rules the policy faces. Budget: N attempts with checker feedback. Tasks with no reference within budget are shelved as "unsolved" and excluded from the bank until solved.
5. **Mutant generation.** Five to ten mutants are produced by rule-based mutation of the reference; each is confirmed to fail at least one law (V2).
6. **Calibration.** A fixed evaluation model attempts the task k times zero-shot; the solve rate is recorded. Tasks with rate 1.0 are demoted a tier or discarded; tasks with rate 0.0 at tier ≤ 3 are flagged for law review.
7. **Publication.** The task directory is hashed and added to the bank under the current Bend version.

## 12. Metrics

Harness-level metrics, exported per run:

- Verdicts per minute per core (throughput).
- p50 / p95 / p99 check latency.
- Tier distribution of submissions.
- Gate failure rate by category.
- Per-task and per-tier solve rate over time.
- Soundness incidents (§7.4 item 2), which should be zero and are alerted on.

Environment-quality metrics, exported per bank release:

- Task count per tier.
- Calibration solve rate distribution.
- Mean mutants killed per law.
- Fraction of tasks with human-reviewed laws.

## 13. Data formats

### 13.1 Trajectory record (JSONL, one line per turn)

```json
{
  "run_id": "…", "episode_id": "…", "task_id": "sort-u32-001",
  "bend_version": "2.0.3", "bank_hash": "sha256:…",
  "turn": 2, "action": {"files": {"solution.bend": "…", "PROOF.bend": "…"}},
  "verdict": {
    "tier": 3, "reward": 0.35,
    "laws_proven": ["sort_ascending"], "laws_failed": ["sort_permutes"],
    "gate": {"passed": true, "findings": []},
    "checker": {"exit": 1, "stderr": "…", "ms": 388}
  }
}
```

### 13.2 Bank manifest

A single `manifest.json` at the bank root listing every task id, tier, hash, and validity status for the pinned Bend version. Trainers load tasks by manifest, never by scanning the tree, so quarantined tasks are excluded deterministically.

## 14. Versioning

- The Bend binary is pinned by version and installer commit. A bank is valid for exactly one pinned version.
- On a Bend release, the full bank is re-validated (§5.5). Tasks that fail are quarantined with the failing stage recorded. A migration report lists syntax changes that need task edits.
- Gavel itself follows semver. Reward function changes are a major version, since they change the meaning of historical trajectories.

## 15. Security considerations

- The policy's output is untrusted. Everything it submits passes through the static gate before the Bend binary sees it, and the binary runs under the sandbox in §9 regardless.
- The Bend compiler is described by its authors as largely AI-written and not fully audited, and the Lean formalization and implementation are known to mismatch. Gavel therefore treats the checker as a component that *can* be unsound, and the mutant-consistency check (§7.4) is the tripwire. Any confirmed soundness bug pins the affected tasks and bumps the bank.
- Reference solutions are never present in the episode working directory and are stored separately from the public task bank.

## 16. Roadmap

| Milestone | Deliverable | Exit criterion |
|---|---|---|
| M0 — Feasibility | 20 tasks (tiers 1–3), CLI harness, latency numbers | p50 check < 1 s; frontier-model zero-shot solve rate between 10% and 60% |
| M1 — Gate | Static scanner with adversarial test suite, mutant pipeline, sandbox image | No known bypass in the adversarial suite; mutants killed on all 20 tasks |
| M2 — Bank v0.5 | 200 tasks across tiers 1–4, calibration data, manifest | All V1–V5 invariants green under CI |
| M3 — API | In-process Python and socket harness, JSONL trajectories, metrics export | An external RL loop runs 10k episodes unattended |
| M4 — Bank v1.0 | 500+ tasks including tier 5, human-reviewed laws for tiers ≥ 3, published throughput benchmarks | First external training run reports a solve-rate curve |

## 17. Open questions

- **Proof feedback granularity.** Bend reports errors tersely. Should the harness enrich feedback (e.g. which law failed, at which goal) or leave it raw to avoid leaking hints? Default: raw, with law-level pass/fail only.
- **Helper lemmas.** Tier 3+ tasks require the policy to state its own lemmas. Should reward recognize a correct lemma that is proven but unused? Default: no; only laws count.
- **Law-writing as a task.** A future mode where the policy writes laws from a prompt and is rewarded when its laws kill the mutant set. This inverts the environment and is valuable for spec generation, but the reward is no longer a pure checker verdict.
- **Cross-version transfer.** Whether trajectories from one Bend version remain useful after syntax changes, or must be regenerated.
- **Termination checker scope.** If a task genuinely needs non-structural recursion, Bend requires `@unsafe`, which the gate forbids. Such tasks are excluded until Bend supports well-founded recursion without it.

---

*Bend is young and its syntax may shift; all code examples in this document follow the forms shown in the Bend README and should be re-verified against `bend guide` for the pinned version.*
