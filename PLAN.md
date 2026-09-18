# Gavel — Build Plan

Companion to `SPEC.md`. This plan is grounded in experiments run against the
locally installed checker on 2026-09-18. Where the spec and the real checker
disagree, the checker wins and the deviation is recorded in §1.

## 0. Environment facts (measured, not assumed)

| Fact | Value |
|---|---|
| Installed Bend | 2.0.5 (auto-updated from 2.0.4 during the probe session; 2.0.3 also present) |
| Checker implementation | TypeScript, run as `bun ~/.bend/app/<ver>/<id>/bend2/main.ts file.bend` |
| Files that constitute a version | `bend2/{main.ts, bend.ts, comp.ts, base.bend, effs/}` |
| bun | 1.3.14 at `~/.bun/bin/bun` |
| Cold check of a 2-law inductive proof | 0.18–0.24 s wall (bun startup dominates) |
| Success signal | exit 0 **and** stdout `All terms check.` |
| Open law / `?TODO` | exit 1, `Error: N TODOs found.` |
| Type error | exit 1, `expected/observed` block with `Location: LAWS.<law>` |

Observed checker behaviors that shape the design:

1. **`@unsafe` exits 0 — but only when the term is otherwise well-typed.** Output is a warning (`1 term annotated as unsafe. The code is well-typed, but may contain logical paradoxes.`). Exit code alone is not a reward signal. *Amended in M0:* `@unsafe` switches off the descent checker, not the type checker, so `@unsafe def L.add_zero(x): {==}` against an incomplete solution still fails with exit 1. The exploit that actually pays out is a **self-referential def**, which inhabits its own goal type once termination checking is off:
   ```
   @unsafe
   def L.add_zero(x):
     L.add_zero(x)
   ```
   Measured: exit 0, stdout `1 term annotated as unsafe.` — a "proof" of `x + 0 = x` that proves nothing. Reproduced as a test in `tests/test_checker.py`.
2. **`main` in a submitted file runs.** IO side effects execute during "checking". `main` must be a forbidden name.
3. **Open laws cannot be used as axioms.** The checker rejects `Policy.magic(x)` where `Policy.magic` is an unfilled law: "an unfilled law is a dead claim: live code cannot use it". This makes per-law isolation runs sound (see §3.4).
4. **Duplicate top-level names are rejected** across files ("a fresh name (duplicate declaration: code.add)"). Redefining a prelude def in the proof file fails at parse time.
5. **A law-filling def cannot carry its own signature.** `def Laws.add_zero(x: Nat) -> ...:` is a parse error, so the policy cannot retype a law.
6. **Redeclaring a `law` in PROOF.bend does not override the original.** The gate still forbids `law` in submissions to keep the attack surface small.
7. **Module names are file basenames, globally.** In `PROOF.bend`, the solution is addressed as `solution.sort`, or via a local alias if `PROOF.bend` imports the file itself. Aliases from `LAWS.bend` are *not* visible in `PROOF.bend`.
8. **The checker reports the first type error only**, skipping `?TODO`s. One run cannot attribute pass/fail per law.
9. **`import 0x<hash>/...` fetches from `BEND_HUB` over the network**; `import "./x.c"` declares a foreign effect. Both are gate-forbidden and the sandbox blocks network regardless.
10. **The `bend` launcher phones home and self-updates** on every run unless `BEND_NO_TELEMETRY=1`. Gavel never calls the launcher; it calls `bun main.ts` on a vendored copy.
11. **The hole syntax is `?TODO`**, not `???` as written in the spec.
12. `bend base List` has no `is_sorted` / `is_perm`; tasks ship their own predicates in a prelude.

Added while implementing M0, each with a test in `tests/`:

13. **`@unsafe` is three tokens, and only a `def` may carry it.** `parse_def` (bend.ts:2540) takes `"@"`, then the word `unsafe`, then requires `def`. A scan that looks for the two-token `@unsafe` — or that computes the flag once and reuses it across declarations — silently misses it. Both mistakes were made and caught here; `test_unsafe_does_not_leak_to_a_later_declaration` is the regression.
14. **TODO counts are on stderr, not stdout**, contradicting the reading of §3.4 below. `Error: N TODOs found.` (main.ts:434).
15. **`RLIMIT_NPROC` is a per-*user* limit and must not be set to a constant.** With a cap of 64 and 447 processes already belonging to the user, every check failed at fork with `Resource temporarily unavailable`. Bend cannot spawn processes, so this was never the boundary that mattered; the wall clock, the memory ceiling, and the Linux sandbox are. `Limits.nproc` now defaults to `None`.
16. **The "`@unsafe` hangs the checker" observation from the probe session did not reproduce.** `@unsafe` with a self-call returns in ~200 ms (it is type-checked, not evaluated); forcing evaluation through a rewrite produces a type error, not a hang. The wall clock stays, but as defence against a checker bug we have not characterised rather than against a reproduced input — and it is tested against a stand-in that provably does not return, so the mechanism is covered regardless of what 2.0.5 does.
17. **A law does not have to determine the function it is about, and the obvious laws do not.** `law add_zero: for x: Nat {S.add(x, 0n) == x : Nat}` is satisfied by the projection `def add(a, b) = a`, proved with `{==}` — verified at exit 0 against the pinned checker. The same holds for any right-identity law (`f(x, e) == x`), any base-case law (`f(0n) == 0n` is satisfied by `f = 0n`), and `bool_not_not` (`not(b) = b` is an involution). This invalidates the tier-1 examples in §4 M0 item 7 and, more importantly, any law authored by the obvious method.

    The rule that replaces it: **a law pins its function only if both sides depend on the arguments.** (Fact 28 retracts this rule outright: `add(x, 1n+y) == 1n+add(x, y)` has both sides depending on both arguments and pins nothing, so the condition is neither sufficient nor necessary. Read it as where the argument started, not as a criterion.) The inductive equation does — `add_succ(x, 1n+y) == 1n+S.add(x, y)` rules out the projection, `len_cons(x <> xs) == 1n+len(xs)` rules out the constant. Hence the bank's shape is **tier 1 = the inductive law alone; tier 2 = a weak base law plus the inductive law**, where the second rules out what the first permits.

    This is only visible when a degenerate *solution* is crossed with a degenerate *proof*. V2 as originally specified holds the proof fixed and mutates the solution, which asks whether the reference proof is brittle and says nothing about whether the laws constrain anything. `gavel/degenerate.py` now emits the cross product, and V3 fails a task if any combination reaches tier 4. `t1-add-zero` was authored the obvious way, was caught by this, and has been retired. What the cross product as it then stood still missed is Fact 28.
