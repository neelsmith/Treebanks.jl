
"""A sentence is a vector of words identified by
a `CtsUrn`.
"""
struct Sentence
    urn::CtsUrn
    words::Vector{ParsedWord}
end


"""A kludge to construct a CTS URN
value for an XML `sentence` element.
"""
function urnify(sentence::EzXML.Node; ns = "greekLit", idprefix = "tlg")
    urnbase = "urn:cts:$(ns):"
    dotprefix = "." * idprefix
    idval = idprefix * replace(sentence["document_id"], "-" => idprefix) * ".tb:"
    string(urnbase, idval, sentence["id"],".", sentence["subdoc"]) |> CtsUrn 
end


"""Construct a `Sentence` object from a parsed XML element named `sentence`.
"""
function sentence(n::EzXML.Node; ns = "greekLit", idprefix = "tlg")
    u = urnify(n, ns = ns, idpreifx = idprefix)

end

"""Build a treebank, that is, a vector of `Sentence`s, from  a parsed XML document for a Perseus treebank.  
"""
function treebank(doc::EzXML.Document; ns = "greekLit", idprefix = "tlg")
    elems = findall("sentence", root(doc))
    sentences = Sentence[]
    for elem in elems
        u = urnify(elem, ns = ns, idprefix = idprefix)
        words = findall("word", elem)
        parsedwords = map(w -> word(w), words)

        push!(sentences, Sentence(u, parsedwords))
    end
    sentences
end


"""Read a file with XML source for a Perseus tree bank,
and parse it into a `Treebank` object.
"""
function readtreebank(f; ns = "greekLit", idprefix = "tlg")
    doc = readxml(f)
    treebank(doc, ns = ns, idprefix = idprefix)
end