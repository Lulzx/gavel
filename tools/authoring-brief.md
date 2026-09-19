# Authoring contract: new Gavel tasks

Repo: `/Users/lulzx/work/gavel`. Run every command from there (the manifest is
resolved relative to the cwd). Bend is pinned to 2.0.5; the checker is vendored.

This brief used to live in `/tmp`, and this repository's record has lost
instruments to `/tmp` cleanups twice — the screens had to be rewritten from
scratch to re-derive readings already written down. It lives here now, next to
the pipeline it describes. The counts below are refreshed by hand; if they look
stale, re-derive them with the commands under "Distinctness".

## What a task is

A task is a *reward function*. It ships a mutable `solution.bend` stub with
`?TODO` bodies, an immutable `LAWS.bend` and `prelude.bend`, and a `PROOF.bend`
that proves the laws against the reference solution. The Bend proof checker is
the reward signal. The policy rewrites `solution.bend` and `PROOF.bend` only.

The worked example to copy the *shape* from, and nothing else:

    tasks/1/t1-len-map/{prompt.md,LAWS.bend,prelude.bend,solution.bend}
    references/t1-len-map/{solution.bend,PROOF.bend,prelude.bend}
    tasks/1/t1-len-map/meta.json          # generated; do not hand-write it

Read all seven before writing anything.

## Files you create for one task `t<N>-<slug>` at tier `<N>` (1 or 2 only)

    tasks/<N>/<id>/prompt.md        the problem statement, in the site's voice
    tasks/<N>/<id>/LAWS.bend        `import Base`, `import ./prelude.bend as P`,
                                    `import ./solution.bend as S`, then `law`
                                    declarations
    tasks/<N>/<id>/prelude.bend     the immutable helper defs, if the task needs
                                    any. An empty prelude is not allowed: it
                                    must contain at least the `import Base` line
                                    and whatever the laws reference as `P.*`.
    tasks/<N>/<id>/solution.bend    the STUB: `import Base`, `import ./prelude.bend
                                    as P`, then each target def with a `?TODO`
                                    body (copy the style of t1-len-map: a short
                                    `# TODO(policy):` comment then `?TODO`)
    references/<id>/prelude.bend    byte-identical copy of the task prelude
    references/<id>/solution.bend   the REFERENCE: the same defs, implemented
    references/<id>/PROOF.bend      the proofs, one `def L.<law_name>(...)` per law

Do NOT create `mutants/` before your first `tools/author.py` run — the pipeline
generates the corpus, and only when the directory is empty. After it has, add
the hand mutants the base-case rule below requires; the pipeline keeps them.

Do NOT write `meta.json` by hand. `tools/author.py` derives it.

## Publishing is not yours

Do NOT run `uv run python -m tools.publish` against the real `manifest.json`,
and never run it with no arguments. Do not edit `manifest.json`.

Author with a scratch manifest instead, so parallel runs cannot race on the
bank:

    uv run python -m tools.author tasks/<N>/<id> --manifest manifest.scratch.<YOURTAG>.json

where `<YOURTAG>` is the tag in your assignment. Exit code 0 means every stage
passed. Iterate until it does.

**NEVER pass `--reviewer`.** It writes a review record that claims a human read
the laws. No human has, so the record is a forgery. Tier 1 and 2 do not need it.

## The stages, and what each one refuses

    files       every file present and non-empty
    derive      meta.json from the task's own files
    mutants     generate a corpus; refuse if any mutant still proves every law
                (an escaping mutant means a law the body does not have to obey),
                or if none of them type-checks (no law was exercised)
    invariants  V1-V5 (V2 is the mutant corpus, V4 is a latency budget)
    episode     score the REFERENCE through the env: it must earn reward 1.0 at
                tier 4 on the first turn, or the task does not pay what its laws
                say
    publish     the manifest entry

`mutants` and `episode` are the two that catch real defects, so do not treat a
green run as decoration: if `mutants` reports an escape, the law set is too weak
for the body and you must add a law or fix the reference, not delete the mutant.

## Rules that a green run does NOT enforce

These are the defects that survive every stage, so they are on you:

1. **The stub must be a stub.** `tasks/*/solution.bend` must leave every target
   unimplemented (`?TODO`). A stub that ships the reference passes everything
   and is not a task. The reference lives only in `references/<id>/solution.bend`.
2. **The laws must determine the body.** Write the corpus you would want and
   check by hand that a wrong body fails. In particular a law that is a *pin*
   (`f(Nil{}) == Nil{}`, `f(x <> Nil{}) == ...`) makes every mutant die on the
   pin and leaves the value laws with no independent weight. Prefer laws with
   content, and say in the prompt which law pins what.
3. **No empty case left unconstrained.** If a law mentions `Nil{}`, ask whether
   any mutant that type-checks actually fails it. The empty case is the case
   generated mutants miss most.
