using Base.Test
using Quadmath

@test Float128(1) + Float128(2) == Float128(3)
@test Float128(1) + Float128(2) <= Float128(3)
@test Float128(1) + Float128(2) != Float128(4)
@test Float128(1) + Float128(2) < Float128(4)
@test Float64(Float128(1) + Float128(2)) === 3.0

@test Base.exponent_one(Float128) == reinterpret(UInt128, Float128(1))
