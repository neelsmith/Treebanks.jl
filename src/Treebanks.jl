module Treebanks

using EzXML
using CitableText

using Test

include("words.jl")
include("treebank.jl")

export Sentence
export ParsedWord
export readtreebank

end # module Treebanks
