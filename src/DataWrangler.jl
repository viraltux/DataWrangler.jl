module DataWrangler

using DataFrames, DataFramesMeta, Distributions, Optim, SQLite, Smoothers, Statistics

include("impute.jl")
export impute, impute!

include("normalize.jl")
export normalize, normalize!


include("boxcox.jl")
include("normality.jl")
export boxcox, iboxcox

end
