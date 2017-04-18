using Base.Test
using Quadmath

for T in (Float64, Int32, Int64)
    @test Float128(T(1)) + Float128(T(2)) == Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) <= Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) != Float128(T(4))
    @test Float128(T(1)) + Float128(T(2)) < Float128(T(4))
    @test T(Float128(T(1)) + Float128(T(2))) === T(3)
end

@test Base.exponent_one(Float128) == reinterpret(UInt128, Float128(1.0))
