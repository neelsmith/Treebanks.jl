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

function serialize(s::Sentence; delimiter = "|", header = false)
    rows = join(map(w -> serialize(w, delimiter = delimiter), s.words), "\n")

    if header
        join(["id", "form", "lemma", "morphcode", "head", "relation"], delimiter) * "\n" * rows
    else
        rows
    end
end

function root(s::Sentence)
    graphroots = filter(w -> w.head == 0, s.words)
    if isempty(graphroots)
        @warn("No root element found")
        nothing
    elseif length(graphroots) > 1
        @warn("More than one root element found.")
        graphroots
    else
        graphroots[1]
    end
end