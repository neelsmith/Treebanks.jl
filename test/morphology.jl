
@testset "Test parsing AGLDT morphology codes" begin
   @test morphology("Nonsense") |> isempty
   @test morphology("d--------") |> isempty
   @test morphology("u--------") |> isempty
   
   prepos = morphology("r--------" )[1]
   @test prepos isa GMFUninflected
   @test label(prepos.pos) == "preposition"

   exclam = morphology("i--------" )[1]
   @test exclam isa GMFUninflected
   @test label(exclam.pos) == "interjection"
end