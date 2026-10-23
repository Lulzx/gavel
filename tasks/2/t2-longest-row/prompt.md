Implement `map_len` and `longest_row`, then prove the five laws in `LAWS.bend`.

`map_len(xss)` is the list of the lengths of the rows of `xss`, in the order the
rows appear. No rows gives the empty list.

    map_len([[1n, 2n], Nil{}, [3n]]) == [2n, 0n, 1n]
    map_len(Nil{})                   == Nil{}

`longest_row(xss)` is the length of the longest row of `xss`, or `0n` when there
are no rows.

    longest_row([[1n, 2n], Nil{}, [3n, 4n, 5n]]) == 3n
    longest_row(Nil{})                           == 0n

The laws use these prelude names. `P.len(xs)` is the number of elements of
`xs`. `P.max(a, b)` is the larger of two numbers. `P.max_list(xs)` is the
largest element of a list of numbers, or `0n` for the empty list.

- `map_len_nil`: `map_len(Nil{})` is `Nil{}`.
- `map_len_cons`: `map_len(l <> t)` is `P.len(l)` in front of `map_len(t)`.
- `longest_row_nil`: `longest_row(Nil{})` is `0n`.
- `longest_row_cons`: `longest_row(l <> t)` is the larger, by `P.max`, of
  `P.len(l)` and `longest_row(t)`.
- `longest_row_map_len`: `longest_row(xss)` is `P.max_list(map_len(xss))`.