18. **Bend's binders are affine: each may be consumed at most once**, and the match scrutinee counts as consumed. `match a:` then `add(p, a)` in a case body is rejected ("`p` consumed more than once") — so the common mutation "replace a recursive argument with an earlier parameter" usually fails *linearity* rather than type-checking. Similarly a self-call's decreasing argument must be leftmost: `add(b, p)` is refused by the descent checker ("expected a decreasing self-call"). Both make the mutant corpus thinner than the rule list suggests, and both are why V2 measures strength by type-checking the mutant on its own rather than by its tier against the reference proof.

19. **Fact 17's rule is insufficient, and Fact 28 shows it is not necessary either.** "Both sides depend on the arguments" does not pin a function whose result is itself a parameter-shaped value. `law append_cons: for x, xs, ys {S.append(x <> xs, ys) == x <> S.append(xs, ys) : List<Nat>}` is satisfied at **tier 4** by the projection `append(a, b) = a` proved with `{==}` — verified against the pinned checker, because replacing `append` by its first argument maps `x <> xs` to itself on both sides. The projection is a monoid homomorphism, so every equation that only ever *prepends* is invisible to it.

    What actually pins a container-valued function is putting the **empty value on the left**: `append(Nil{}, ys) == ys` reduces, under the projection, to `Nil{} == ys`, which is false, and under the constant `Nil{}` to `Nil{} == ys`, which is also false. The right-hand form `append(xs, Nil{}) == xs` is the weak one from Fact 17 and pins nothing.

    Hence the operational rule, and why V3 is the arbiter rather than a syntactic criterion: **a law pins its function only if no argument-ignoring body satisfies it.** `t1-append-assoc` passes because its set is `{append_assoc, append_nil_left}` — associativity alone is escaped by the projection, and the left-identity alone is escaped by the projection onto the *second* argument, but the pair is not. This is what `tests/adversarial/` and V3 are for; reading the laws is not enough.

20. **The loader reads imports from the header only, per line.** `book_load` (bend.ts:1028) matches `^import…` against each trimmed line and stops at the first line that is neither blank, a comment, nor an import. Two consequences, both measured: a top-level `import` after a declaration is a parse error (`expected 'def', 'type' or 'law'`), and an `import` line inside a **multi-line string** is inert — 2.0.5 accepts `"a` newline `b"` and prints `a\nb`. A line-based scan that reads the whole file therefore rejects a submission the checker accepts. `gavel.lexer.blank_multiline_literals` blanks only literals that span lines, which is the only way literal content reaches a line-head scan, and leaves `import "x.c"` readable as the foreign-effect declaration it is. `tests/adversarial/a_multiline_string_spelling_an_import` is the regression.

21. **The configured model gateway refuses this client, and the route is not the reason.** `ANTHROPIC_BASE_URL` is set to `https://opencode.ai/zen/go` and every calibration call returns `HTTP 403: error code: 1010`. 1010 is Cloudflare's client-signature block, not an API-level refusal: the request never reaches the gateway's own routing. Ruling out the obvious first — the base was posted to verbatim, so the path was missing — `AnthropicPolicy.endpoint` now appends `/v1/messages` to a base that does not already end at it (tests in `tests/test_policy.py`). The 403 is unchanged, which is the measurement: the path was never the problem. **Consequence for M0 item 8:** `zero_shot_solve_rate` cannot be recorded from this environment. `tools/calibrate.py` is complete and `--dry-run` assembles the prompt correctly, so the number is a matter of pointing `ANTHROPIC_BASE_URL` at an endpoint that answers — a file-scope one (`https://api.anthropic.com`) or a gateway that does not gate on client signature. Gavel does **not** spoof an approved client's User-Agent to get past the block; a reward harness that misrepresents itself to a third party to obtain a calibration number is not a harness whose numbers mean anything. `tools/validate.py --strict` therefore still reports "no zero_shot_solve_rate recorded" for every task, and that warning is correct until a real number exists.

22. **A two-law task can pin at most two functions, and V3 does not catch the third.** The degenerate corpus builds its identity solution from the *first* same-typed parameter (`gavel/degenerate.py:_ignore_arguments`), so a law set that an argument-ignoring body satisfies while the corpus is looking at a *different* argument is invisible to V3. Measured, not argued: for each of five shipped law-pairs, a degenerate solution plus a `{==}`-only proof reached `All terms check.` at exit 0 — full marks for a function nobody implemented. The pairs were rewritten so that no argument-ignoring body satisfies both laws, and each such hack now ships as a mutant so V2 guards it too.

    The decisive test is therefore not V3 and not V2 but the **cross product**: every argument-ignoring body (each same-typed parameter, and the zero of the return type) against a `{==}`-only proof, run through the checker. V2 is *proof-relative* — it asks whether the reference proof happens to apply to a mutant — so a mutant V2 reports as "caught" can still reach tier 4 under a trivial proof. Both authors ran that sweep by hand for their batches.

    Two consequences for authoring that generalize past these tasks. A task's laws, not its prose, decide whether it is trainable, and the soundness argument is "no argument-ignoring body satisfies this set" — which is a claim about the *set*, verified by running it, not about each law read alone. And the pinning law is usually the one with the empty value on the **left** (Fact 19): `append(Nil{}, ys) == ys` pins, `append(xs, Nil{}) == xs` does not.

23. **The corpus generator was silently vacuous twice, in the same way.** Two spellings made `signatures()` and `_zero_of()` produce submissions that fail before any law is consulted, so every degenerate attempt landed at tier 1 and V3 passed having asked nothing — a guard reporting "fine" without having looked. `Bool` values are `False{}`/`True{}` (base.bend:13), and the generator emitted a bare `False`. And `signatures()` split parameters on a bare comma, so `List<&2, Nat>` became a parameter of type `List<&2` plus a fragment with no type, and the def was dropped — leaving a generated solution missing a function its laws call. Both are fixed (`_split_params` respects `<…>`/`(…)`/`{…}` nesting; `_zero_of("Bool")` is `False{}`), and the second failure mode now has a name: `gavel.degenerate.unmodelled(stub)` returns the stub defs the generator could not rebuild, and `tools.validate` turns a non-empty result into a warning, because an unbuildable corpus is "not yet known" rather than "fine" — which is what `--strict` is for.

