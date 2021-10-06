"""
Package: DataWrangler

normalize\\[!\\]([x]; method)

Normalize values in vector `x` either in-place or returning a copy of `x` with the imputed values

# Parameters

`x`: Vector of type Real with missing values to be imputed

`method`: There are four valid values: "z-score", "min-max", "softmax", "sigmoid"

# Description

The normalization is applied ignoring any missing values in the Array, and it takes place in all the available dimensions of the array. If normalization is required in just some specific dimensions the function `mapslices` can be used to select those dimensions.

# Example
```julia
x = [1.,2,3,4,5]
normalize!(x; method = "min-max")

println(x)
[0.0, 0.25, 0.5, 0.75, 1.0]
```
"""
function normalize!(x::AbstractArray{<:Union{Missing,T}};
                 method::String = "z-score") where T<:Real
    
    @assert !(T <: Integer) " Method `$(typeof(x))` cannot be normalized in-place, use `normalize(x)` instead"

    @assert method ∈ ["z-score","min-max","softmax","sigmoid"]

    smx = skipmissing(x)

    if method == "z-score"
        μ = mean(smx)
        σ = std(smx)
        for i in CartesianIndices(x)
            x[i] = (x[i] - μ) / σ
        end
    end

    if method == "min-max"
        m,M = extrema(smx)
        Mm = M-m
        for i in CartesianIndices(x)
            x[i] = (x[i] - m) / Mm
        end
    end

    if method == "softmax"
        Σe = sum(exp.(smx))
        for i in CartesianIndices(x)
            x[i] = exp(x[i]) / Σe
        end
    end

    if method == "sigmoid"
        for i in CartesianIndices(x)
            x[i] = 1/(1+exp(-x[i]))
        end
    end

end

"""
Package: DataWrangler

Check 'normalize! for further information.
"""
function normalize(x::AbstractArray{<:Union{Missing,T}};
                method::String = "z-score") where T<:Real    

    P = any(ismissing,x) ? Union{Missing, Base.promote_op(/,T,T)} : Base.promote_op(/,T,T)
    cx = Array{P}(undef,size(x))
    cx[:] = x
    normalize!(cx; method)
    return cx
    
end
