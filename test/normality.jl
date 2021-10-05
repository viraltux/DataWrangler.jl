using Test
using DataWrangler: normality

@testset "normality" begin

    x = 1:100
    @test normality(x) ≈ 6.002400480071892

    x = randn(100)
    @test normality(x) < 6
    
end
