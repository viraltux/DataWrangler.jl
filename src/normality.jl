"""
Jarque–Bera Statistic as a normality measure for optimization
"""
function normality(x::AbstractVector{T}) where T<:Real

    P = Base.promote_op(/, T, T)

    # moments at origin
    n = P(length(x))
    m1 = mo2 = mo3 = mo4 = P(0)
    
    @inbounds for xi in x
        m1 += x1 = xi / n
        mo2 += x2 = x1 * x1 * n
        mo3 += x3 = x1 * x2 * n
        mo4 += x4 = x1 * x3 * n
    end
    
    # moments
    m2 = mo2 - m1^2
    m3 = mo3 - P(3)*m1*mo2 + P(2)*m1^3
    m4 = mo4 - P(4)*m1*mo3 + P(6)*m1^2*mo2 - P(3)*m1^2*m1^2

    S = m3 / (m2 * sqrt(m2))
    K = m4 / m2^2

    n/P(6) * (S^2 + P(1/4) * (K-P(3))^2)
    
end
