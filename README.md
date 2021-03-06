# DataWrangler

Data wrangling refers to a number of processes designed to clean and transform data into into analytics ready datasets.

This package provides the following functionality to wrangle data:

- Box-Cox and inverse Box-Cox transformation and estimation: `boxcox`, `iboxcox`
- Data imputation (loess inter/extra-polation, random local density): `impute`, `impute!`
- Data normalization (z-score, min-max, softmax, sigmoid): `normalize`, `normalize!`
- Finite lagged difference and partial difference and its inverse: `d`, `p`
- Outlier detection and removal: `outlie`, `outlie!`

## Examples

### Data Imputation
```julia
using Plots
n = 1000
x = sort(rand(n))*2*pi;
y = Array{Union{Missing,Float64}}(undef,n);
y[:] = sin.(x).+randn(n)/10;
mid = vcat(100:150,300:350,600:650,950:1000);

y[mid] .= missing;
scatter(x,y; label="data")

ipy = impute(x,y; method = "normal")
scatter!(x[mid],ipy[mid]; label = "imputed 'normal'", color=:white)

ipy = impute(x,y)
scatter!(x[mid],ipy[mid]; label = "imputed 'loess'", color=:black, markersize = 2)
```
<img src="./docs/src/images/impute.png">

### Time Series Outlier Detection
```julia
using Plots
n = 1000
x = sort(rand(n))*2*pi;
y = Array{Union{Missing,Float64}}(undef,n);
y[:] = sin.(x).+randn(n)/10
mid = vcat(100:150,300:350,600:650,950:1000);
y[mid] .= y[mid] .+ 2*(randn(length(mid)).+1)

outlist = outlie(x,y)
scatter(outlist, y[outlist]; color="blue", label="outliers",ms=6)
scatter!(y,color="lightblue", label="data")
```
<img src="./docs/src/images/outlie.png">


[![Build Status](https://github.com/viraltux/DataWrangler.jl/workflows/CI/badge.svg)](https://github.com/viraltux/DataWrangler.jl/actions)
[![Coverage](https://codecov.io/gh/viraltux/DataWrangler.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/viraltux/DataWrangler.jl)
