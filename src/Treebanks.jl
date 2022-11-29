module Treebanks

using EzXML
using CitableText
import Base: ispunct
using Test

include("words.jl")
include("sentences.jl")
include("treebank.jl")


export Sentence
export ParsedWord
export readtreebank

end # module Treebanks
