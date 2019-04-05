using Test
using Quadmath

@testset "fp decomp" begin
    y = Float128(2.0)
    x,n = frexp(y)
    @test x == Float128(0.5)
    @test n == 2
    z = ldexp(Float128(0.5), 2)
    @test z == y
end

@testset "conversion $T" for T in (Float32, Float64, Int32, Int64, Int128, UInt32, UInt64, UInt128, BigFloat, BigInt)
    @test Float128(T(1)) + Float128(T(2)) == Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) <= Float128(T(3))
    @test Float128(T(1)) + Float128(T(2)) != Float128(T(4))
    @test Float128(T(1)) + Float128(T(2)) < Float128(T(4))
    if isbitstype(T)
        @test T(Float128(T(1)) + Float128(T(2))) === T(3)
    else
        @test T(Float128(T(1)) + Float128(T(2))) == T(3)
    end
end

@testset "conversion $T exceptions" for T in (Int32, Int64, UInt32, UInt64)
    x = Float128(typemax(T))
    @test_throws InexactError T(x+Float128(1))
    x = Float128(typemin(T))
    @test_throws InexactError T(x-Float128(1))
end

@testset "conversion $T exceptions" for T in (Float32, Float64)
    x = Float128(typemax(T))
    @test isinf(T(x+Float128(1)))
    x = Float128(typemin(T))
    @test isinf(T(x-Float128(1)))
end

@test Base.exponent_one(Float128) == reinterpret(UInt128, Float128(1.0))

@testset "BigFloat" begin
    x = parse(Float128, "0.1")
    y = parse(Float128, "0.2")
    @test Float64(x+y) == Float64(BigFloat(x) + BigFloat(y))
    @test x+y == Float128(BigFloat(x) + BigFloat(y))
end

@testset "BigInt" begin
    x = parse(Float128, "100.0")
    y = parse(Float128, "25.0")
    @test Float64(x+y) == Float64(BigInt(x) + BigInt(y))
    @test x+y == Float128(BigInt(x) + BigInt(y))    
end

@testset "flipsign" begin
    x = Float128( 2.0)
    y = Float128(-2.0)
    @test x == flipsign(y, -one(Float128))
    @test y == flipsign(y,  1)
end

@testset "arithmetic" begin
    fpi = Float128(pi)
    finvpi = inv(fpi)
    @test (fpi + 3) - fpi == 3
    @test fpi * finvpi === one(Float128)
    @test finvpi / fpi == finvpi^2
end

@testset "modf" begin
    x = Float128(pi)
    fpart, ipart = modf(x)
    @test x == ipart + fpart
    @test signbit(fpart) == signbit(ipart) == false

    y = Float128(-pi)
    fpart, ipart = modf(y)
    @test y == ipart + fpart
    @test signbit(fpart) == signbit(ipart) == true
    
    z = x^3
    fpart, ipart = modf(x) .+ modf(y)
    @test x+y == ipart+fpart
end

@testset "transcendental etc. calls" begin
    # at least enough to cover all the wrapping code
    x = sqrt(Float128(2.0))
    xd = Float64(x)
    @test (x^Float128(4.0)) ≈ Float128(4.0)
    @test exp(x) ≈ exp(xd)
    @test abs(x) == x
    @test hypot(Float128(3),Float128(4)) == Float128(5)
    @test atan(x,x) ≈ Float128(pi) / 4
    @test fma(x,x,Float128(-1.0)) ≈ Float128(1)
end

@testset "string conversion" begin
    s = string(Float128(3.0))
    p = r"3\.0+e\+0+"
    m = match(p, s)
    @test (m != nothing) && (m.match == s)
    @test parse(Float128,"3.0") == Float128(3.0)
end

include("specfun.jl")
