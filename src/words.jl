
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
        word["id"],
        word["form"], 
        word["lemma"], 
        word["postag"], 
        word["head"],
        word["relation"]
    )
end
    
    