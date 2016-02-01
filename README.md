# Quadmath.jl
Float128 and libquadmath for the Julia language

##Installation
```julia
Pkg.clone("https://github.com/HaraldHofstaetter/Quadmath.jl")
Pkg.build("Quadmath")
```
##Examples
To get easy access to the examples, make a symbolic link in the home directory:
```julia
symlink(joinpath(homedir(), ".julia/v0.4/Quadmath/examples/"), joinpath(homedir(), "Quadmath_examples"))
```
Then 'TSSM_examples' will be listed in the JuliaBox home screen. The examples contain among others
+ [BesselZeros.ipynb](https://github.com/HaraldHofstaetter/Quadmath.jl/blob/master/examples/BesselZeros.ipynb):
  In this notebook it is demonstrated that Float128 is about 4 times faster than BigFloat with 113 bit precision 
  (the precision of Float128).
