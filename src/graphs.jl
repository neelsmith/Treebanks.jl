
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