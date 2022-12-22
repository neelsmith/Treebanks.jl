

# Morphology

The AGLDT treebanks include with each token a ten-character string encoding a morphological analysis. The `morphology` function instantiates `GreekMorphologicalForm`s (from the `Kanones` package) from one of these strings.  Because the strings can encode multiple forms, the return value of the `morphology` function is a Vector of `GreekMorphologicalForm`s.

```@example morph
using Treebanks
verbcode = "v2ppoa---"
forms = morphology(verbcode)
typeof(forms)
```

You can then use the full range of functions in the [`Kanones` package](https://neelsmith.github.io/Kanones.jl/stable/) to work with these forms.

```@example morph
using Kanones
label(forms[1])
```