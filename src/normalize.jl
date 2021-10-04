"""
Package: DataWrangler

normalize(x; ...
normalize!(x; ...

"""
function normalize!(x::AbstractArray{<:Union{Missing,T}};
                 type::String = "z-score") where T<:Real
    
    @assert !(T <: Integer) "Vector with Integers cannot be updated in place, use `normalize(x)` instead"

    @assert type ∈ ["z-score","min-max","softmax","sigmoid"]

    smx = skipmissing(x)

    if type == "z-score"
        μ = mean(smx)
        σ = std(smx)
        for i in CartesianIndices(x)
            x[i] = (x[i] - μ) / σ
        end
    end

    if type == "min-max"
        m,M = extrema(smx)
        Mm = M-m
        for i in CartesianIndices(x)
            x[i] = (x[i] - m) / Mm
        end
    end

    if type == "softmax"
        Σe = sum(exp.(smx))
        for i in CartesianIndices(x)
            x[i] = exp(x[i]) / Σe
        end
    end

    if type == "sigmoid"
        for i in CartesianIndices(x)
            x[i] = 1/(1+exp(-x[i]))
        end
    end

end

function normalize(x::AbstractArray{<:Union{Missing,T}};
                type::String = "z-score") where T<:Real    

    P = any(ismissing,x) ? Union{Missing, Base.promote_op(/,T,T)} : Base.promote_op(/,T,T)
    cx = Array{P}(undef,size(x))
    cx[:] = x
    normalize!(cx; type)
    return cx
    
end
