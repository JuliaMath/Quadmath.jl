# Derived from Julia Base test suite. License is MIT: https://julialang.org/license

# Small sanity tests to ensure changing the rounding of float functions work
using Base.MathConstants

q1 = one(Float128)
q0 = zero(Float128)

@testset "Arithmetic rounding checks" begin
    # a + b returns a number exactly between prevfloat(1.) and 1., so its
    # final result depends strongly on the utilized rounding direction.
    a = prevfloat(Float128(0.5))
    b = Float128(0.5)
    c = eps(Float128)/4
    d = prevfloat(Float128(1))

    @testset "Default rounding direction, RoundNearest" begin
        @test a + b === q1
        @test - a - b === -q1
        @test a - b === -c
        @test b - a === c
    end
end

@testset "convert with rounding" begin
    for v = [sqrt(Float128(2)),-1/Float128(3),nextfloat(q1),prevfloat(q1),nextfloat(-q1),
             prevfloat(-q1),nextfloat(q0),prevfloat(q0)]

        pn = Float64(v,RoundNearest)
        @test pn == convert(Float64,v)

        pz = Float64(v,RoundToZero)
        @test abs(pz) <= abs(v) < nextfloat(abs(pz))
        @test signbit(pz) == signbit(v)

        pd = Float64(v,RoundDown)
        @test pd <= v < nextfloat(pd)

        pu = Float64(v,RoundUp)
        @test prevfloat(pu) < v <= pu

        @test pn == pd || pn == pu
        @test v > 0 ? pz == pd : pz == pu
        @test pu - pd == eps(pz)
    end

    # numbers which are not represented exactly in Float128
    for T in [Float128,]
        for v in [sqrt(big(2.0)),-big(1.0)/big(3.0),nextfloat(big(1.0)),
                  prevfloat(big(1.0)), nextfloat(big(0.0)),prevfloat(big(0.0)),
                  pi,ℯ,eulergamma,catalan,golden,
                  typemax(Int128),typemax(UInt128),
        ]
            pn = T(v,RoundNearest)
            @test pn == convert(T,BigFloat(v))
            pz = T(v,RoundToZero)
            @test pz == setrounding(()->convert(T,BigFloat(v)), BigFloat, RoundToZero)
            pd = T(v,RoundDown)
            if v == prevfloat(big(0.0))
                @test_broken pd == setrounding(()->convert(T,BigFloat(v)), BigFloat, RoundDown)
            else
                @test pd == setrounding(()->convert(T,BigFloat(v)), BigFloat, RoundDown)
            end
            pu = T(v,RoundUp)
            if v == nextfloat(big(0.0))
                @test_broken pu == setrounding(()->convert(T,BigFloat(v)), BigFloat, RoundUp)
            else
                @test pu == setrounding(()->convert(T,BigFloat(v)), BigFloat, RoundUp)
            end
            @test pn == pd || pn == pu
            @test v > 0 ? pz == pd : pz == pu
            @test isinf(pu) || pu - pd == eps(pz)
        end
    end
end

@testset "rounding properties" for Tf in [Float128,]
    # these should hold for all u, but we just test the smallest and largest
    # of each binade

    for i in exponent(floatmin(Tf)):exponent(floatmax(Tf))
        for u in [ldexp(Tf(1.0), i), -ldexp(Tf(1.0), i),
                  ldexp(prevfloat(Tf(2.0)), i), -ldexp(prevfloat(Tf(2.0)), i)]

            r = round(u, RoundNearest)
            if isfinite(u)
                @test isfinite(r)
                @test isinteger(r)
                @test abs(r-u) < 0.5 || abs(r-u) == 0.5 && isinteger(r/2)
                @test signbit(u) == signbit(r)
            else
                @test u === r
            end

            r = round(u, RoundNearestTiesAway)
            if isfinite(u)
                @test isfinite(r)
                @test isinteger(r)
                @test abs(r-u) < 0.5 || (r-u) == copysign(0.5,u)
                @test signbit(u) == signbit(r)
            else
                @test u === r
            end

            r = round(u, RoundNearestTiesUp)
            if isfinite(u)
                @test isfinite(r)
                @test isinteger(r)
                @test -0.5 < r-u <= 0.5
                @test signbit(u) == signbit(r)
            else
                @test u === r
            end

            r = round(u, RoundFromZero)
            if isfinite(u)
                @test isfinite(r)
                @test isinteger(r)
                @test signbit(u) ? (r == floor(u)) : (r == ceil(u))
                @test signbit(u) == signbit(r)
            else
                @test u === r
            end
        end
    end
end

