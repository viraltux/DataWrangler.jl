# DataWrangler

> :warning: Under development

Data wrangling refers to a number of processes designed to clean and transform data into into analytics ready datasets.

This package provides the following functionality to wrangle data:

- boxcox, iboxcox:         Box-Cox and inverse Box-Cox transformation
- d, p:                    Finite lagged difference and partial difference and its inverse
- impute, impute!:         Data imputation (loess inter/extra-polation, random local density)
- inlie, inlie!:           Removal of outliers 
- normalize, normalize!:   Data normalization (z-score, min-max, softmax, sigmoid)

<img src="./docs/src/images/impute.png">

[![Build Status](https://github.com/viraltux/DataWrangler.jl/workflows/CI/badge.svg)](https://github.com/viraltux/DataWrangler.jl/actions)
[![Coverage](https://codecov.io/gh/viraltux/DataWrangler.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/viraltux/DataWrangler.jl)
