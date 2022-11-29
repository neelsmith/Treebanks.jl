module Treebanks

using EzXML
using CitableText
using Graphs
using SimpleValueGraphs
import Base: ispunct
using Test

include("words.jl")
include("sentences.jl")
include("treebank.jl")
include("graphs.jl")


export Sentence
export ParsedWord
export readtreebank

end # module Treebanks