@testset "rounding difficult values" begin
    for x = Int128(2)^113-10:Int128(2)^113+10
        y = Float128(x)
        i = trunc(Int128,y)
        @test Int128(trunc(y)) == i
        @test Int128(round(y)) == i
        @test Int128(floor(y)) == i
        @test Int128(ceil(y))  == i

        @test round(Int128,y)       == i
        @test floor(Int128,y)       == i
        @test ceil(Int128,y)        == i
    end

    # rounding vectors
    let ≈(x,y) = x==y && typeof(x)==typeof(y)
        for t in [Float128,]
            # try different vector lengths
            for n in [0,3,255,256]
                r = (1:n) .- div(n,2)
                y = t[x/4 for x in r]
                @test trunc.(y) ≈ t[div(i,4) for i in r]
                @test floor.(y) ≈ t[i>>2 for i in r]
                @test ceil.(y)  ≈ t[(i+3)>>2 for i in r]
                @test round.(y) ≈ t[(i+1+isodd(i>>2))>>2 for i in r]
                @test broadcast(x -> round(x, RoundNearestTiesAway), y) ≈ t[(i+1+(i>=0))>>2 for i in r]
                @test broadcast(x -> round(x, RoundNearestTiesUp), y) ≈ t[(i+2)>>2 for i in r]
                @test broadcast(x -> round(x, RoundFromZero), y) ≈ t[(i+3*(i>=0))>>2 for i in r]
            end
        end
    end

    @test_throws InexactError round(Int,Float128(Inf))
    @test_throws InexactError round(Int,Float128(NaN))
    @test round(Int,Float128(2.5)) == 2
    @test round(Int,Float128(1.5)) == 2
    @test round(Int,Float128(-2.5)) == -2
    @test round(Int,Float128(-1.5)) == -2
    @test round(Int,Float128(2.5),RoundNearestTiesAway) == 3
    @test round(Int,Float128(1.5),RoundNearestTiesAway) == 2
    @test round(Int,Float128(2.5),RoundNearestTiesUp) == 3
    @test round(Int,Float128(1.5),RoundNearestTiesUp) == 2
    @test round(Int,Float128(-2.5),RoundNearestTiesAway) == -3
    @test round(Int,Float128(-1.5),RoundNearestTiesAway) == -2
    @test round(Int,Float128(-2.5),RoundNearestTiesUp) == -2
    @test round(Int,Float128(-1.5),RoundNearestTiesUp) == -1
    @test round(Int,Float128(-1.9)) == -2
    @test round(Int,nextfloat(q1),RoundFromZero) == 2
    @test round(Int,-nextfloat(q1),RoundFromZero) == -2
    @test round(Int,prevfloat(q1),RoundFromZero) == 1
    @test round(Int,-prevfloat(q1),RoundFromZero) == -1
    #=
    FIXME: want analogs
    @test_throws InexactError round(Int64, 9.223372036854776e18)
    @test       round(Int64, 9.223372036854775e18) == 9223372036854774784
    @test_throws InexactError round(Int64, -9.223372036854778e18)
    @test       round(Int64, -9.223372036854776e18) == typemin(Int64)
    @test_throws InexactError round(UInt64, 1.8446744073709552e19)
    @test       round(UInt64, 1.844674407370955e19) == 0xfffffffffffff800
    =#
    for Ti in [Int,UInt]
        for Tf in [Float128,]
            # Note: these threw InexactError
            @test round(Ti,Tf(-0.0)) == 0
            @test round(Ti,Tf(-0.0),RoundNearestTiesAway) == 0
            @test round(Ti,Tf(-0.0),RoundNearestTiesUp) == 0

            @test round(Ti, Tf(0.5)) == 0
            @test round(Ti, Tf(0.5), RoundNearestTiesAway) == 1
            @test round(Ti, Tf(0.5), RoundNearestTiesUp) == 1

            @test round(Ti, prevfloat(Tf(0.5))) == 0
            @test round(Ti, prevfloat(Tf(0.5)), RoundNearestTiesAway) == 0
            @test round(Ti, prevfloat(Tf(0.5)), RoundNearestTiesUp) == 0

            @test round(Ti, nextfloat(Tf(0.5))) == 1
            @test round(Ti, nextfloat(Tf(0.5)), RoundNearestTiesAway) == 1
            @test round(Ti, nextfloat(Tf(0.5)), RoundNearestTiesUp) == 1
            # Note: these threw InexactError
            @test round(Ti, Tf(-0.5)) == 0
            @test round(Ti, Tf(-0.5), RoundNearestTiesUp) == 0

            @test round(Ti, nextfloat(Tf(-0.5))) == 0
            @test round(Ti, nextfloat(Tf(-0.5)), RoundNearestTiesAway) == 0
            @test round(Ti, nextfloat(Tf(-0.5)), RoundNearestTiesUp) == 0

            if Ti <: Signed
                @test round(Ti, Tf(-0.5), RoundNearestTiesAway) == -1
                @test round(Ti, prevfloat(Tf(-0.5))) == -1
                @test round(Ti, prevfloat(Tf(-0.5)), RoundNearestTiesAway) == -1
                @test round(Ti, prevfloat(Tf(-0.5)), RoundNearestTiesUp) == -1
            else
                @test_throws InexactError round(Ti, Tf(-0.5), RoundNearestTiesAway)
                @test_throws InexactError round(Ti, prevfloat(Tf(-0.5)))
                @test_throws InexactError round(Ti, prevfloat(Tf(-0.5)), RoundNearestTiesAway)
                @test_throws InexactError round(Ti, prevfloat(Tf(-0.5)), RoundNearestTiesUp)
            end
        end
    end

    # numbers that can't be rounded by trunc(x+0.5)
    @test round(Int128, Float128(2.0)^112 + 1) == (UInt128(1) << 112) + 1
