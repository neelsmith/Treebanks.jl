module Treebanks

using EzXML
using CitableText
using Kanones
using Graphs
using SimpleValueGraphs
using Documenter
using DocStringExtensions

import Base: ispunct
using Test


include("morphproperties.jl")
include("morphcodes.jl")
include("words.jl")
include("sentences.jl")
include("treebank.jl")
include("graphs.jl")
include("markdownutils.jl")


export Sentence
export ParsedWord
export readtreebank
export morphology

end # module Treebanks
