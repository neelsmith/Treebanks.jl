
"""Index in `wordvect` of entry with id value `id`.
"""
function idxforid(id, wordvect)
    findfirst(w -> w.id == id, wordvect)
end


"""Construct a directed graph of words in sentence `s`.
"""
function graph(s::Sentence)
    nodevals = map(s.words) do w
        (id = w.id, parent = w.head, form = w.form, morphcode = w.morphcode, relation = w.relation)
    end
    g = ValDiGraph(
        length(s.words);
        vertexval_types=(id = Int, parent = Int, form = String, morphcode = String, relation = String),
        vertexval_init= v -> nodevals[v],
        edgeval_types=(relation=String,)
    )

    for w in nodevals
        if w.parent == 0
            # root
        else
            @debug("Link $(w.id)->$(w.parent)")
            add_edge!(g, idxforid(w.id, s.words), idxforid(w.parent, s.words), (relation = w.morphcode,))     
        end
    end
    g
end
   
function dependentwords(wordidx, gr::T, s::Sentence)  where  T <: SimpleValueGraphs.ValDiGraph
    indexes = inneighbors(gr, wordidx)
    map(i -> s.words[i], indexes)
end


   
function dependentwords(w::ParsedWord, gr::T, s::Sentence)  where  T <: SimpleValueGraphs.ValDiGraph
    keyval = idxforid(w.id, s.words)
    dependentwords(keyval, gr, s)
end

function rootidx(gr::T) where T <: SimpleValueGraphs.ValDiGraph
    rootidx = -1
    for v in vertices(gr)
        if get_vertexval(gr, v, :parent) == 0
            @debug("Found root index $(v).")
            rootidx = v
        end
    end
    rootidx
end

function root(gr::T, wordlist::Vector{ParsedWord}) where T <: SimpleValueGraphs.ValDiGraph
    wordlist[rootidx(gr)]
end

function root(gr::T, s::Sentence) where T <: SimpleValueGraphs.ValDiGraph
    root(gr, s.words)
end


function unitwords()
end


function transitionword(w::ParsedWord)
    if w.relation in ["AuxC"]
        @info("-> Change in conjunction $(w.form)")
        true
    elseif w.morphcode[5] == 'p' # participle
        @info("-> Change on participle $(w.form)")
        true
    # elseif  LOOK FOR INDIRECT STATEMENT
    else
        false
    end

end

"""Determine depth in Verbal Units of sentence `s`.
"""
function depth_in_vus(id, gr, s, currlevel = 1)
    bump = false
    for wd in dependentwords(id, gr, s)
        if transitionword(wd) 
            bump = true
        end
    end
    newlevel = bump ? currlevel + 1 : currlevel
    for wd in dependentwords(id, gr, s)
        newid = idxforid(wd.id, s.words)
        tiers(newid, gr, s, newlevel )
    end
    newlevel
end

"""Recursively walk the graph starting at node `id`.
"""
function tiers(id, gr, s::Sentence, currlevel = 1, verbalunit = 1)  
    currword = s.words[id]
    @info("Examine $(id)/$(currword.form) at $(currlevel) in VU $(verbalunit)")
    
    for wd in dependentwords(id, gr, s)
        newlevel = currlevel
        if transitionword(wd) 
            newlevel = newlevel + 1
            verbalunit = verbalunit + 1
        end
        newid = idxforid(wd.id, s.words)
        tiers(newid, gr, s, newlevel, verbalunit )
    end
end
#=
"""Recursively add verbal units.
"""
function verbalunits(s::Sentence, from = nothing, clusters = [], level = 1)
    if isnothing(from)
        verbalunits(s, clusters, level)
    end
end
=#
function verbalunits(s::Sentence, clusters = [], level = 1)
    gr = graph(s)
    sroot = root(s)
    currentlevel = [sroot]
    nexttier = dependentwords(sroot, gr, s)
    for w in nexttier
        if transitionword(w)
        else
            push!(currentlevel, w)
            println(w.form, " + ", w.relation)
        end
    end
    currentlevel
end