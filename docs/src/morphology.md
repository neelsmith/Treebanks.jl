

# Morphology

The AGLDT treebanks include with each token a ten-character string encoding a morphological analysis. The `morphology` function instantiates a `GreekMorphologicalForm` (from the `Kanones` package) from one of these strings.

```@example morph
using Treebanks
verbcode = "v2ppoa---"
form = morphology(verbcode)
typeof(form)
```

You can then use the full range of functions in the [`Kanones` package](https://neelsmith.github.io/Kanones.jl/stable/) to work with these forms.

```@example morph
using Kanones
label(form)
```