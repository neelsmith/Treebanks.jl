#=
https://github.com/PerseusDL/treebank_data/blob/master/AGDT2/guidelines/Greek_guidelines.md
=#
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
        parse(Int, n["id"]),
        n["form"], 
        n["lemma"], 
        n["postag"], 
        parse(Int, n["head"]),
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


"""Serialize a parsed word. 
"""
function serialize(w::ParsedWord, u::CtsUrn; delimiter = "|")
    join([string(u), w.id, w.form, w.lemma, w.morphcode, w.head, w.relation], delimiter)
end


#=
Some of the values to watch for:
    PRED = verb of main clause
    COORD = coordinating conjunction
    AuxC = subordinating conjunction
    OCOMP = "predicative accusative"
    SBJ = subjet of verb
    PNOM = predicative nominative
    OBJ= apparently almost anything

=#