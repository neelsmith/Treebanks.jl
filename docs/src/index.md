# The `Treebanks.jl` package

```@setup treebanks
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "0540-001.xml")
```

The file `f` is a tree bank of Lysias 1, available in this repository from `test/data/0540-001.xml`.

A tree bank is a sequence of `Sentence` objects.

```@example datawork
using Treebanks
tb = readtreebank(f)
typeof(tb)
```

```@example datawork
f
```