# Quadmath.jl

[![Travis Build Status](https://travis-ci.org/JuliaMath/Quadmath.jl.svg?branch=master)](https://travis-ci.org/JuliaMath/Quadmath.jl)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/wx46vbwmu2ey5qkj/branch/master?svg=true)](https://ci.appveyor.com/project/simonbyrne/quadmath-jl/branch/master)

This is a Julia interface to libquadmath, providing a `Float128` type corresponding to the IEEE754 binary128 floating point format.

## Support

Quadmath currently works on x86_64 Linux and macOS.

- It may require a new-ish version of gcc which supports `__float128` type.
- It has not been tested on 32 bit Linux.
- I have not had any luck getting it to work on Windows. It's probably something to do with the calling convention: if someone figures it out I would be very grateful.
- It does not work on ARM due to the lack of libquadmath support for that platform.

## Installation

Quadmath can be installed and tested through the Julia package manager:

```julia
Pkg.add("Quadmath")
Pkg.test("Quadmath")
```

## Acknowledgements

Thank you to Harald Hofstätter, who provided the first iteration of [Quadmath.jl](https://github.com/HaraldHofstaetter/Quadmath.jl).
