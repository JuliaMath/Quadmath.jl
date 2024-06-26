using SpecialFunctions

@testset "special functions" begin
    # The intention here is not to check the accuracy of the libraries,
    # rather the sanity of library calls:
    piq = Float128(pi)
    halfq = Float128(0.5)
    @test gamma(halfq) ≈ sqrt(piq)
    for func in (erf, erfc, besselj0, besselj1, bessely0, bessely1, loggamma)
        @test func(halfq) ≈ func(0.5)
    end
    for func in (bessely, besselj)
        @test func(3,halfq) ≈ func(3,0.5)
    end
    @test gamma(Float128(2),3) ≈ gamma(2,3)
    @test all(logabsgamma(Float128(-0.5)) .≈ logabsgamma(-0.5))
    @test all(logabsgamma(Float128(-1.5)) .≈ logabsgamma(-1.5))
end