4. **The prompt must not hand over the proof.** Describe the laws and why each
   is there (as t1-len-map's prompt does); do not write the tactic.
5. **No target is left free by the shape of the law that names it.** Two shapes
   have been measured at full reward in the published bank, both paying a body
   that is the reference at *no* input:
   - a target a law set mentions **only inside a premise** (`for e: {S.g(t) ==
     True{}}`) is constrained by nothing: the submission decides whether the
     premise is inhabitable, and a body that falsifies it makes the law vacuous.
     Give every helper a law of its own.
   - a target whose every law names it **on both sides** of the `==` is free up
     to a cancelling wrapper: `f(xs) = c ++ ref(xs)` satisfies every such law
     when the constant cancels. A relative law is not an anchor — add one law
     whose right-hand side does not call the target (`f(Nil{}) == Nil{}`).
   Run the screens before you ask anyone to look at the task:

       uv run python -m tools.screens anchors  manifest.scratch.<YOURTAG>.json <task-id>
       uv run python -m tools.screens general  manifest.scratch.<YOURTAG>.json <task-id>
       uv run python -m tools.screens positions <task-id>

   A flag is triage, not a defect, and a clean run is not a proof — but all
   three of the tier-4 holes this bank was paying full reward for on 2026-09-19
   would have been flagged by `anchors` (the premise-only pair by A, the two
   tier-1 wrappers by B), and `general` catches the fourth shape, a law set that
   reaches a target only at closed arguments.

## Distinctness: the hard constraint

The bank already has **215 registered tasks** (plus one tier-3 task held at the
review checkpoint — it carries a `HOLD` file, which is what keeps it out of the
bank — and three directories parked under `tasks/2/_abandoned/`), **745
distinct law names** across **364 distinct def names** and **219 distinct policy
targets**. A new task must be a new *function*, not the same function at another
tier, and its law names must not collide with an existing one.

Those three counts are over the *registered* bank. The grep below reads
`tasks/*/*/LAWS.bend`, which also matches a task held on disk but not published,
so it prints **751** law names and **366** def names for the same tree — the 6
and the 2 are `t3-swap-sum-pair`'s. Quote the registered figures; if a grep
disagrees, find the task that accounts for the difference before changing the
count.

Before authoring, run these and read the output:

    ls references/ | sed 's/^t[0-9]-//' | sort -u        # existing slugs
    grep -rhoE '^law [a-z0-9_]+' tasks/*/*/LAWS.bend | sed 's/^law //' | sort -u

And grep for the specific function you intend to introduce:

    grep -rn 'def <name>' tasks/*/*/prelude.bend tasks/*/*/solution.bend \
                          references/*/solution.bend

The full list of taken def names is 364 entries long, so grep rather than
guess. `append`, `len`, `map`, `rev`, `sum`, `take`, `drop`, `zip`, `filter`,
`is_sorted`, `replicate`, `snoc`, `max`, `min`, `pow2`, `insert`, `merge`,
`mirror`, `inorder`, `flatten`, `nth`, `pad`, `absdiff`, `sub`, `mul`,
`is_pal`, `prefixes`, `split`, `interleave`, `all_*`, `sum_*`, `has_*`,
`*_all`, `assoc_lookup`, `assoc_put`, `assoc_update`, `count_while`,
`take_while`, `drop_while`, `count_up`, `count_down`, `diffs`, `pairs`,
`chunk_two`, `join_two`, `span_below`, `partition_below`, `run_max`,
`scan_add`, `zip3`, `map_len`, `longest_row`, `snoc_each`, `front_each`,
`swap_each`, `sum_pair`, `keys`, `values`, `intersperse`, `cmp`,
`count_below`, `dedup`, `divmod3`, `extremes`, `ext_go`, `fib_pair`,
`sum_fib`, `tree_map`, `snoc_tree`, `rotate`, `nat_bits`, `sum_odd`,
`sum_even`, `clamp`, `indexed`, `build`, `dot`, `count_inv`, `best_gain`,
`lcp_len`, `longest_run_len`, `second_max`, `sec_go`, `collatz_len`,
`digit_sum`, `is_pow2`, `tree_depth_sum`, `same_shape`, `lex_le`, `path_sum`,
`max_prefix_sum`, `max_prefix_sum_go`, `run_starts`, `run_starts_go`,
`replace_at`, `indices_of`, `argmax`, `argmax_go`, `distinct`, `distinct_go`,
`nth_from_end` are all taken. If the function you
want is on that list, pick another one.

Good hunting grounds that the list above does not cover — **but check the
candidate's *function*, not its name, and read the prompt of any existing task
that might be it.** The grep above searches for the name, and a collision
between two names for one function returns nothing: on 2026-09-19 this paragraph
shipped a list of which seven of twelve names resolved to a function the bank
already has — six as registered targets under another name, one as a prelude
helper. `range` is `count_up` (`t2-count-up-down`); `pair_up` is `pairs`
(`t2-pairs-laws`) if you mean a sliding pairing or `chunk_two`
(`t2-chunk-two-join-two`) if you mean disjoint chunks, which is why two authors
read it two ways; `nat_to_bin` in its only admissible form is `nat_bits`
(`t2-nat-bits`); `tree_depth` is `height` (`t3-height-mirror`); `rotate_left` is
`rotate` (`t1-rotate`); `flat_map` is `concat_map` (`t2-concat-map`); and
`tree_fold` has been taken since, by `t2-tree-fold`. `tree_leaf_count` is the
permitted kind of repeat — it is the prelude helper `leaves`, and a helper
repeating across tasks is not a target collision, so do not refuse a task for it.
**A missing name is not a free function.**

Dead for reasons of the checker rather than the bank: `qsort` and `msort`
recurse on a computed list and are refused at the *reference* (`expected : a
decreasing self-call`), so no tier-2 law set survives; width-free `nat_to_bin`
dies the same way; `apply_n` needs a function argument applied twice, which the
single-use discipline refuses.

`carry_add` is **unprobed, not refused**. One author dropped it claiming
`Nat.mod`/`Nat.div` do not exist, having grepped `toolchain/2.0.5/bend2/src` — a
path that does not exist, whose empty output was read as absence. Both are in
`base.bend` (`Nat.div` line 615, `Nat.mod` line 622, over `Nat.divmod` at 569),
and `base.bend` is what a task imports as `Base`. Try it first.

Beyond names: mutual recursion between two small functions, and any two-function
*interaction law* (a law whose two sides use two different functions the policy
must both implement) that is not already in the bank.

**Check the target set as well as the law names.** The 219 policy targets in
the bank are the names a task *asks a policy to implement*; two tasks asking
for the same function at the same tier is the collision, and the verifier
reads `meta.json`, not the preludes, to find it. A prelude helper name like
`len` or `max` legitimately repeats across tasks — do not let that stop you.

## The base-case rule, which is the one that keeps costing us

**Every law whose left-hand side is a ground term — `f(Nil{}) == ...`,
`f(0n) == ...` — needs a mutant you write by hand, and you must measure it.**
The generator rewrites a *step*; an empty case is an *answer* reached by a
match that has already stopped, so 32 laws across the last three batches had no
mutant failing them while every stage, and `tools/validate.py`, reported the
task valid.

Write the mutant after the pipeline has generated its corpus (the pipeline
keeps whatever is already in `mutants/` and will not overwrite you). The shape
is: the reference `solution.bend` with that one case given a non-empty answer.
Then measure it — **not** with `tools/mutate`, which unlinks `mutants/*.bend`
first — but with:

    uv run gavel --manifest manifest.scratch.<YOURTAG>.json check <task-id> \
      --solution references/<id>/mutants/<your-file>.bend \
      --proof references/<id>/PROOF.bend --backend plain --json

Read the `tier` and the `laws_failed` list, not the `reward` field: a
byte-identical copy of a shipped mutant has its reward zeroed by SPEC 7.4.2
while its tier stays what it is. You are done when the tier is 3 and your law
is in `laws_failed`. A mutant that reads `tier 1` is not evidence of anything —
it did not type-check, so fix the signatures (`+x` for a binding used twice)
or the body. Put the measured verdict in the file header, as
`references/t2-pairs-laws/mutants/pairs-single-answers-a-pair.bend` does.

## The proof language

No tactics. `PROOF.bend` is checked by the same checker as the code.

- A proof def is `def L.<law_name>(<the law's binders>):` with a body that is a
  sequence of steps. `{==}` closes a goal the checker normalises to an identity.
- An induction is `match xs:` with `case Nil{}:` and `case h <> t:`, and inside
  the cons case the induction hypothesis is introduced with
  `%L.<law>(t) : {<the goal with the hole>}`.
- `%e : P` rewrites the hole to `e`'s left-hand side. Match before you rewrite.
- A goal you cannot close is usually a missing generalization: the accumulator
  or the measure has to be universally quantified in the *law*, not invented in
  the proof. If you are stuck for more than a few attempts, change the law.

The exact proof files that already work are the best reference; read several
before writing one — `references/t2-rev-append/PROOF.bend` and
`references/t2-sum-acc/PROOF.bend` are two good ones.

## What to report

For each task, in under 300 words total:

- the task id and tier
- the function(s) the policy must implement
- each law name and one clause saying what it pins
- the exact command you ran and its exit code
- anything the run told you that you did not expect (a rejected mutant, a
  warning, a stage you had to retry and why)

Say plainly if a task did not converge. A reported failure is useful; a task
padded to look finished is not.
