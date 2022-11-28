using CitableText
using EzXML
f = joinpath(pwd(), "test", "data", "0540-001.xml")

doc = readxml(f)
sentences = findall("sentence", root(doc))


#= Assumptions:
1. in greekLit namespace
2. 2-tier citation scheme
=#
function urnify(sentence::EzXML.Node)
    urnbase = "urn:cts:greekLit:"
    idval = "tlg" * replace(sentence["document_id"], "-" => ".tlg") * ".tb:"
    string(urnbase, idval, sentence["id"],".", sentence["subdoc"]) |> CtsUrn
 
end

function wordstruct(word::EzXML.Node, u::CtsUrn)


(id = word["id"], urn = CtsUrn(string(u, ".", word["id"])), form = word["form"], lemma = word["lemma"], morph = word["postag"], head = word["head"], relation = word["relation"])
end

s1 = sentences[1]
u = urnify(s1)
words = findall("word", s1)
w1 = wordstruct(words[1], u)

