"""
Package: DataWrangler

outlie\\[!\\]([x], y, σ = 2; q)

Replace or detect outlier values in vector `x` describing a time series

# Parameters
- `x`: Optional vector containing the support for `y` (no missing value allowed)
- `y`: Vector with outliers to be dealt with
- `σ`: Number of sigmas used to identify outliers, it defaults to four.
- `q`: Number of closest vector values to the imputation to be considered, it defaults to 3*length(y)÷4).

# Description

When using `outlie!` the function replaces outliers with a `missing` value and return the index of the values replaced, if `outlie` is used isntead only the outliers index poistion are returned.

Outliers are indentified by measureing its distance in number of sigmas estimated from a loess fitting with window `q`. When datasets with noise close to zero all outliers will still be detected but non-outliers might be indentified as such, a way to prevent non-outliers to be indentified in this situtaion is by introducing a small amount of noise ϵ in `y`, e.g. `outlie!(x,y+ϵ)`.

# Examples
```julia        
n = 1000
x = sort(rand(n))*2*pi;
y = Array{Union{Missing,Float64}}(undef,n);
y[:] = sin.(x).+randn(n)/10
mid = vcat(100,300,600,950);
y[mid] .= x[mid] .+ 2*(randn(length(mid)).+1)
y[500] = x[500] - 2*(randn(1)[1]+1)

outlie(x,y)

julia> outlie(x,y)
5-element Vector{Int64}:
 100
 300
 500
 600
 950
```
"""
function outlie(y::AbstractVector{<:Union{Missing,T}}, nσ::Real=4.0;
                q = 3*length(y)÷4) where  {R<:Real,T<:Real}
    cy = copy(y)
    outlie!(1:length(y),cy,nσ;q)
end

function outlie(x::AbstractVector{R}, y::AbstractVector{<:Union{Missing,T}}, nσ::Real=4.0;
                 q = 3*length(y)÷4) where  {R<:Real,T<:Real}
    cy = copy(y)
    outlie!(x,cy,nσ;q)
end

function outlie!(y::AbstractVector{<:Union{Missing,T}}, nσ::Real=4.0;
                q = 3*length(y)÷4) where  {R<:Real,T<:Real}
    outlie!(1:length(y),y,nσ;q)
end

function outlie!(x::AbstractVector{R}, y::AbstractVector{<:Union{Missing,T}}, nσ::Real=4.0;
                 q = 3*length(y)÷4) where  {R<:Real,T<:Real}
    allout = Int64[]
    eo = Int64[0]
    while !isempty(eo)
        eo = outlie1!(x,y,nσ;q)
        push!(allout,eo...)
    end
    sort(allout)
end

function outlie1!(x::AbstractVector{R}, y::AbstractVector{<:Union{Missing,T}}, nσ::Real=4.0;
                  q = 3*length(y)÷4) where  {R<:Real,T<:Real}

    @assert nσ > 1 "`nσ` should be larger than one"
    @assert !any(ismissing, x) "No missing values allowed in `x`"
    @assert issorted(x) "`x` values must be sorted"
    @assert length(x) == length(y) "`x` and `y` must have the same length"


    loq = loess(x,y; q)
    loqy = loq(x)

    dy = y-loqy
    dy = dy .- median(skipmissing(dy))
    sdy = collect(skipmissing(sort(dy)))
    lsdy = length(sdy)
    sdy = sdy[lsdy÷10:end-lsdy÷10]  # robust sd
    dσ = std(skipmissing(sdy))*T(sqrt(2))

    outlist = findall(v-> abs(v) > nσ*dσ, skipmissing(dy))

    y[outlist] .= missing
    outlist

end
