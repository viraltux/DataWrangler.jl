using Test
using DataWrangler

@testset "d" begin

    x = [1,2,3,4,5]
    dx = d(x,center=true)
    mdx = ismissing.(dx)
    @test mdx == [0,0,0,0,1]
    @test dx[.!Bool.(mdx)] == [1,1,1,1]

    dx = d(x,2,center=true)
    mdx = ismissing.(dx)
    @test mdx == [1,0,0,0,1]
    @test dx[.!Bool.(mdx)] == [0,0,0]

    dx = d(x,1,2)
    mdx = ismissing.(dx)
    @test mdx == [0,0,0]
    @test dx[.!Bool.(mdx)] == [2,2,2]

    x = reshape(collect(1:20),10,2)
    dx = d(x,2,2)
    @test dx == repeat([0],6,2)

    # Fractional Difference
    x = rand(100)
    x ≈ d(d(x,.5),-.5)
    x ≈ d(d(x,2.5),-2.5)
    d(x,1.) ≈ [x[1]; d(x)]

    n = 1000
    wx = 2*pi
    w = Array(LinRange(0,wx,n))
    x = sin.(w)
    x10 = sin.(w.+pi/2)
    x20 = sin.(w.+pi)
    scale = wx
    dx = 1.0; isapprox(x10[10:end], d(x,dx;scale)[10:end]; rtol= .01)
    dx = 2.0; isapprox(x20[10:end], d(x,dx;scale)[10:end]; rtol= .01)

end
