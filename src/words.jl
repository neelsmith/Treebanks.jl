
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
    
"""True if all characters is the `form` string of a word are punctuation characters.
"""
function ispunct(w::ParsedWord) :: Bool
    allpunct = true
    for c in w.form
        if ! ispunct(c)
            allpunct = false
        end
    end
    allpunct
end