# Build docs from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.resolve()
Pkg.instantiate()

using Documenter, DocStringExtensions, Treebanks

makedocs(
    sitename = "Treebanks.jl Documentation",
    pages = [
        "Home" => "index.md",
        "Modelling Greek syntax" => "model.md"
    ]
)

deploydocs(
    repo = "github.com/neelsmith/Treebanks.jl.git",
) 
