using DataWrangler
using Test
using Random
using Logging

const tests = [
    "boxcox",
    "impute",
    "normality",
    "normalize",
    "d",
    "p",
]

printstyled("\nTest Summary List:\n", color=:underline)

Random.seed!(36)
Base.disable_logging(Base.CoreLogging.Error) # disable warnings

for t in tests
    @testset "Test $t" begin
        Random.seed!(36)
        include("$t.jl")
        println()
    end
end

println()
