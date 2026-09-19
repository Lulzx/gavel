# The checker as a reward

Bend's checker is a dependency-free TypeScript program run by bun. Gavel
invokes `bun bend2/main.ts` on one file and reads what it prints. Two measured
properties of that program dictate the shape of everything in `gavel/`.

## It reports only the first type error

One run of a proof file cannot tell you which laws passed. It tells you the
first thing that went wrong and stops.

So partial credit is computed by a fixed-point loop of isolation runs
(`gavel/check.py`). Each run contains the proof of one law plus the proofs of
every law already credited, and the law is credited if the run leaves exactly
the uncredited laws open and nothing else. A proof that leans on a law not yet
credited fails outright, and a proof with an internal hole inflates the open
count and is never credited.

The loop is bounded: at most `n` passes over `n` laws, and a hard cap on
checker runs per verdict.

## A proof may cite only laws declared earlier

`book_valid` walks the file in declaration order and registers each definition
into the namespace only after checking it. Circular and backward references
are impossible, not merely forbidden.

One consequence: a full proof that passes is sound on its own.
The isolation runs never grant credit the full run could not have earned. They
only attribute it.

## Success is a sentence, not an exit code

Two things exit 0 without proving anything:

- a file carrying `@unsafe`, which switches off the termination checker and
  prints a warning instead of the success line.
- a file declaring `main`, whose output replaces the success line.

A third thing checks without proving anything: a file that never imports
the laws. Nothing in it can fail, and since `LAWS.bend` is what imports the
solution, nothing in it checks the implementation either. An empty proof file
read tier 4 until 2026-09-20. The gate now requires the import, and the
protocol reads a checking full run as complete only if the file opened every
law and defined a proof for each.

So `ok` means: exit 0, stdout is exactly `All terms check.`, no unsafe
warning, no timeout. The gate refuses both constructs before the checker runs,
on the token stream rather than the text, so `"@unsafe"` inside a string is not
mistaken for the real thing. The runner's stricter reading is the layer that
holds if the gate is ever wrong.
