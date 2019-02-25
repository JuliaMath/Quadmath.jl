using Test
using Quadmath

@testset "conversion $T" for T in (Float64, Int32, Int64, BigFloat)
    @test Float128(T(1)) + Float128(T(2)) == Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) <= Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) != Float128(T(4))
    @test Float128(T(1)) + Float128(T(2)) < Float128(T(4))
    if isbitstype(T)
        @test T(Float128(T(1)) + Float128(T(2))) === T(3)
    end
end

@test Base.exponent_one(Float128) == reinterpret(UInt128, Float128(1.0))

@testset "BigFloat" begin
    x = parse(Float128, "0.1")
    y = parse(Float128, "0.2")
    @test Float64(x+y) == Float64(BigFloat(x) + BigFloat(y))
    @test x+y == Float128(BigFloat(x) + BigFloat(y))
end
