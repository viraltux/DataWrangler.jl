using Test
using DataWrangler

@testset "impute" begin
    
    x = 1:100;
    y = rand(100);
    
    @test isnothing(impute!(x,y))

    y = Array{Union{Missing,Float64}}(undef,100);
    y[:] = rand(100);

    yInt = Array{Union{Missing,Int64}}(undef,100);
    yInt[:] = rand(-1000:1000,100);

    # impute!
    ## loess
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y)
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y)
    @test !any(ismissing,y) 

    yInt[rand(1:100,10)] .= missing;
    impute!(yInt)
    @test !any(ismissing,yInt) 
    
    ## normal
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y; method = "normal")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; method = "normal")
    @test !any(ismissing,y) 

    yInt[rand(1:100,10)] .= missing;
    impute!(yInt; method = "normal")
    @test !any(ismissing,yInt) 

    
    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y; method = "uniform")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; method = "uniform")
    @test !any(ismissing,y) 

    yInt[rand(1:100,10)] .= missing;
    impute!(yInt; method = "uniform")
    @test !any(ismissing,yInt) 

    
    # impute
    ## loess
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y)) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y)) 

    yInt[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(yInt)) 
    
    ## normal
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y; method = "normal")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; method = "normal")) 

    yInt[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(yInt; method = "normal")) 

    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y; method = "uniform")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; method = "uniform")) 

    yInt[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(yInt; method = "uniform")) 

end
