"""Return `GMPPerson` for treebanks morphology code string,
or nothing if no value for person defined.
$SIGNATURES    
"""
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


"""Return `GMPNumber` for treebanks morphology code string,
or nothing if no value for number defined.
$SIGNATURES    
"""
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

"""Return `GMPTense` for treebanks morphology code string,
or nothing if no value for tense defined.
$SIGNATURES    
"""
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


"""Return `GMPMood` for treebanks morphology code string,
or nothing if no value for mood defined.
$SIGNATURES    
"""
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


"""Return `GMPVoice` for treebanks morphology code string,
or nothing if no value for voice is defined.
$SIGNATURES    
"""
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



"""Return `GMPGender` for treebanks morphology code string,
or nothing if no value for gender is defined.
$SIGNATURES    
"""
function decodegender(s::T)::Union{Nothing,GMPGender}  where T <: AbstractString
    gender = nothing
    if s == "m"
        gender = GMPGender(1)
    elseif s == "f"
        gender = GMPGender(2)
    elseif s == "n"
        gender = GMPGender(3)
    end
    gender
end



"""Return `GMPCase` for treebanks morphology code string,
or nothing if no value for case is defined.
$SIGNATURES    
"""
function decodecase(s::T)::Union{Nothing,GMPCase}  where T <: AbstractString
    gramcase = nothing
    if s == "n"
        gramcase = GMPCase(1)
    elseif s == "g"
        gramcase = GMPCase(2)
    elseif s == "d"
        gramcase = GMPCase(3)
    elseif s == "a"
        gramcase = GMPCase(4)
    elseif s == "v"
        gramcase = GMPCase(5)
    end
    gramcase

end

"""Return `GMPDegree` for treebanks morphology code string,
or nothing if no value for degree is defined.
$SIGNATURES    
"""
function decodedegree(s::T)::Union{Nothing,GMPDegree}  where T <: AbstractString
    degree = nothing
    if s == "c"
        degree = GMPDegree(2)
    elseif s == "s"
        degree = GMPDegree(3)
    end
    degree
end