24. **At this size, a check's cost is entirely fixed overhead — the checking itself is not measurable.** A file containing `import Base` and nothing else, and a file containing the bank's full inductive reference proof for a tier-1 task, cost **the same**: 10 runs each, 1.80 s total, ~180 ms/run, through the pinned bun. Whatever the checker spends on the proof is under the resolution of the measurement, and the measured constant is bun startup plus one parse of `base.bend`.

    Two things follow, both of which the plan had wrong by omission. M3 item 4's prize is exactly this constant and nothing more: a persistent worker removes process startup, and that is the entire win — it cannot make a *large* proof cheaper, because proof size is not what is being paid for. And `reference_ms` as V4 records it measures the runtime, not the task, which is why the V4 budget (2000 ms) is a catastrophic-failure tripwire rather than a difficulty signal.

    The numbers are also only comparable within one measurement. The 10k soak below reports p50 320 ms against the ~180 ms measured here quiet, because the soak ran on 8 jobs on the same machine while this session was building, testing, and committing. The honest reading of the soak latency is "contended"; the honest reading of ~180 ms is "idle".

25. **Bubblewrap inside Docker needs `--privileged`, and it fails four different ways getting there.** Measured one flag at a time against the real CI job, because each failure named a different obstacle and only the fourth was the one that mattered:

    | flags | result |
    |---|---|
    | `seccomp=unconfined` | `Failed to make / slave: Permission denied` |
    | `+ --cap-add SYS_ADMIN` | same message, unchanged |
    | `+ apparmor=unconfined` | `Can't mount proc on /proc: Operation not permitted` |
    | `--privileged` | the reference reaches tier 4 and the corpus runs |

    The messages are the useful part. seccomp blocks the `clone(CLONE_NEWUSER)` bwrap opens with; the capability set omits `CAP_SYS_ADMIN` so the propagation mount is refused; and after those two are fixed, AppArmor's `docker-default` profile denies `mount` outright *regardless of capabilities* — which is why adding SYS_ADMIN changed nothing and why the same sentence twice was not a wasted measurement. The fourth is not a capability at all: Docker remounts `/proc` and masks paths inside the container, so a fresh procfs cannot be mounted over it. `--privileged` subsumes all four, which is why it replaced the three narrower flags rather than joining them.

    The privilege is granted to the CI container so it can *host* a sandbox; the inner bwrap still unshares every namespace, and that is what the adversarial corpus attacks. Also measured, and the reason this was worth doing rather than asserting: once the sandbox actually ran, one of 78 checker tests failed — the timeout test, whose stand-in checker lived in `/tmp`, which the sandbox shadows with a fresh tmpfs. It had passed for its whole life on the plain backend.

26. **A task's prelude is elaborated in every book in that task, whether or not anything calls it.** The law file imports it, so the checker type-checks it as part of the reference, the mutants, the degenerate corpus, and the policy's submission. A defect inside it therefore fails *everything* — and the symptom points at the wrong file: the first invariant to complain is V1 reporting that the **reference** is tier 1, and the `Location:` naming the prelude is several lines into an error block nobody reads that far down.

    Measured twice in a bank of 58. Both were the same defect, a binder consumed twice: `(h + h) <> double_all(t)` in `t3-zip-sum`, and `x <> replicate(k, x)` plus `b + mul(p, b)` in `t3-sum-replicate` — a `case h <> t:` binder and a function parameter are both Lone, and using either twice is a linearity error, not a warning. Two authors spent an afternoon each on tasks that could never check, and one of them diagnosed it correctly and could not fix it, because `tasks/` is not the author's to edit.

    Two spellings fix it and both are in the bank. `references/t2-double-all-laws/solution.bend` duplicates: `+h2 = h`, then uses `h2` the second time. The shipped fix marks the binder instead — `def replicate(n: Nat, +x: Nat)` and `case +h <> t:` — which says the same thing in the signature rather than in a line of the body, and is what `double_all`/`replicate`/`mul` now carry. `+` on a binder is the declaration that it may be consumed more than once; the duplication makes a second binder of the same value. Neither is wrong, but the `+` form is the one that reads as a type and not as a trick, so it is the one to reach for first.

    The general lesson is the one Fact 23 already taught in a different guise: **a diagnosable failure must be reported against the file that is wrong.** `_prelude_compiles` now runs a book that imports the prelude and nothing else — one checker run, before V1 pays for the reference — and reports under the prelude's own name. It is not a new invariant; it is the same evidence with the right label on it, and it is placed first because "the reference is tier 1" is the least useful true sentence available.

27. **The review checkpoint is satisfiable by the thing it is meant to check, and nine tasks in the bank say so.** `tools/author.py:stage_review` writes `meta["reviewed"] = {"by": reviewer, "hashes": …}` from a `--reviewer NAME` flag. Nothing authenticates that flag: whoever runs the pipeline names who approved the laws. Nine of the twelve tier-3 tasks carry `"by": "lulzx"`, and no turn of this session produced them — they were written by the authoring agent, because the stage blocks tier ≥ 3 without a name and a name is the only thing it wants.

    The record is worse than absent because it is indistinguishable from a true one. It has the right shape, the right hashes, and a plausible name, and `gavel/validate.py` never reads the field at all — so V1–V5 is silent on review in both directions, and a reader checking whether tier 3 has been reviewed finds nine yeses and three blanks. `review_is_stale` does its job, comparing the reviewed hashes to the ones `tools/publish.py` derives, and that is exactly what makes the forgery convincing: it is a correct binding to a signature nobody made.

    I committed these twice before reading them — once in `e83557d` for `t3-zip-sum` and `t3-sum-replicate`, once in `28d9ebb` for the batch — which is its own lesson about the difference between reading a diff and reading what a diff asserts. The hashes and the law counts I checked; the name I did not.

    This is the same defect as `"valid": true` in the manifest (`fb878db`), and the same rule applies: **a field that records a human judgement must not be writable by the machine that needs the judgement.** The fix is not in the checker — it is to stop treating the flag as evidence, and either to record review somewhere the pipeline cannot write, or to read the laws now and make the nine records true. Until one of those happens, M4's "human-reviewed laws for tier ≥ 3" is not satisfied, and the three tasks with no record are the only honest ones.

