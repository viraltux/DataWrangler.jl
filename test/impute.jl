using Test
using DataWrangler

@testset "impute" begin
    #TODO implement test & funcionality for Integer values
    
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
    impute!(x,y; type = "normal")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; type = "normal")
    @test !any(ismissing,y) 

    yInt[rand(1:100,10)] .= missing;
    impute!(yInt; type = "normal")
    @test !any(ismissing,yInt) 

    
    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    impute!(x,y; type = "uniform")
    @test !any(ismissing,y) 

    y[rand(1:100,10)] .= missing;
    impute!(y; type = "uniform")
    @test !any(ismissing,y) 

    yInt[rand(1:100,10)] .= missing;
    impute!(yInt; type = "uniform")
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
    @test !any(ismissing,impute(x,y; type = "normal")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; type = "normal")) 

    yInt[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(yInt; type = "normal")) 

    ## uniform
    x = sort(rand(100));
    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(x,y; type = "uniform")) 

    y[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(y; type = "uniform")) 

    yInt[rand(1:100,10)] .= missing;
    @test !any(ismissing,impute(yInt; type = "uniform")) 

end
