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
Then 'Quadmath_examples' will be listed in the JuliaBox home screen. The examples contain among others
+ [BesselZeros.ipynb](https://github.com/HaraldHofstaetter/Quadmath.jl/blob/master/examples/BesselZeros.ipynb):
  In this notebook it is demonstrated that `Float128` is about 4 times faster than `BigFloat` with 113 bit precision 
  (the precision of `Float128`).

##Bugs
+  `ccall` does not treat parameters and returning values of Julia type `Float128` properly as C type `__float128`.

    Unfortunately, this is a bug which cannot easily be fixed without modifying the internals of Julia. 
    The [x86-64 Application Binary Interface](http://www.x86-64.org/documentation.html) 
    says that parameters and returning values of type `__float128` should be passed preferably in the (128 bit long) SSE       floating point registers `xmm0`,...,`xmm7`. However, for the datatype `Float128` defined as
    ```julia
    bitstype 128 Float128 <: AbstractFloat
    ```
    in [Quadmath.jl](https://github.com/HaraldHofstaetter/Quadmath.jl/blob/master/src/Quadmath.jl), 
    `ccall` seems to use the same calling convention as for something like 
    ```c
    struct{ 
        uint64_t u0; 
        uint64_t u1;
    } words64;
    ``` 
    in C.
    
    As a remedy, you can implement a wrapper function for each external function with `__float128` parameters 
    or return values, that you want to call with `ccall`. Such a wrapper takes parameters `x` of type 
    `myfloat128` declared as
    ```c
    typedef union
    {
      __float128 value;

      struct{
        uint64_t u0;
        uint64_t u1;
      } words64;
    } myfloat128;
    ```
    and calls the original function with `x.value` as actual parameter for the corresponding formal parameter of type
    `__float128`. 
    This is exactly the technique we use in 
    [quadmath_wrapper.c](https://github.com/HaraldHofstaetter/Quadmath.jl/blob/master/deps/src/quadmath_wrapper.c)
    to call the functions of the [libquadmath](https://gcc.gnu.org/onlinedocs/libquadmath/) library.
    


