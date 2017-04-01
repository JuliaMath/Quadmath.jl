using Base.Test
using Quadmath

@test Float128(1.0) + Float128(2.0) == Float128(3.0)
@test Float128(1.0) + Float128(2.0) <= Float128(3.0)
@test Float128(1.0) + Float128(2.0) != Float128(4.0)
@test Float128(1.0) + Float128(2.0) < Float128(4.0)
@test Float64(Float128(1.0) + Float128(2.0)) === 3.0

@test Base.exponent_one(Float128) == reinterpret(UInt128, Float128(1.0))
