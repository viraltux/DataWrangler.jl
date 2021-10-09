module DataWrangler

using FFTW, Optim, Smoothers, Statistics

include("impute.jl")
export impute, impute!

include("outlie.jl")
export outlie, outlie!

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
    d, p:                    Finite lagged difference and partial difference and its inverse
    impute, impute!:         Data imputation (loess inter/extra-polation, random local density)
    normalize, normalize!:   Data normalization (z-score, min-max, softmax, sigmoid)
    outlie, outlie!:         Outlier detection and removal in time series

"""
DataWrangler
