"""A sentence is a vector of words identified by
a `CtsUrn`.
"""
struct Sentence
    urn::CtsUrn
    words::Vector{ParsedWord}
end

function text(s::Sentence)
    pieces = []
    for w in s.words
        if ispunct(w)
            push!(pieces, w.form)
        else
            push!(pieces, " " * w.form)
        end
    end
    join(pieces) |> strip
end