# The `Treebanks.jl` package

```@setup treebanks
root = pwd() |> dirname |> dirname
f = joinpath(root, "test", "data", "0540-001.xml")
```

The file `f` is a tree bank of Lysias 1, available in this repository from `test/data/0540-001.xml`.


## Structures

A tree bank is a vector of `Sentence` objects.

```@example treebanks
using Treebanks
tb = readtreebank(f)
typeof(tb)
```

Sentences have a CTS URN and a Vector of `ParsedWord`s.


```@example treebanks
sent = tb[15]
sent.urn
```

```@example treebanks
sent.words |> typeof
```


Parsed words look like this:

```@example treebanks
sent.words[3]
```

## Graphs

Use the `graph` function to create a directed graph of words in a sentence.

```@example treebanks
gr = Treebanks.graph(sent)
```

Find the root of a graph:

```@example treebanks
headword = Treebanks.root(sent)
```
Find words dependent on another word.  (In terms of the directed graph, find the `ParsedWord`s that are source nodes, or in-links, to the target node.)


```@example treebanks
nexttier = Treebanks.dependentwords(headword, gr, sent)
```