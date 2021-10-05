"""
Package: Forecast

    function p(dx, x0)

Return reverse lagged differences of a given order for Vector, Array.

# Arguments
- `dx`: Array or DataFrame of data.
- `x0`: Initial constants the reverse difference. The default value represents an integration of order one and lag one with initial values at zero. The format for the initial values is Array{Real,3}(order, variable, lag)"

# Returns
Lagged differences Vector or Array of a given order.

# Examples
```julia-repl

# Order two with Lag two
julia> x = repeat(1:2,30);
julia> dx = d(x,2,2);
julia> x0 = zeros(2,1,2); # lag 2, 1 variable, order 1
julia> x0[1,:,:] = collect(1:2);
julia> p(dx,x0) ≈ x
true

# Calculation of π
julia> x = 0:0.001:1;
julia> y = sqrt.(1 .- x.^2);
julia> isapprox(4*p(y)[end]/1000 , π, atol = 0.01)
true
```
"""
function p(dx::AbstractArray{<:Union{Missing,T}},
           x0::AbstractArray{<:T} = reshape(repeat([0],size(dx,2)),1,:,1)) where T<:Real

    format_ol = "x0 format is Array{Real,3}(order, variable, lag)"
    @assert ndims(x0) <= 3 format_ol

    ndims(x0) == 0 && (x0 = reshape([x0],1,1,1))
    ndims(x0) == 1 && (x0 = reshape(x0,:,1,1))
    ndims(x0) == 2 && (x0 = reshape(x0,:,size(x0,2),1))

    or = size(x0,1)
    la = size(x0,3)
    n = size(dx,1)
    nv = size(dx,2)

    @assert nv == size(x0,2) format_ol
    @assert 0 <= la & la <= (n-1)
    
    if !isnothing(findfirst(ismissing, dx))
        @error "Missing values allowed at the start and end of `dx` but not within."
        if !isnothing(findfirst(isnan, dx))
            @error "NaN values not allowed; use `missing` at the start or end of `dx` but not within."
        end
    end

    px = similar(dx, nv == 1 ? (n+or*la,) : (n+or*la,nv))
    px[1:size(dx,1),:] = dx
    for i in or:-1:1
        for j in 1:la
            pxj  = px[j:la:end,:]
            npxj = size(pxj,1)
            px[j:la:end,:] = cumsum(vcat(x0[i:i,:,j], pxj), dims=1)[1:npxj,:]
        end
    end

    return px
    
end
