using Test
using DataWrangler

@testset "outlie" begin

    x = 1:100
    y = Array{Union{Missing,Float64}}(undef,100);
    y[:] = collect(x);
    mid = vcat(10,30,60,90);
    y[mid] .= y[mid] .+ [5,10,-5,-10];

    @test outlie(x,y) == [10, 30, 60, 81, 82, 85, 86, 87, 89, 90, 93]

    ϵ = Array{Union{Missing,Float64}}(undef,100);
    ϵ[:] = rand(length(y))/100;

    yϵ = Array{Union{Missing,Float64}}(undef,100);
    yϵ[:] = y.+ϵ
    
    @test outlie(x,yϵ) == [10, 30, 60, 90]
    
end
