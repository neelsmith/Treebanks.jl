function graph(s::Sentence)
    g = DiGraph(length(s.words))
    for w in s.words
        if w.head == 0
            # root: no links out
        else
            @info("Add edge $(w.id) -> $(w.head)")
            parent = headword(w.head, s.words)
            add_edge!(g, w, parent)
        end
        # findfirst
        #node1 = personindex(e.p1, gr.nodes)
        #node2 = personindex(e.p2, gr.nodes)
        #add_edge!(g, node1, node2)
    end
    g
end


function headword(id, words)
    findfirst(w -> w.id == id, words)
end

#=
function genealogyGraph(gen::Genealogy)
    folks = map(gen.individuals) do i
        (id = i.id, name = label(i))
    end
    g = ValDiGraph(length(folks);
    vertexval_types=(id = String, name = String),
    vertexval_init=v -> folks[v],
    edgeval_types=(relation=String,)
    )

    #=
    Find indices in vector of 2 individuals.
    compute relation type for edge value.
    =#

    for f in gen.families
        h = husbandid(f)
        w = wifeid(f)
        h_index = 0
        w_index = 0
     
        if isempty(h) || isempty(w)
        else
            h_index = idindex(h, folks)
            w_index = idindex(w, folks)
            add_edge!(g, h_index, w_index, (relation="Husband",))   
            add_edge!(g, w_index, h_index, (relation="Wife",))     
        end
        
        for c in childrenids(f)
            c_index = idindex(c, folks)
           if isempty(h)     
           else
            add_edge!(g, c_index, h_index, (relation="Child",)) 
           end
           if isempty(w)
           else
            add_edge!(g, c_index, w_index, (relation="Child",))
           end
        end
        
    end
    g
end

=#