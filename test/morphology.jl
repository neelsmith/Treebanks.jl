
@testset "Test parsing AGLDT morphology codes" begin
    @test morphology("Nonsense") |> isempty
    @test morphology("d--------") |> isempty
    @test morphology("u--------") |> isempty

    prepos = morphology("r--------" )[1]
    @test prepos isa GMFUninflected
    @test label(prepos) == "uninflected form: preposition"

    exclam = morphology("i--------" )[1]
    @test exclam isa GMFUninflected
    @test label(exclam) == "uninflected form: interjection"
    # Test conjunctions

    # Test a finite verb
    # Test an infinitive
    ptcps = morphology("v-pppema-")
    @test length(ptcps) == 2

    
    # Test a noun

    art = morphology("l-p---mg-")[1]
    @test art isa GMFPronoun
    @test label(art) == "pronoun: masculine genitive plural"

    # Test a pronoun

    adj = morphology("a-p---nas")[1]
    @test adj isa GMFAdjective
    @test label(adj) == "adjective:  neuter accusative plural superlative"
end