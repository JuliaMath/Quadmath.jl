# Quadmath.jl

[![GitHub CI Build Status](https://github.com/JuliaMath/Quadmath.jl/workflows/CI/badge.svg)](https://github.com/JuliaMath/Quadmath.jl/actions)

This is a Julia interface to libquadmath, providing a `Float128` type corresponding to the IEEE754 binary128 floating point format.

## Support

Quadmath currently works on x86_64 Linux, macOS, and Windows.

- It may require a new-ish version of gcc which supports `__float128` type.
- It has not been tested on 32 bit Linux.
- It does not work on ARM due to the lack of libquadmath support for that platform.

## Installation

Quadmath.jl is now a registered package, so can be added via `]add Quadmath`.

## Acknowledgements

Thank you to Harald Hofstätter, who provided the first iteration of [Quadmath.jl](https://github.com/HaraldHofstaetter/Quadmath.jl).
