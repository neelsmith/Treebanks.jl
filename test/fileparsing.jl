
@testset "Test parsing sentences from a file source" begin
    f = joinpath(pwd(), "data", "0540-001.xml")
    tb = readtreebank(f)
    expectedsentences = 130
    @test length(tb) == expectedsentences
    for sentence in tb
        @test sentence isa Sentence
    end
end