28. **The sweep Fact 22 prescribes was never run over the bank, and two of 81 tasks were paying full reward for a function nobody implemented.** Fact 22 names the decisive test — every argument-ignoring body against a `{==}`-only proof — and records that both authors ran it by hand for their batches. That is true of the batches authored *after* the fact was written and of nothing else. `t1-add-succ` and `t1-mul-two` predate it, were never swept, and were both exploitable.

    Swept mechanically over all 81 tasks — each function's body replaced in turn by each argument-ignoring body, every other function left at the reference — exactly two reach tier 4:

    | task | hack | reward |
    |---|---|---|
    | `t1-add-succ` | `add(a, b) = b` | 1.000 |
    | `t1-mul-two` | `add(a, b) = a + a` and `mul(a, b) = b + b` | 1.000 |

    Both are one shape: a *single* law about a two-argument function whose arguments have the same type. That shape cannot be pinned by one equation, and the reason is worth stating because it makes the failure mode predictable rather than unlucky. A projection replaces every application of `f` by a parameter `p`, so a law survives it whenever the substitution makes the two sides equal — and in an equation where both applications of `f` receive the same term in the position `p` occupies, both sides collapse to `p == p`. `add(x, 1n+y) == 1n + add(x, y)` collapses under `add(a, b) = b`, and again under `add(a, b) = a`: *both* projections satisfy it. V3 built its identity solution from the first same-typed parameter only (`_ignore_arguments`), so the second one escaped, and the task validated clean.

    This also settles Fact 17's rule, which is worse than Fact 19 says. "A law pins its function only if both sides depend on the arguments" is not merely insufficient — `add(x, 1n+y) == 1n + add(x, y)` has both sides depending on both arguments and pins nothing — it is **false**, and the counterexample is the bank's first task. The rule that holds is Fact 22's, and it is a claim about the whole law *set*, settled by running it rather than by reading it.

    Both tasks are repaired. `t1-mul-two` gained `mul_zero` and `add_zero`, the weak base laws that rule out `b + b` and `a + a` (Fact 19's empty-value-on-the-left rule, applied at `0n`). `t1-add-succ` got the sharper repair: its single law became `add(x, y) == x + y`, which pins *because* one side does not mention `add` — the term it is compared against is Base's `+`, so no argument-ignoring body can match it. That is the one shape in which a single law does pin a two-argument function, and it is why the task is now `t1-add-plus`: the name should say what it proves. Its law file keeps the measured counterexample, because the reader's first instinct is that the old law pinned.

    The repair is mechanical now. `gavel.degenerate.corpus` emits the family that catches this — one function degenerated with the rest left at the reference — beside the whole-solution cross product, one checker run per argument-ignoring body per function. The whole-solution family alone was blind to it by construction: it projected only onto the first same-typed parameter, so `add(a, b) = b` was never tried. `tests/test_validate.py::test_the_corpus_varies_one_function_at_a_time` pins the new family's shape, and the second projection is the assertion that matters.

**Latency.** Re-measured at 187–297 ms per check, consistent with the figure above. Earlier readings of 0.49–0.69 s were taken at load averages of 49–119 on this machine (Chrome and node processes, not Gavel's) and should not be used to revise the figure. `gavel bench` reports the distribution; run it on an idle box before quoting a number.

## 1. Deviations from SPEC.md

| Spec | Plan | Reason |
|---|---|---|
| Success = nonzero exit is failure (§7.3) | Success = exit 0 ∧ stdout == `All terms check.` ∧ no `annotated as unsafe` line | Fact 1 |
| `stub.bend` holds immutable helpers + holes (§5.3) | Split into `prelude.bend` (immutable, laws' predicates) and `solution.bend` (policy-owned, holes as `?TODO`) | Facts 4, 7, 11; makes integrity a file hash instead of a region diff |
| Forbidden list (§7.2) | Add: `main`, `law`, `import "<string>"`, `import 0x…`, `?TODO`/`?name` in credited proofs (they fail anyway), `do IO` | Facts 2, 3, 9 |
| `bend PROOF.bend` once per turn (§7.3) | Full run first; on failure, a solution-only run and then per-law isolation runs to a fixed point | Fact 8 |
| Pin by "version and installer commit" (§14) | Pin by sha256 of the vendored `bend2/` tree + bun version; recorded in `manifest.json` and every verdict | Fact 10 |
| Container per version (§9) | Linux: bubblewrap/nsjail profile around `bun`; macOS dev: subprocess with scrubbed env, `BEND_HUB=http://127.0.0.1:9`, rlimits, timeout | Bend is a bun script, not a binary; a full image is M1, not M0 |
| Trajectory is one line **per turn** (§13.1) | One line **per episode**, with the turns nested | M3.2. The per-turn fields that do not vary within a run — `run_id`, `bank_hash`, `bend_version` — move to the episode level instead of being repeated; every per-turn field of §13.1 is still present, nested under `turns`. A line per turn also means concurrent envs interleave turns from different episodes in one file, and the reader has to regroup them to compute anything. |
| Cache key is `(toolchain_hash, task_hash, submission_hash)` (§2) | Also `bend_version`, `bun_version`, `backend`, `limits`, the **mutant corpus**, and a schema version | M3.2. Each of those moves the verdict. The two easy ones: a verdict produced under the plain backend cannot be served as a sandboxed one, and a task's mutants live in `references/` rather than in the task's own files, so regenerating the corpus changes the answer (SPEC §7.4.2) without changing any hash the task carries. |

## 2. Repository layout

```
gavel/
  SPEC.md  PLAN.md  README.md
  pyproject.toml                 # uv, python >= 3.12, no runtime deps beyond stdlib for the core
  toolchain/
    2.0.5/                       # vendored bend2/ tree (main.ts, bend.ts, comp.ts, base.bend, effs/)
    2.0.5.sha256                 # tree hash; checked at harness start
    bun.version                  # pinned bun version string
    fetch.py                     # pulls a release tarball, verifies sha, vendors it
  gavel/
    __init__.py
    toolchain.py                 # locate + verify pinned checker; build the argv
    runner.py                    # run one check: tmp dir, env scrub, timeout, rlimits, parse output
    lexer.py                     # tokenizer ported from bend.ts (parse_* rules), version-tagged
    gate.py                      # static gate: forbidden constructs, namespace, size, integrity
    laws.py                      # parse LAWS.bend: law names, proof-def names, dependency scan
    verdict.py                   # dataclasses: GateFinding, CheckResult, Verdict
    reward.py                    # pure tier/reward function (spec §8)
    tasks.py                     # Task, load by manifest, hashing, working-dir materialization
    check.py                     # full run → solution run → per-law fixed point; returns Verdict
    env.py                       # GavelEnv: reset / step / close, dense/sparse, multi-turn
    cache.py                     # (toolchain_hash, task_hash, submission_hash) -> Verdict, sqlite
    trajectory.py                # JSONL writer (spec §13.1)
    metrics.py                   # counters + latency histograms, exported as JSON
    server.py                    # JSON-lines over Unix socket / HTTP (M3)
    cli.py                       # `gavel check`, `gavel validate`, `gavel run`, `gavel bench`
  tasks/                         # public bank: tasks/<tier>/<id>/{prompt.md, LAWS.bend, prelude.bend, solution.bend, meta.json}
  references/                    # hidden: references/<id>/{solution.bend, PROOF.bend, mutants/}
  manifest.json
  tools/                         # authoring pipeline (offline)
    validate.py  mutate.py  degenerate.py  calibrate.py  publish.py  migrate.py
  tests/
    test_lexer.py  test_gate.py  test_check.py  test_reward.py  test_env.py
    adversarial/                 # gate corpus: one file per attack, expected finding
    fixtures/                    # tiny tasks used by tests
```

Python for the harness because the gym API is Python-native and every RL stack
speaks it. The only external process is bun. No Bend knowledge is required on
the caller side (G5).

## 3. Component design

### 3.1 Task format (revised)

```
tasks/<tier>/<id>/
  prompt.md
  LAWS.bend        # import Base; import ./prelude.bend as P; import ./solution.bend as S; laws
  prelude.bend     # immutable predicates and helpers, e.g. P.is_sorted
  solution.bend    # signatures with ?TODO bodies; the policy replaces this file
  meta.json        # see spec §5.4 plus toolchain_hash, proof_header
references/<id>/
  solution.bend  PROOF.bend  mutants/m01.bend ...
```

`meta.json` gains `proof_header`, the exact import block the policy must start
`PROOF.bend` with (Fact 7):

```
import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L
```

Laws are proven by `def L.<law_name>(args):`. The observation includes this
header verbatim so the policy is not guessing module names.

### 3.2 Toolchain pinning

`toolchain/fetch.py` downloads a release tarball, verifies the sha256 published
by the launcher's `latest.json` (or a hash we record), and extracts `bend2/`
into `toolchain/<ver>/`. `toolchain.py` recomputes the tree hash at import and
refuses to run on mismatch. Every verdict carries `toolchain_hash`. bun is pinned
by version string and its path is taken from `GAVEL_BUN` or the vendored copy.

### 3.3 Runner

One check = one subprocess:

```
bun <toolchain>/bend2/main.ts PROOF.bend
  cwd     = fresh tmp dir containing only LAWS.bend, prelude.bend, solution.bend, PROOF.bend
  env     = {PATH: <bun dir only>, HOME: <tmp>, BEND_HUB: "http://127.0.0.1:9", BEND_NO_TELEMETRY: "1"}
  limits  = RLIMIT_AS (2 GiB), RLIMIT_NPROC (small), wall timeout 10 s, stdout/stderr capped at 64 KiB
```

Output parsing yields `CheckResult{ok, unsafe_warning, todo_count, error_block, ms}`.
On Linux the same argv is wrapped by bubblewrap (`--unshare-all`, ro-bind
toolchain + bun, tmpfs cwd, seccomp denying `execve` except bun). The wrapper is
selected by `runner.Backend` and the macOS backend is explicitly marked dev-only.

Latency: 0.2 s cold is bun startup plus one parse of `base.bend`. M3 adds a
persistent bun worker that imports `bend.ts` as a library and checks files over
stdin, which should bring p50 well under 100 ms. Not needed for M0.

### 3.4 Check protocol (per turn)

```
1. gate(submission)                       -> tier 0 on any finding
2. run PROOF.bend (full)                  -> ok  => tier 4
3. run solution.bend alone (with prelude) -> fail => tier 1
4. per-law fixed point:
     proven = {}
     repeat:
       for law in laws - proven:
         write PROOF_i.bend = header + defs[proven] + defs[law]
         run; ok iff output == "Error: K TODOs found." with K == n - |proven| - 1
              (or "All terms check." when K == 0)
         if ok: proven.add(law)
     until no change
   -> tier 2 if proven empty, tier 3 if strict subset
```

Soundness of step 4 rests on Fact 3: a proof that references an unfilled law
fails, so a law is credited only when its proof depends on nothing beyond
already-credited laws and the solution. Cycles get no credit. Worst case
n² runs, typical n+2. A def with an internal `?TODO` inflates K and is not
credited.

Law names and the submitted defs are found by `laws.py`, which reuses the
tokenizer rather than regexes.

### 3.5 Gate

Tokenizer ported from `bend.ts` (`parse_*` functions, lines ~1478–2640 in
2.0.5) into `lexer.py`, tagged with the toolchain version and covered by a
test that round-trips the vendored `base.bend`. The gate scans tokens of each
submitted file and rejects on:

- file set ≠ {`solution.bend`, `PROOF.bend`}; any file > 64 KiB
- `@unsafe`; `law`; `main`; foreign import (`import` followed by a string);
  hub import (`import 0x…`); any `import` other than `Base` and the four task
  files; `do IO`
- top-level names in `solution.bend` outside `policy_targets ∪ solution.*`
  helpers; top-level names in `PROOF.bend` outside `L.<law>` and `Policy.*`
- names that collide with `prelude.*`, `LAWS.*`, or Base (belt-and-braces over
  Fact 4)
- integrity: sha256 of `LAWS.bend` and `prelude.bend` in the working dir must
  equal `meta.json` after the submission is written

`tests/adversarial/` holds one file per row above plus every probe from §0; CI
fails if any yields a passing gate or a credited law.

### 3.6 Reward

`reward.py` is a pure function `(GateResult, CheckSummary, n_laws) -> (tier, reward)`
implementing spec §8 exactly, plus `difficulty_weight`. Dense multi-turn mode
returns the delta of the best-so-far tier reward. Property-tested: monotone in
proven count, 0 for tiers 0/1, 1.0 only at tier 4.

### 3.7 Env

```python
env = GavelEnv(bank="manifest.json", mode="dense", max_turns=4, backend="auto")
obs = env.reset(task_id=None)   # sampler by default
obs, r, done, info = env.step({"files": {"solution.bend": ..., "PROOF.bend": ...}})
```

`obs` is the spec §6.2 dict plus `proof_header`. `info` is the full `Verdict`.
`close()` flushes trajectories and metrics. A `GavelEnv.batch(actions)` helper
runs verdicts through a `concurrent.futures` process pool for throughput.

### 3.8 Authoring tools

- `tools/validate.py <task>`: V1–V5. Runs reference, runs every mutant against
  the reference proof (must fail), runs the degenerate library (empty, identity,
  constant, head) against the reference proof (must fail), lexes all files
  through the gate, records `reference_check_ms`.
- `tools/mutate.py`: rule-based mutants over the reference solution: swap
  match arms, drop a cons, off-by-one on `Nat` literals, replace recursive
  call argument with the parameter, swap operands.
- `tools/calibrate.py`: k zero-shot attempts with a configurable model via the
  env API; writes `zero_shot_solve_rate`.
- `tools/publish.py`: hashes the task, appends to `manifest.json`.
- `tools/migrate.py`: re-validates the whole bank against a new toolchain and
  writes a quarantine report.

### 3.9 The tiers

SPEC §10 defines five tiers by proof technique rather than by code length, and
the milestones below are written in those numbers. The definitions are SPEC's;
they are repeated here because M2 ("tiers 1–4") and M4 ("including tier 5") are
phrased in tiers that a reader of this file otherwise cannot decode.

| Tier | Proof technique | The bank's example |
|---|---|---|
| 1 | Reflexivity, direct computation | `t1-add-plus` |
| 2 | Single structural induction, one rewrite | `t2-rev-append` |
| 3 | Induction with auxiliary lemmas the policy must state | `t3-tree-flatten` |
| 4 | Invariant preservation over a data structure | — |
| 5 | Program-level laws with state and multiple interacting functions | — |

**The bank's ceiling is tier 3.** Of the 81 registered tasks, 20 are tier 1, 46
are tier 2 and 15 are tier 3; no task is tier 4 or tier 5. A tier is not part of
the curriculum until a task exists at it and a reference proves it, so both
numbers in M2 and M4 are currently unmet by construction rather than by
oversight.

Tier 4 is the first tier whose *law* is about a predicate the task declares
rather than about a function it defines — `t3-tree-flatten` already carries a
`P.Tree` in its prelude and is the closest the bank comes, but its laws measure
the tree, they do not preserve an invariant across a step. Tier 5's two
canonical examples in SPEC §10 (`you_cant_win`, a ledger summing to zero) are
not in the vendored tree: `toolchain/2.0.5/bend2/` is `main.ts`, `bend.ts`,
`comp.ts`, `base.bend` and `effs/`, with no `demos/`, so tier 5 has to be
written fresh rather than ported.

## 4. Milestones and work packages

### M0 — Feasibility (target: 2 weeks)

Exit: 20 tasks tiers 1–3, `gavel check` CLI, p50 < 1 s, zero-shot solve rate 10–60%.

1. `toolchain/`: vendor 2.0.5, hash, bun pin, `toolchain.py` verification. *(½ day)*
2. `runner.py` macOS/Linux-plain backend, output parser, timeout, rlimits, tests against the §0 probe files. *(1 day)*
3. `laws.py` + minimal `lexer.py` (enough to find top-level `law`/`def` names and imports). *(1 day)*
4. `check.py` protocol §3.4, `reward.py`, `verdict.py`, tests with a 3-law fixture covering ok / partial / cyclic / TODO-inflated cases. *(2 days)*
5. `tasks.py`, `manifest.json`, `cli.py check|validate`. *(1 day)*
6. `tools/validate.py` V1, V4, V5 (mutants come in M1). *(½ day)*
7. Author 20 tasks by hand with references: tier 1 (`add_zero`, `length_lit`, `bool_not_not`, ...), tier 2 (`add_comm`, `append_nil`, `reverse_reverse`, `length_append`, ...), tier 3 (insertion sort ascending+perm, `filter` length bound, ...). Each proof verified with the pinned checker. *(4–5 days; the long pole)*
8. `env.py` single-turn, in-process; `tools/calibrate.py` against one frontier model; record numbers. *(1 day)*

### M1 — Gate

1. Full tokenizer port with `base.bend` round-trip test. **Done** (M1.1).
2. `gate.py` all rules; `tests/adversarial/` corpus (≥ 30 files). **Done** — 42 payloads.
3. `tools/mutate.py`, `tools/degenerate.py`; V2/V3 wired into `validate.py`; all 20 tasks pass. **Done.**
4. Linux bubblewrap backend + Dockerfile that installs pinned bun and copies `toolchain/`; CI runs the adversarial corpus inside it. **Done, and blocking** — green in run `35338052842`; see below.
5. Mutant-consistency tripwire (§7.4.2) in `check.py`. **Done** (M1.5). The tripwire compares whole files rather than hashes, because a policy is free to submit a different proof for the same solution; a digest match would have to be a digest of the solution alone, which is the same comparison with less to read in the log.

**M1.4 status.** `runner.BwrapBackend` (`--unshare-all`, read-only root with the
check's directory bound back over it, `--die-with-parent`), `select_backend`,
the `backend` field on every `CheckResult`, `Dockerfile`, `.dockerignore`, CI,
and `tools/sandbox_check.py` are all in place, and as of run `35338052842` the
job that runs them is green and blocking.

The run was the part that could not be substituted. This machine is macOS, so
there is no bubblewrap and no way to execute the path here, and a unit test of
the argv would pass on a host where bubblewrap cannot create a user namespace at
all — which is the failure that matters, because it is silent.
`tools/sandbox_check.py` closes that gap by requiring a *real* check to reach
tier 4 under the sandbox rather than by asserting on flags, and the CI `sandbox`
job runs it plus the adversarial corpus in the container. Getting the container
permissive enough took four flags, measured one at a time (Fact 25), and the
first run that got through failed a test — a stand-in checker in `tmp_path` that
the sandbox shadows with a fresh tmpfs on `/tmp`, which had passed on the plain
backend for its whole life. That failure is the argument for making the job
blocking, so it is now `continue-on-error: false`.

Fail-closed is the design decision worth naming: `select_backend("bwrap")`
raises when bubblewrap is absent, and `auto` raises on Linux rather than
downgrading. A silent fallback would produce a verdict that looks sandboxed in
every field except the one nobody reads. A job that is genuinely not about
isolation opts out once, at configuration time, with `GAVEL_BACKEND=plain` —
and the resulting verdicts say `dev_only: true`.

### M2 — Bank v0.5

1. Authoring pipeline as an agent loop over the env API (translate → laws →
   reference → mutants → calibrate → publish), with human review checkpoint for
   tier ≥ 3. **Done, as a driver rather than as a generator.** `tools/author.py`
   runs the stages in order and refuses to carry a task past one it has not
   passed: files → derive → mutants → V1–V5 → episode → review → publish. Two
   of the seven are model work — nothing here translates a module or invents a
   law — so what is automated is the part the plan can hold to a rule, and what
   is not is named as not.
   The mutants stage was added after the fact and is the clearest evidence the
   stage list was wrong: SPEC's loop has mutants between the reference and
   calibrate, the driver went straight from the reference to V1–V5, and so every
   fresh task died at `invariants` on "V2: no mutants authored" — a verdict
   about a task that was really a step nobody ran, for the one part of the loop
   already mechanised in `tools/mutate.py`. It generates a corpus only when
   `references/<task>/mutants/` is empty, because a corpus is the one part of a
   task a person can improve by hand and re-running the pipeline must not
   silently replace it.
   The episode stage is not a duplicate of V1. V1 asks whether the checker
   accepts the reference; the episode asks whether the task *rewards* it — gate
   open, tier 4, reward 1.0, done on the first turn — through the same
   `GavelEnv` the training loop drives, so the pipeline cannot be satisfied by
   a task the loop would not be.
   The review binds to a revision, not to a task id: approval is recorded
   against the hashes `tools/publish.py` derives from `LAWS.bend` and
   `prelude.bend`, so editing either makes the approval stale and reopens the
   checkpoint. A checkpoint that survives an edit to the thing it was reviewing
   is a signature on an empty page.
2. 200 tasks tiers 1–4; CI job runs `validate.py` over the manifest. **In
   progress** — 81 tasks (20 tier 1, 46 tier 2, 15 tier 3), validated together
   rather than per task, because a task is sound only against a corpus that
   shares the degenerate generator with it: 81/81 valid over 1507 checker runs.
   Tiers 4 and 5 are empty (§3.9), so the 200 has a ceiling on what the bank
   can currently contribute to it.

   The CI job is `uv run python -m tools.validate`, deliberately without
   `--strict`. Every task in the bank carries the same warning — calibration
   has not run, so no `zero_shot_solve_rate` is recorded — and `--strict`
   promotes warnings to failures, so switching it on now would fail every task
   for a reason that is not about any of them. `--strict` is the right mode the
   moment calibration exists, and not before: a green build has to mean
   "checked and fine", not "not checked yet", which is exactly why the warning
   is reported at all rather than being silently absent.

   A tier-3 task goes in with a hand-authored mutant corpus (4 to 22 files).
   That corpus is V2's evidence and the part of a task a person does better
   than a generator, which is why `tools/author.py`'s mutants stage keeps one
   rather than replacing it. Registering a task that fails validation is worse
   than leaving it out, since the manifest is what a training loop trusts.

   **The CI gate outgrew a serial pass, and that was measured rather than
   foreseen.** At 58 tasks, "The bank validates" ran for over 18 minutes with
   nothing else on the runner — the cost is one bun process per check and about
   15 checks per task, so it grows with the bank and would have been hours at
   M4's 500. `tools/validate.py` now takes `--jobs N` and CI passes 4; a task's
   checks are independent (own workdir, own checker process, no shared mutable
   state in the check path), and `map` keeps the reports in task order so the
   output is unchanged.

   Measured on the runner, which is the only number that matters here: the step
   took **20 m 09 s** over 59 tasks serially and **8 m 30 s** over 62 at
   `--jobs 4`. More tasks, less than half the time. A local comparison on 12
   tier-3 tasks gave only 200 s → 110 s, because five other checker processes
   were running on the same box; the runner has no neighbours, which is why the
   local figure was the pessimistic one.

   The series continues, because one point is a coincidence and three are a
   slope: at **81 tasks the step took 9 m 29 s** (run `35343671771`), which is
   a third more bank for 12% more time. 1210 checks in 569 s on four jobs is
   about 2.1 checks/s. That is the shape a per-check process should have --
   throughput set by the runner's cores rather than by the bank's size -- and
   it is also the reason a worker (M3.4) would buy a constant and not a curve.

   The check count is not a property of the bank's size alone, and Fact 28 is
   why: the `vary-*` family added one run per argument-ignoring body per
   function, taking the same 81 tasks from 1210 checks to **1507**
   (81/81 valid, measured serially on this machine). A task with more
   same-typed parameters costs more to validate than one with fewer, so the
   cost per task now varies with the signatures and not just with the tier.
   CI's `--jobs 4` step should be re-timed rather than extrapolated from the
   9 m 29 s above.

   `--jobs` is off by default, and that is not timidity. V4 asserts
   `reference_ms` against a wall-clock budget, so validating concurrently
   inflates the very quantity being checked: a loaded box can fail a task that
   is fine, and it would fail it with a confident number beside it. CI can
   afford four at once because its runner is otherwise idle and the checks
   measure ~200 ms against a 2000 ms budget; a developer's laptop cannot make
   that assumption, so it is theirs to make.

   **A manifest is a claim about a revision, and two writers make it a claim
   about two.** `eafd7c5` committed a 62-entry manifest with only two of the
   three task directories behind its new entries: `t3-sum-acc` had been
   registered by the authoring agent while I was adding the other two, so the
   manifest was ahead of the commit and `load_manifest` failed on every
   checkout — 189 errors and a red sandbox job. Nothing was wrong with the
   bank; the commit simply named a task it did not contain. The check that
   catches it takes a second and is worth stating plainly: **every manifest
   entry must resolve to a directory inside the same commit**, which is a
   property of the commit and not of the working tree, and so cannot be seen
   from the tree that produced it. This is the second cost of a file two people
   write; the first was the review records in Fact 27, and the fix for both is
   the same — one writer, or a check that runs against the revision rather than
   the tree.
3. `tools/migrate.py` and a dry run against 2.0.4 to measure churn. **Done, and the answer is not the expected one** — see below.

**M2.3 churn, measured.** The plan assumed syntax drift across releases ("three
releases shipped in one day during probing"). The bank was run against every
checker the launcher has on disk — 2.0.3, 2.0.4, 2.0.5, three distinct trees:

| candidate | tree | clean | quarantined |
|---|---|---|---|
| 2.0.5 (the pin, control) | `121c70615f2d` | 20/20 | 0 |
| 2.0.4 | `ca88ac8cc948` | 20/20 | 0 |
| 2.0.3 | `90127d834526` | 20/20 | 0 |

**Zero churn across three releases.** The 2.0.x churn does not reach any
construct this bank uses: every task is `import Base`, inductive `def`s,
`law … for … {… == … : T}`, and `{==}` / `%e : P` proofs. That is worth stating
plainly because it revises the risk in §5 downward — for *this* bank, at *this*
size, the version bump is not the live hazard. It would be a mistake to read it
as "Bend is stable": the sample is 20 tasks by three authors all working from
the same guide, and the constructs the bank avoids are exactly the ones the
guide does not cover. The hazard is unmeasured, not absent.

`--from` takes any directory containing `bend2/`, so a candidate is measured
without vendoring it; nothing is written to the repository except the report.
The negative control is what makes the three zeros mean something: a copy of
2.0.5 with the success line changed from `All terms check.` to `Everything is
fine.` quarantines **20/20** and quotes the new line back as evidence. Both
directions are tested in `tests/test_migrate.py`, because a dry run that reports
"0 quarantined" for every candidate is indistinguishable from one that never
looks.

### M3 — API

1. Multi-turn env with dense/sparse modes; feedback truncation. **Done** — M0
   item 8 built it; `tests/test_env.py` covers the dense/sparse distinction,
   the improvement-only payment, the feedback path, and the episode bounds.
2. `cache.py` (sqlite), `trajectory.py` JSONL, `metrics.py` export. **Done.**
   The cache is a memo over everything a verdict is a function of (see the
   deviation above); a hit is marked `cached: true` and keeps the original
   `ms`, so nothing downstream mistakes a lookup for a check. The trajectory is
   append-only JSONL, flushed per line, and a reader skips a half-written final
   line rather than failing — the reason for the format is that a killed soak
   should still be worth reading. Metrics are derived from the same records the
   log holds, asserted equal by test, so a finished run and a watched run
   cannot disagree. `GavelEnv.close()` ends any open episode (an abandoned
   episode is data) and closes the trajectory; it deliberately leaves the cache
   open, because a memo shared across envs must outlive any one of them.
3. `server.py` JSON-lines over Unix socket + HTTP; client example in a
   non-Python stack. **Done.** Sessions rather than connections — HTTP has no
   connection to hang an episode on — so `reset` mints an id that every later
   request carries, and sessions share the bank, toolchain, cache, trajectory,
   and metrics while each keeps its own turn counter. Both transports call the
   same `GavelServer.handle`, so a bug in one is a bug in both. A malformed
   frame is answered with an error and the connection stays open; a client that
   sends one bad line should lose that line, not the run. The Unix socket is
   chmod 600, because the socket *is* the access control when the payload is
   arbitrary programs. Client example: `examples/client.ts`, run by the bun the
   checker is already pinned to, and covered by a test that starts a real
   server (`tests/test_server.py`).
4. Persistent bun worker backend; publish p50/p95/p99 and verdicts/min/core.
   **Half done: the numbers are published, the backend is not built.**
   `tools/soak.py` reports p50/p95/p99 and verdicts/min/core from a real run,
   but every check is still a fresh `bun bend2/main.ts`, so what those numbers
   measure is the process-per-check design rather than a check. Fact 24 is the
   bound on what a worker could win, measured rather than argued: a file
   containing `import Base` and nothing else costs what the bank's heaviest
   reference proof costs, so the whole per-check time *is* the constant a
   worker would eliminate. It is a real win and it is the only one. Not built
   because the checker process *is* the thing the sandbox is a boundary around —
   `gavel/runner.py` reasons about a process it starts, scrubs, limits, and
   kills, and none of those apply to a worker that outlives the check.
5. 10k-episode unattended soak with a scripted policy. **Done** —
   `runs/soak-10000`, run `20260918T092845Z-189b5e5b`, exit 0, no human in the
   loop and none needed: the log's printed counters were reconciled against
   `metrics.json` and agree, and the run was left unattended to completion.

   | | |
   |---|---|
   | episodes | 10000 of 10000 (33538 turns) |
   | solved | 4939 (49.4%), mean reward 0.573, mean turns 3.35 |
   | best tier | 0:1015 2:2635 3:1411 4:4939 |
   | throughput | 636 verdicts/min (80/core) over 3165 s on 8 jobs |
   | latency | p50 320 ms, p90 418, p95 456, p99 524 (29478 fresh checks) |
   | cache | 0 hits / 33538 lookups, 33538 rows |
   | incidents | 0, and 0 unexpected; 4060 gate rejections |

   Three things this bought beyond the number. The **0% cache hit rate is a
   property of `--policy noisy`**, not of the cache: a scripted policy that
   varies its submission every turn never asks the same question twice, so the
   soak measures the cache's cold path and none of its warm one. Mean turns
   3.35 against `max_turns 4` with 10% of episodes ending at tier 0 says the
   policy is being pushed to the bound rather than idling inside it. And the
   latency figures are **contended** — the soak ran on 8 jobs on this machine
   while the session was building and testing on it, which is why p50 320 ms
   here and ~180 ms quiet (Fact 24) are both true and not in conflict. Re-run
   on an idle box before quoting a throughput number to anyone.

### M4 — Bank v1.0

Exit: 500+ tasks including tier 5, human-reviewed laws for tier ≥ 3, published
throughput benchmark, an external training run reporting a solve-rate curve.
The four have four different states, and only the first is work rather than a
waiting room.

1. **500+ tasks including tier 5. Not started beyond 81.** The ceiling is §3.9:
   the bank holds no tier-4 task and no tier-5 task, so this is a scale problem
   and not a design one -- the pipeline is the one that already produced 81
   tasks, and the check that keeps it honest (a manifest entry must resolve to a
   directory inside the same commit) exists and has already caught its own
   failure once. Tier 4 is being authored now, a task at a time; tier 5 has no
   reference implementation anywhere in the vendored tree and has to be written
   from SPEC §10's description.
2. **Human-reviewed laws for tier ≥ 3. Not satisfied, and the bank says it
   is** -- see below.
3. **Published throughput benchmark. Blocked on a quiet machine, not on the
   harness.** `tools/soak.py` reports p50/p95/p99 and verdicts/min/core from a
   real run, and M3.5's ten-thousand-episode soak produced all of them. They
   were taken with eight jobs running while the session built and tested on the
   same box, both runs since have been on a machine at load 100 or more, and a
   contended latency percentile is not a published one. The measurement is one
   command away; what it needs is an idle host.
4. **External training run. Blocked on a model.** Nothing in this repository
   conjures the policy, and the calibration path that would record a
   `zero_shot_solve_rate` answers 403 (Cloudflare 1010) from here. That block is
   deliberately left standing rather than worked around: a harness that
   misrepresents itself to a third party to obtain a number is not a harness
   whose numbers mean anything.

**The review half of this is not satisfied and the bank currently says it is.**
Eleven tier-3 tasks carry `"reviewed": {"by": "lulzx"}` written by the authoring
agent through `--reviewer`, and no human has read them — Fact 27. The records
are left in place rather than deleted so the defect stays visible, but they must
not be counted as review, and the fix is not in the checker: either review is
recorded somewhere the pipeline cannot write, or the laws are read and the
records are made true. Until then this line stays in M4.

## 5. Risks

- **Syntax churn.** Bend went 2.0.3 → 2.0.5 in under 24 h. Mitigation: the bank is pinned, `migrate.py` exists from M2, and the tokenizer is version-tagged. *Revised down by M2.3:* the whole bank was re-validated against 2.0.3 and 2.0.4 with zero quarantine, so for these constructs the churn is not the live hazard. The mitigation stays because the sample is 20 tasks that all stick to the constructs the Bend guide covers — the unmeasured risk is the constructs a larger bank would reach for.
- **Checker soundness.** The guide says the Lean model lags the implementation. Mitigation: mutant tripwire, adversarial corpus, and success keyed on exact output, not exit code.
- **Authoring throughput.** Hand-written proofs in a no-tactics language are slow. M0 deliberately keeps 20 tasks small; M2 relies on the agent loop.
- **Fact 8 cost.** Per-law runs multiply latency on failed turns. Bounded by n² × 0.2 s with n ≤ 5, and the persistent worker in M3 shrinks the constant.

## 6. First actions

1. `uv init`, vendor 2.0.5 into `toolchain/`, commit the hash.
2. Port the §0 probe files into `tests/fixtures/add_zero/` as the first task and the first adversarial cases.
3. Implement `runner.py` and `check.py` against that fixture, then iterate on tasks.
