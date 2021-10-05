"""
Package: DataWrangler

    function d(x::{AbstractVector, AbstractArray},
               or::Int=1,
               la::Int=1;
               center::Bool=false)

Return Lagged differences of a given Vector or Array.

# Arguments
- `x`: Vector or Array of data.
- `or`: Order of the differences; number of recursive iterations on the same vector/array.
- `la`: Lag for the difference.
- `center`: Center the result in the response using Missing values.

# Returns
Laged differences Vector or Array of a given order.

# Examples
```julia-repl
julia> x = [1,2,3,4,5];
julia> d(x)
4-element Vector{Int64}:
 1
 1
 1
 1

julia> d(x,2)
3-element Vector{Int64}:
 0
 0
 0

julia> d(x,1,2)
3-element Vector{Int64}:
 2
 2
 2

julia> x = reshape(collect(1:20),10,2);

julia> d(x,2,2)
6×2 Matrix{Int64}:
 0  0
 0  0
 0  0
 0  0
 0  0
 0  0

julia> d(d(x,1,2),1,2) == d(x,2,2)
true
```
"""
function d(x::AbstractArray{<:Union{Missing,T}},
           order::Int=1,
           lag::Int=1;
           center::Bool=false) where T<:Real

    (lag == 0) | (order == 0) && (return x)

    n = size(x,1)
    nv = size(x,2)

    @assert 0 <= lag <= (n-1) "Lag must be larger or equal to size(x,1)"
    
    dx = x
    for i in order:-1:1
        dx = (dx .- circshift(dx,lag))[1+lag:end,:]
    end

    if center
        nl = n-size(dx,1)
        dx = vcat(dx, Array{Any}(missing,nl,size(x,2)))
        dx = circshift(dx,(div(nl,2),0))
    end

    return size(dx,2) == 1 ? dx[:,1] : dx

end

# Fractional Difference
function d(x::AbstractVector{<:T}, d::T;
           scale::T = T(size(x,1))) where T<:AbstractFloat
    
    N = size(x,1)
    np2 = nextpow(2,2*N-1)
    k = 1:N-1
    b = [T(1); cumprod((k.-d.-T(1))./k)]
    pad0 = zeros(T,np2-N)
    dx1 = fft(vcat(b,pad0))
    dx2 = fft(vcat(x,pad0))
    dx = ifft(dx2 .* dx1)
    vec(real(dx[1:N,:])) .* (N/scale)^d
    
end
