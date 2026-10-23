Implement `scan_add`, then prove the three laws in `LAWS.bend`.

`scan_add(xs, acc)` is the list of running totals of `xs` starting from `acc`: it
has one entry per element of `xs`, and the entry for each element is `acc` plus
every element up to and including that one. The empty list gives `Nil{}`.

    scan_add([3n, 1n, 4n], 10n) == [13n, 14n, 18n]
    scan_add([5n], 2n) == [7n]
    scan_add(Nil{}, 2n) == Nil{}

The laws use `P.append(xs, ys)`, the concatenation of two lists, and
`P.acc_after(xs, acc)`, which is `acc` plus the sum of the elements of `xs`.

- `scan_add_nil`: `scan_add(Nil{}, acc)` is `Nil{}`, whatever `acc` is.
- `scan_add_single`: `scan_add(h <> Nil{}, acc)` is `(acc + h) <> Nil{}`.
- `scan_add_append`: `scan_add(P.append(xs, ys), acc)` is `scan_add(xs, acc)`
  followed by `scan_add(ys, P.acc_after(xs, acc))`: the second half continues
  from the total the first half ended at.
