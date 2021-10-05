"""
Package: DataWrangler

impute\\[!\\]([x], y; method, q)

Impute missing values in vector `y` either in-place or returning vector `y` with the imputed values.

# Parameters
`x`: Optional vector containing the support for `y` (no missing value allowed)

`y`: Vector of type Real with missing values to be imputed
`method`: There are three valid values:
- "loess": Runs loess with a window size of `q` on the dataset and interpolate/extrapolate results on the `missing` values. 
- "uniform": Random imputation using an Uniform empirical distribution based on the size of `q`.
- "normal": Random imputation using a Normal empirical distribution based on the size of `q`.

`q`: Number of closest vector values to the imputation to be considered, it defaults to 3*length(y)÷4).

# Description

The imputation replaces missing values either with loess, local random uniform or local random normal methods. When the vector's type is of Integers then a rounding is performed on the results.

# Returns

Nothing if the imputation is done in-place or the original vector `y` with all the missing values imputed.

# Examples
```julia        
x = sort(rand(100));
y = Array{Union{Missing,Float64}}(undef,100);
y[:] = rand(100);
y[rand(1:100,10)] .= missing;

impute!(x,y)
```
"""
function impute!(y::AbstractVector{<:Union{Missing,T}};
                 method::String = "loess", q = 3*length(y)÷4) where  {T<:Real}

    impute!(T.(1:length(y)),y; method, q)

end

function impute!(x::AbstractVector{R},
                 y::AbstractVector{<:Union{Missing,T}};
                 method::String = "loess", q = 3*length(y)÷4) where  {R<:Real,T<:Real}

    @assert !any(ismissing, x) "No missing values allowed in `x`"
    @assert issorted(x) "x values must be sorted"
    @assert length(x) == length(y) "x and y must have the same length"

    @assert method ∈ ["loess","uniform","normal"]
    # @assert !(T <: Integer) "Vector with Integers cannot be updated in place, use `impute(x)` instead"

    impxi = findall(ismissing,y)
    impx = x[impxi]

    length(impx) == 0 && return nothing
    
    if method == "loess"
        loess_impx = loess(x,y; q)(impx)
        y[impxi] = T <: Integer ? round.(T,loess_impx) : loess_impx
    end

    if method == "normal"
        n = length(x)
        rnd = randn(n)
        for (i,(ixi,ix)) in enumerate(zip(impxi,impx))
            xv = @. abs(x-ix)
            qidx = sortperm(xv)[1:min(q,n)]
            μ = mean(skipmissing(y[qidx]))
            σ = std(skipmissing(y[qidx]))
            y[ixi] = T <: Integer ? round(T, μ + rnd[i] * σ) : μ + rnd[i] * σ
        end
    end

    if method == "uniform"
        n = length(x)
        for (i,(ixi,ix)) in enumerate(zip(impxi,impx))
            xv = @. abs(x-ix)
            qidx = sortperm(xv)[1:min(q,n)]
            m,M = extrema(skipmissing(y[qidx]))
            y[ixi] = rand(m:M)
        end
    end

end


"""
Package: DataWrangler

Check 'impute! for further information.
"""
function impute(y::AbstractVector{<:Union{Missing,T}};
                 method::String = "loess", q = 3*length(y)÷4) where  {T<:Real}

    impute(T.(1:length(y)),y; method, q)

end

function impute(x::AbstractVector{R},
                y::AbstractVector{<:Union{Missing,T}};
                method::String = "loess", q = 3*length(y)÷4) where  {R<:Real,T<:Real}

    P = any(ismissing,y) ? Union{Missing, Base.promote_op(/,T,T)} : Base.promote_op(/,T,T)
    cy = Vector{P}(undef,length(y))
    cy[:] = y
    impute!(x,cy; method, q)
    return cy
    
end

