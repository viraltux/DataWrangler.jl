using Test
using DataWrangler

@testset "impute" begin
    #TODO implement test & funcionality for Integer values
    
    x = 1:100;
    y = rand(100);
    
    @test isnothing(impute!(x,y))

    y = Array{Union{Missing,Float64}}(undef,100);

    # impute!
    ## loess
    y[:] = rand(100);

    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y)
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y)
    @test !any(ismissing,y) 

    ## normal
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y; type = "normal")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; type = "normal")
    @test !any(ismissing,y) 

    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y; type = "uniform")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; type = "uniform")
    @test !any(ismissing,y) 

    # impute
    ## loess
    y[:] = rand(100);
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y)) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y)) 

    ## normal
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y; type = "normal")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; type = "normal")) 

    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y; type = "uniform")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; type = "uniform")) 

end
