#=
function graph(gr::GenealogyGraph)
    g = DiGraph(length(gr.nodes))
    for e in gr.edges
        # findfirst
        node1 = personindex(e.p1, gr.nodes)
        node2 = personindex(e.p2, gr.nodes)
        add_edge!(g, node1, node2)
    end
    g
end
=#