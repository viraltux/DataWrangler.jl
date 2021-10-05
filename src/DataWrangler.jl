module DataWrangler

using FFTW, Optim, Smoothers, Statistics

include("impute.jl")
export impute, impute!

include("normalize.jl")
export normalize, normalize!

include("boxcox.jl")
include("normality.jl")
export boxcox, iboxcox

include("d.jl")
include("p.jl")
export d, p

end

"""
Data transformations tools for analytics. The current available methods are:

    boxcox, iboxcox:         Box-Cox and inverse Box-Cox transformation
    normalize, normalize!:   Data normalization (z-score, min-max, softmax, sigmoid)
    impute, impute!:         Data imputation (loess inter/extra-polation, random local density)
    d, p:                    Finite lagged difference and partial difference and its inverse
"""
DataWrangler
