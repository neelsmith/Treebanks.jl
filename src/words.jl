
"""String values encode in XML for a word
in Perseus treebanks.
"""
struct ParsedWord
    id
    form
    lemma
    morphcode
    head
    relation
end


"""Parse an XML node for a word into 
a `ParsedWord` object.
"""
function word(n::EzXML.Node)
    ParsedWord(
        n["id"],
        n["form"], 
        n["lemma"], 
        n["postag"], 
        n["head"],
        n["relation"]
    )
end
    
    