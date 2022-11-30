
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


function dependentwordindices(wordidx, gr::T, s::Sentence)  where  T <: SimpleValueGraphs.ValDiGraph
    indexes = inneighbors(gr, wordidx)
    map(i -> s.words[i], indexes)
end


"""Compile a list of all parsed words in sentence `s` that depend directly
on `w`.
"""   
function dependentwords(w::ParsedWord, gr::T, s::Sentence)  where  T <: SimpleValueGraphs.ValDiGraph
    keyval = idxforid(w.id, s.words)
    dependentwordindices(keyval, gr, s)
end

"""Find the node index for the root (head) node of the
graph `gr`.
"""
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

"""Find the parsed word that is the root (head) of the graph for 
the vector of parsed words in `wordlist`.
"""
function root(gr::T, wordlist::Vector{ParsedWord}) where T <: SimpleValueGraphs.ValDiGraph
    wordlist[rootidx(gr)]
end

"""Find the parsed word that is the root (head) of the graph for 
sentence `s`.
"""
function root(gr::T, s::Sentence) where T <: SimpleValueGraphs.ValDiGraph
    root(gr, s.words)
end


"""True if `w` introduces a transition to a new
verbal unit.
"""
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


"""Parse tokens in sentence `s` into 
verbal units.
"""
function cluster(s::Sentence)
    g = graph(s)
    id = rootidx(g)
    maxdepth = depth_in_vus(id, g, s)
    datamatrix = []
    for i in 1:maxdepth
        push!(datamatrix, [])
    end
    # Now push to each tier the appropriate 
    # number of matrices for each VU
    
    datamatrix
    #=
    depth = num_vus(id, g, s)
    clusters = []
    for i in 1:depth
        push!(clusters, String[])
    end
    @info("\nPrepared to cluster s from root $(id)")
    tiers(id, g, s, clusters)
    =#
end

function depthperlevel(id, gr, s, m)
end

"""Compute number of verbal units in sentence `s`
"""
function num_vus(id, gr, s, verbalunit = 1)
    currword = s.words[id]
    @debug("num_vus: examine $(id)/$(currword.form) in VU $(verbalunit)")
    
    for wd in dependentwordindices(id, gr, s)
        if transitionword(wd) 
            verbalunit = verbalunit + 1
        end
        newid = idxforid(wd.id, s.words)
        num_vus(newid, gr, s, verbalunit )
    end
    verbalunit
end


"""Determine depth in Verbal Units of sentence `s`.
"""
function depth_in_vus(id, gr, s, currlevel = 1)
    bump = false
    for wd in dependentwordindices(id, gr, s)
        if transitionword(wd) 
            bump = true
        end
    end
    newlevel = bump ? currlevel + 1 : currlevel
    newlevel
end


#=
function level_vu_matrix(id, gr, s, level = 1, verbalunit = 1)
    currword = s.words[id]
    @info("level-vu matrix: examine $(id)/$(currword.form) at $(level) in VU $(verbalunit)")
    
   
    for wd in dependentwordindices(id, gr, s)
        newlevel = level
        if transitionword(wd) 
            newlevel = newlevel + 1
            verbalunit = verbalunit + 1
        end
        newid = idxforid(wd.id, s.words)
        level_vu_matrix(newid, gr, s, newlevel, verbalunit )
    end
    
end
=#
"""Recursively walk the graph starting at node `id`.
"""
function tiers(id, gr, s::Sentence, tieredtokens; currlevel = 1, verbalunit = 1)  
    currword = s.words[id]
    @info("tiers: examine $(id)/$(currword.form) at $(currlevel) in VU $(verbalunit)")
    
    push!(tieredtokens[verbalunit], currword.form)
    for wd in dependentwordindices(id, gr, s)
        newlevel = currlevel
        if transitionword(wd) 
            newlevel = newlevel + 1
            verbalunit = verbalunit + 1
        end
        newid = idxforid(wd.id, s.words)
        tiers(newid, gr, s, tieredtokens, currlevel = newlevel, verbalunit = verbalunit )
    end
    tieredtokens
end

