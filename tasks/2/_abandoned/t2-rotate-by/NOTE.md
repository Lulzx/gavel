# Abandoned before authoring: `t2-rotate-by` is the bank's `t1-rotate`

The assignment was `rotate_by(n: Nat, xs: List<&2, Nat>) -> List<&2, Nat>`, a
left rotation by `n` positions, on the premise that `t1-rotate` "is **not** the
bank's `rotate`, which rotates by one". The premise is wrong: the bank's
`t1-rotate` is a rotation by `n`, and the two functions are the same function.

`tasks/1/t1-rotate/prompt.md`:

> `rotate(n, xs)` moves the first `n` elements of `xs` to the back, one at a
> time. So `rotate(2n, [1n, 2n, 3n])` is `[3n, 1n, 2n]`. It rotates to the left

`references/t1-rotate/solution.bend`:

```
def rotate(n: Nat, +xs: List<&2, Nat>) -> List<&2, Nat>:
  match n:
    case 0n:
      xs
    case 1n+p:
      match xs:
        case Nil{}:
          Nil{}
        case h <> t:
          rotate(p, P.append(t, h <> Nil{}))
```

Same signature (up to the argument names), same result. `t1-rotate` is
registered in `manifest.json` (task_id `t1-rotate`, tier 1, path
`tasks/1/t1-rotate`, laws `rotate_zero`, `rotate_succ`, `rotate_nil`), so this
is the same function at another tier, which the authoring brief rules out: a new
task must be a new *function*.

Nothing was written for `t2-rotate-by` -- no task directory, no reference, no
manifest entry. It is parked here as a note rather than deleted so the next
worker does not re-attempt it. A rotation task would have to differ in kind (a
rotation by a *computed* amount, or over a different structure), not in tier.
