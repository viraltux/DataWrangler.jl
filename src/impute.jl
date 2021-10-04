"""
"""
function impute!(y::AbstractVector{<:Union{Missing,T}};
                 type::String = "loess", q = 3*length(y)÷4) where  {T<:Real}

    impute!(T.(1:length(y)),y; type, q)

end


function impute!(x::AbstractVector{R},
                 y::AbstractVector{<:Union{Missing,T}};
                 type::String = "loess", q = 3*length(y)÷4) where  {R<:Real,T<:Real}

    @assert issorted(x) "x values must be sorted"
    @assert length(x) == length(y) "x and y must have the same length"

    @assert type ∈ ["loess","uniform","normal"]
    @assert !(T <: Integer) "Vector with Integers cannot be updated in place, use `impute(x)` instead"


    impxi = findall(ismissing,y)
    impx = x[impxi]

    length(impx) == 0 && return nothing
    
    if type == "loess"
        y[impxi] = loess(x,y; q)(impx)
    end

    if type == "normal"
        n = length(x)
        for (ixi,ix) in zip(impxi,impx)
            xv = @. abs(x-ix)
            qidx = sortperm(xv)[1:min(q,n)]
            μ = mean(skipmissing(y[qidx]))
            σ = std(skipmissing(y[qidx]))
            y[ixi] = μ + randn(1)[1] * σ
        end
    end

    if type == "uniform"
        n = length(x)
        for (ixi,ix) in zip(impxi,impx)
            xv = @. abs(x-ix)
            qidx = sortperm(xv)[1:min(q,n)]
            m,M = extrema(skipmissing(y[qidx]))
            y[ixi] = m + rand(1)[1] * (M-m)
        end
    end

end

function impute(y::AbstractVector{<:Union{Missing,T}};
                 type::String = "loess", q = 3*length(y)÷4) where  {T<:Real}

    impute(T.(1:length(y)),y; type, q)

end

function impute(x::AbstractVector{R},
                y::AbstractVector{<:Union{Missing,T}};
                type::String = "loess", q = 3*length(y)÷4) where  {R<:Real,T<:Real}

    P = any(ismissing,y) ? Union{Missing, Base.promote_op(/,T,T)} : Base.promote_op(/,T,T)
    cy = Vector{P}(undef,length(y))
    cy[:] = y
    impute!(x,cy; type, q)
    return cy
    
end

