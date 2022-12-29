"""Return a vector of `GMFFiniteVerb` objects for a treebanks morphology code string.
If no valid value for a finite verb form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodefiniteverb(s::T)::Vector{GMFFiniteVerb} where T <: AbstractString
    reslts = GMFFiniteVerb[]

    pieces = split(s, "")
    person = decodeperson(pieces[2])
    num = decodenumber(pieces[3])
    tense = decodetense(pieces[4])
    mood = decodemood(pieces[5])
    voice = decodevoice(pieces[6])
    for v in voice
        push!(reslts, GMFFiniteVerb(person, num, tense, mood, v))
    end
    reslts
end


"""Return a vector of `GMFInfinitive` objects for a treebanks morphology code string.
If no valid value for an infinitive form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodeinfinitive(s::T)::Vector{GMFInfinitive} where T <: AbstractString
    reslts = GMFInfinitive[]

    pieces = split(s, "")
    tense = decodetense(pieces[4])
    voice = decodevoice(pieces[6])
    for v in voice
        push!(reslts, GMFInfinitive(tense, v))
    end
    reslts
end


"""Return a vector of `GMFParticiple` objects for a treebanks morphology code string.
If no valid value for an infinitive form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodeparticiple(s::T)::Vector{GMFParticiple} where T <: AbstractString
    reslts = GMFParticiple[]

    pieces = split(s, "")
    tense = decodetense(pieces[4])
    voice = decodevoice(pieces[6])
    gender = decodegender(pieces[7])
    gramcase = decodecase(pieces[8])
    num = decodenumber(pieces[3])
    for v in voice
        push!(reslts, GMFParticiple(tense, v, gender, gramcase, num))
    end
    reslts
end

"""Return a vector of `GMFNoun` objects for a treebanks morphology code string.
If no valid value for a noun form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodenoun(s::T)::Vector{GMFNoun} where T <: AbstractString
    reslts = GMFNoun[]

    pieces = split(s, "")
    gender = decodegender(pieces[7])
    gramcase = decodecase(pieces[8])
    num = decodenumber(pieces[3])
    push!(reslts, GMFNoun(gender, gramcase, num))
end

"""Return a vector of `GMFPronoun` objects for a treebanks morphology code string.
If no valid value for a noun form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodepronoun(s::T)::Vector{GMFPronoun} where T <: AbstractString
    reslts = GMFPronoun[]

    pieces = split(s, "")
    gender = decodegender(pieces[7])
    gramcase = decodecase(pieces[8])
    num = decodenumber(pieces[3])
    push!(reslts, GMFPronoun(gender, gramcase, num))
end

"""Return a vector of `GMFAdjective` objects for a treebanks morphology code string.
Note that in AGLDT morphology, only the positive degree of adjectives is encoded!
If no valid value for an adjective form is encoded, the vector is empty.
$SIGNATURES    
"""
function decodeadjective(s::T)::Vector{GMFAdjective} where T <: AbstractString
    reslts = GMFAdjective[]

    pieces = split(s, "")
    gender = decodegender(pieces[7])
    gramcase = decodecase(pieces[8])
    num = decodenumber(pieces[3])


    degree = pieces[9] == "-" ? GMPDegree(1) : decodedegree(pieces[9])
    push!(reslts, GMFAdjective(gender, gramcase, num, degree))
end


"""Parse treebank code string for "morphological" analysis into
zero or more `GreekMorphologicalForm`s.
"""
function morphology(s::T)::Vector{GreekMorphologicalForm} where T <: AbstractString
    pieces = split(s, "")
    reslt  = GreekMorphologicalForm[] 
    
   
    if  s == "d--------" || s == "u--------" 
        # Ignore these:
        # 1. 'd' == any damn uninflected thing in Greek, including (in their view) all adverbs!
        # 2. 'u' == punctuation
    
    elseif s == "r--------" 
        push!(reslt, GMFUninflected(gmpUninflectedType("preposition")))

    elseif s == "i--------"
        push!(reslt, GMFUninflected(gmpUninflectedType("interjection")))

    elseif s == "b--------"  || s == "c--------" 
        # AGLDT distinguishses subordinating and coordinating conjunctions.
        # That is a syntactic and semantic distinction, not a morphological
        # distinction for Kanones.
        GMFUninflected(gmpUninflectedType("conjunction"))

    # pieces[1]      == PoS code        
    elseif pieces[1] == "a"
        reslt = decodeadjective(s)

    elseif pieces[1] == "n"  
        reslt =  decodenoun(s) 

    elseif pieces[1] == "l" ||  pieces[1] == "p"  
        # 1. article
        # 2. pronoun
        # In Kanones, these belong to the same analytical category
        reslt = decodepronoun(s)
                                        
 
    elseif pieces[1] == "v"
        # AGLDT thinks that participles and infinitives are moods of a verb.
        if pieces[5] == "p"
            reslt = decodeparticiple(s)
        elseif pieces[5] == "n"
            reslt = decodeinfinitive(s)
        elseif pieces[2] != "-"
            reslt = decodefiniteverb(s)
        else
            @error("Unrecognized verb form: $(s)")
        end     
    end
    reslt
end

#=
urn:cts:greekLit:tlg0540tlg001.tb:5.2|5141254|μέγιστα|μέγας|a-p---nas|5141255|OBJ
urn:cts:greekLit:tlg0540tlg001.tb:5.2|5141255|δυναμένους|δύναμαι|v-pppema-|5141251|ADV
urn:cts:greekLit:tlg0540tlg001.tb:5.2|5141256|ἀποδέδοται|ἀποδίδωμι|v3srie---|0|PRED
=#
#=
Kanones uninflected parts of speech: ✅ == encoded, ❌ == not encoded in AGLDT
    "✅ conjunction" => 1,
    "✅ preposition" => 2,
    "❌particle" => 3,
    "❌adverb" => 4,
    "❌numeral" => 5,
    "✅ interjection"  => 6
=#

#= 11 AGLDT  PoS codes ✅ == handled by `morphology` function
 ✅ 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 ✅ 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
 ✅ 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 ✅ 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)
 ✅ 'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)
 ✅ 'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)
 ✅ 'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)
✅ 'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)
 ✅ 'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)
 ✅ 'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)
 ✅ 'v': ASCII/Unicode U+0076 (category Ll: Letter, lowercase)
 =#