end

# custom rounding and significant-digit ops
@testset "rounding to digits relative to the decimal point" begin
    @test round(Float128(pi)) ≈ 3.
    @test round(Float128(pi), base=10) ≈ 3.
    @test round(Float128(pi), digits=0) ≈ 3.
    @test round(Float128(pi), digits=1) ≈ 3.1
    @test round(Float128(pi), digits=3, base=2) ≈ 3.125
    @test round(Float128(pi), sigdigits=1) ≈ 3.
    @test round(Float128(pi), sigdigits=3) ≈ 3.14
    @test round(Float128(pi), sigdigits=4, base=2) ≈ 3.25
    @test round(10*Float128(pi), digits=-1) ≈ 30.
    @test round(Float128(.1), digits=0) == 0.
    @test round(Float128(-.1), digits=0) == -0.
    @test isnan(round(Float128(NaN), digits=2))
    @test isinf(round(Float128(Inf), digits=2))
    @test isinf(round(Float128(-Inf), digits=2))
end
@testset "round vs trunc vs floor vs ceil" begin
    @test round(Float128(123.456), digits=1) ≈ 123.5
    @test round(-Float128(123.456), digits=1) ≈ -123.5
    @test trunc(Float128(123.456), digits=1) ≈ 123.4
    @test trunc(-Float128(123.456), digits=1) ≈ -123.4
    @test ceil(Float128(123.456), digits=1) ≈ 123.5
    @test ceil(-Float128(123.456), digits=1) ≈ -123.4
    @test floor(Float128(123.456), digits=1) ≈ 123.4
    @test floor(-Float128(123.456), digits=1) ≈ -123.5
end
@testset "rounding with too much (or too few) precision" begin
    for x in (12345.6789, 0, -12345.6789)
        y = Float128(x)
        @test y == trunc(x, digits=1000)
        @test y == round(x, digits=1000)
        @test y == floor(x, digits=1000)
        @test y == ceil(x, digits=1000)
    end
    let x = Float128(12345.6789)
        @test 0.0 == trunc(x, digits=-1000)
        @test 0.0 == round(x, digits=-1000)
        @test 0.0 == floor(x, digits=-1000)
        @test Inf128 == ceil(x, digits=-10000)
    end
    let x = Float128(-12345.6789)
        @test -0.0 == trunc(x, digits=-1000)
        @test -0.0 == round(x, digits=-1000)
        @test -Inf128 == floor(x, digits=-10000)
        @test -0.0 == ceil(x, digits=-1000)
    end
    let x = q0
        @test 0.0 == trunc(x, digits=-1000)
        @test 0.0 == round(x, digits=-1000)
        @test 0.0 == floor(x, digits=-1000)
        @test 0.0 == ceil(x, digits=-1000)
    end
end
@testset "rounding in other bases" begin
    @test round(Float128(pi), digits = 2, base = 2) ≈ 3.25
    @test round(Float128(pi), digits = 3, base = 2) ≈ 3.125
    @test round(Float128(pi), digits = 3, base = 5) ≈ 3.144
end

if VERSION >= v"1.11"
@testset "rounding floats with specified return type #50778" begin
    @test round(Float128, Float128(1.2)) === q1
end

# The libmpfr shipped with Julia is built without float128 support, so we can't
# easily do comparisons to conversion and rounding by library calls.
# If this situation changes, consider adapting more tests from Base.

@testset "floor(<:AbstractFloat, large_number) (#52355)" begin
    for i in [-BigInt(floatmax(Float128)), -BigInt(floatmax(Float128))*100,
              BigInt(floatmax(Float128)), BigInt(floatmax(Float128))*100]
        f = ceil(Float128, i)
        @test f >= i
        @test isinteger(f) || isinf(f)
        @test prevfloat(f) < i
    end
end
end
