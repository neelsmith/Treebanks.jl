

function decodeperson(s::T)::Union{Nothing,GMPPerson}  where T <: AbstractString
    pers = nothing
    if s == "1"
        pers = gmpPerson(1)
    elseif s == "2"
        pers = gmpPerson(2)
    elseif s == "3"
        
        pers = gmpPerson(3)
    end
    pers
end

function decodenumber(s::T)::Union{Nothing,GMPNumber}  where T <: AbstractString
    num = nothing
    if s == "s"
        num = gmpNumber(1)
    elseif s == "d"
        num = gmpNumber(2)
    elseif s == "p"
        num = gmpNumber(3)
    end
    num
end


function decodetense(s::T)::Union{Nothing,GMPTense}  where T <: AbstractString
    tense = nothing
    if s == "p"
        tense = gmpTense(1)
    elseif s == "i"    
        tense = gmpTense(2)
    elseif s == "a"
        tense = gmpTense(3)
    elseif s == "r" 
        tense = gmpTense(4)
    elseif s == "l" 
        tense = gmpTense(5)
    elseif s == "f"
        tense = gmpTense(6)
    end
    tense
end

function decodemood(s::T)::Union{Nothing,GMPMood}  where T <: AbstractString
    mood = nothing
    if s == "i"
        mood = gmpMood(1)
    elseif s == "s"
        mood = gmpMood(2)
    elseif s == "o"
        mood = gmpMood(3)
    elseif s == "m"
        mood = gmpMood(4)
    end
    mood
end


function decodevoice(s::T)::Vector{GMPVoice} where T <: AbstractString
    voice = []
    @info("Voice ", voice)
    if s == "a"
        push!(voice, gmpVoice(1))
    elseif s == "m"
        push!(voice, gmpVoice(2))
    elseif s == "p"
        push!(voice, gmpVoice(3))
    elseif s == "e"
        push!(voice, gmpVoice(2))
        push!(voice,  gmpVoice(3))
    end
    voice
end

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

#=
Nine elements:

1. part of speech
2. person
3. number
4. tense
5. mood
6. voice
7. gender
8. case
9. degree
=#
"""Parse treebank code string for "morphological" analysis into
zero or more `GreekMorphologicalForm`s.
"""
function morphology(s::T)::Vector{GreekMorphologicalForm} where T <: AbstractString
    pieces = split(s, "")
    reslt  = GreekMorphologicalForm[] 
    
    if s == "r--------" || s == "d--------" || s == "u--------"
    # 1. preposition and any damn uninflected thing in Greek,
    # 2. including all adverbs!
    # 3. punctuation
    #
    # pieces[1]      == PoS code
    #
    elseif pieces[1] == "a"
        # adjective
    elseif pieces[1] == "b"        
        # coord. conj.
    elseif pieces[1] == "c"        
        # subord. conj.
    elseif pieces[1] == "i" 
        # exclamatory W!
    elseif pieces[1] == "l"         
        # ARTICLE
    elseif pieces[1] == "n"                 
        # NOUN
    elseif pieces[1] == "p"                         
        # PRONOUN
    elseif pieces[1] == "v"
        if pieces[5] == "p"
            # participle
        elseif pieces[5] == "n"
            # infinitive
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

