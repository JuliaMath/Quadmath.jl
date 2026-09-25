# Quadmath.jl

[![CI](https://github.com/JuliaMath/Quadmath.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaMath/Quadmath.jl/actions/workflows/CI.yml)

This is a Julia interface to the IEEE 754 binary128 floating point format, backed by libquadmath (or libm for some architectures). It provides a `Float128` type and associated functionality.

## Support

Quadmath supports x86_64 and AArch64.

- On AArch64 Linux and FreeBSD, libquadmath is not available, so `long double` functions from libm are used instead. Unlike x86_64, `long double` on AArch64 is IEEE 754 binary128.
- On x86_64, it may require gcc 4.3 or later for the `__float128` type.
- It has not been tested on 32-bit x86 Linux.
- It does not work on 32-bit ARM due to the lack of libquadmath support for that platform.

## Installation

Quadmath.jl is a registered package, so can be added via `]add Quadmath`.

## Acknowledgements

Thank you to Harald Hofstätter, who provided the first iteration of [Quadmath.jl](https://github.com/HaraldHofstaetter/Quadmath.jl).
