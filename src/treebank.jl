
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
    u = urnify(n, ns = ns, idprefix = idprefix)
    words = findall("word", n)
    parsedwords = map(w -> word(w), words)
    Sentence(u, parsedwords)
end


"""Build a treebank, that is, a vector of `Sentence`s, from  a parsed XML document for a Perseus treebank.  
"""
function treebank(doc::EzXML.Document; ns = "greekLit", idprefix = "tlg")
    elems = findall("sentence", root(doc))
    map(elem -> sentence(elem), elems)
end


"""Read a file with XML source for a Perseus tree bank,
and parse it into a `Treebank` object.
"""
function readtreebank(f; ns = "greekLit", idprefix = "tlg")
    doc = readxml(f)
    treebank(doc, ns = ns, idprefix = idprefix)
end
